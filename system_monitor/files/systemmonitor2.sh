#!/bin/sh

# Disk monitor script sends out an email to RECIP if any of the available
# disk space exceed LIMIT in %.

ARG=$1

if [ -z $ARG ];then
  echo "Usage: $0 CPU|MEM|DISK|MAXCPU"
  exit 0
fi

RECIP="lgf-server-info@logfirellc.com,serveralerts@logfirellc.com,amurugan@logfirellc.com"
LIMIT=85
CPU_THRESHOLD=95
MEM_THRESHOLD=10
MAXCPU_TIME_THRESHOLD=45

TOP_X=3
LOG="/root/logs/systemlogs/Resources-$ARG-`date +\%d\%m`.log"
ERRLOG="/tmp/RunAwayResources-$ARG"
echo "ALL OK -`date`" >>$LOG

mem()
{
MEM_LINE=$(ps wwaxm -o %mem,command |sort -k 1 -r | head -2 | tail -1)
MEM_USAGE=`echo $MEM_LINE | sed 's/\ .*//'` 
MEM_USAGE=${MEM_USAGE/\.*} 

if [ $MEM_USAGE -gt $MEM_THRESHOLD ] ; then
   MEM_USER=`echo $MEM_LINE | sed -e 's/.*\///'` 
   

   echo 'Alert: Process' $MEM_USER 'is using' $MEM_USAGE'% memory ' - `date` > $ERRLOG
   echo "" >> $ERRLOG
   echo "TOP $TOP_X processes by MEM usage" >> $ERRLOG
   echo "----------------------------" >> $ERRLOG
   let "TOP_X += 1" 
   ps wwaxm -o pid,stat,%mem,time,command|sort -k 1 -r  | head -4 >> $ERRLOG
   echo "*********************************************************************" >>$ERRLOG
   echo " Server STATE: - `date`" >>$ERRLOG
   top -b -n 1 -c | head -30 >>$ERRLOG
   echo "*********************************************************************" >>$ERRLOG
   
   # Append it to main log
   cat $ERRLOG >>$LOG
   cat $ERRLOG | mail -s "Alert: Process $MEM_USER is using $MEM_USAGE %memory - `date` "$RECIP


fi
}

cpu2()
{

numcpus=`cat /proc/cpuinfo|grep "processor[^:0-9a-zA-Z]*[:]" |wc -l`
maxn=`expr $numcpus "/" 6`
if [ $maxn -eq 0 ];
then
   maxn=1
fi
np1=`expr $maxn + 1`

x1=`ps wwax -o %cpu |head -$np1|tail -$maxn`

cpu_alert=1
for x in $x1
do
   x=${x/\.*}
   if [ $x -lt $CPU_THRESHOLD ]; then
       cpu_alert=0
       break
   fi
done

echo "cpu2 $np1  $cpu_alert" >>$LOG

if [ $cpu_alert -eq 1 ] ; then

     echo "Alert: $maxn processes are using high CPU - `date`" > $ERRLOG
     echo "" >> $ERRLOG
     echo "TOP $maxn processes by CPU usage" >> $ERRLOG
     echo "----------------------------" >> $ERRLOG
     
     ps wwaxr -o pid,stat,%cpu,time,command |sort -k 1 -r | head -$np1 >> $ERRLOG

     echo "*********************************************************************" >>$ERRLOG
     echo " Server STATE: - `date`" >>$ERRLOG
     top -b -n 1 -c | head -30 >>$ERRLOG
     echo "*********************************************************************" >>$ERRLOG

     # Append it to main log
     cat $ERRLOG >>$LOG
     cat $ERRLOG | mail -s "Alert: cpu2 $maxn processes are using high CPU - `date`" $RECIP

fi
}


cpu()
{
CPU_USAGE=$(ps wwaxr -o %cpu |sort -k 1 -r | head -2 | tail -1) 
CPU_USAGE=${CPU_USAGE/\.*} 

if [ $CPU_USAGE -gt $CPU_THRESHOLD ] ; then

   sleep 120
   CPU_LINE=$(ps wwaxr -o %cpu,pid |sort -k 1 -r | head -2 | tail -1) 
   CPU_USAGE=`echo $CPU_LINE | sed 's/\ .*//'` 
   CPU_USAGE=${CPU_USAGE/\.*}
   echo $CPU_USAGE

   if [ $CPU_USAGE -gt $CPU_THRESHOLD ] ; then
     CPU_USER=`echo $CPU_LINE | sed -e 's/.*\ //'`
     echo $CPU_USER 
     echo 'Alert: Process' $CPU_USER 'is using' $CPU_USAGE'% CPU' - `date` > $ERRLOG
     echo "" >> $ERRLOG
     echo "TOP $TOP_X processes by CPU usage" >> $ERRLOG
     echo "----------------------------" >> $ERRLOG
     let "TOP_X += 1"
     ps wwaxr -o pid,stat,%cpu,time,command |sort -k 1 -r | head -$TOP_X >> $ERRLOG

     echo "*********************************************************************" >>$ERRLOG
     echo " Server STATE: - `date`" >>$ERRLOG
     top -b -n 1 -c | head -30 >>$ERRLOG
     echo "*********************************************************************" >>$ERRLOG

     # Append it to main log
     cat $ERRLOG >>$LOG
     cat $ERRLOG | mail -s "Alert: Process $CPU_USER is using $CPU_USAGE %CPU - `date` " $RECIP
  fi
fi
}


disk()
{
df -P | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 " " $6}' | while read output;
do
  used=$(echo $output|awk -F% '{print $1}')
  part=$(echo $output | awk '{ print $3 }' )

  if [ $used -ge $LIMIT ]; then
     echo "Running low on disk space \"$part ($used%)\" on $(hostname). Dated: $(date)" >$ERRLOG

     echo "*********************************************************************" >>$ERRLOG
     echo " Server STATE: - `date`" >>$ERRLOG
     top -b -n 1 -c | head -30 >>$ERRLOG
     echo "*********************************************************************" >>$ERRLOG
     
     # Append it to main log
     cat $ERRLOG >>$LOG
     cat $ERRLOG | mail -s "Alert: Running low on disk space $(hostname) $part" $RECIP
  fi
done
}

cpu_maxtime()
{
  HTTPD_PID=$(cat /var/run/httpd.pid)
  CPU_MAXTIME=$(ps -A -o bsdtime,command,pid|grep -v TIME|sort -bnrk 1|grep httpd|grep -v $HTTPD_PID|head -1)
  MAX_TIME=$(echo $CPU_MAXTIME|awk -F: '{print $1}')
  MAX_TIME_PROCESS=$(echo $CPU_MAXTIME|awk  '{print $3}'|xargs ps -c|grep -v TIME)
  MAX_TIME_PROCESSID=$(echo $CPU_MAXTIME|awk  '{print $3}'|xargs ps -c|grep -v TIME|awk '{print $1}')


if [ $MAX_TIME -gt $MAXCPU_TIME_THRESHOLD ] ; then   

   echo 'Alert: Process' $MAX_TIME_PROCESS 'is using' $MAX_TIME' minutes ' - `date` > $ERRLOG
   echo "*********************************************************************" >>$ERRLOG
   echo " Server STATE: - `date`" >>$ERRLOG
   top -b -n 1 -c | head -30 >>$ERRLOG
   echo "*********************************************************************" >>$ERRLOG

   # Append it to main log
   cat $ERRLOG >>$LOG
   cat $ERRLOG | mail -s "Alert: $(hostname) Process $MAX_TIME_PROCESSID is using $MAX_TIME minutes"  $RECIP

fi

}

if [ $ARG = "CPU" ];then
  #cpu  #too sensitive
  cpu2
fi

if [ $ARG = "MEM" ];then
    mem
fi

if [ $ARG = "DISK" ];then
  disk
fi

if [ $ARG = "MAXTIME" ];then
  cpu_maxtime
fi
