#!/bin/bash

lvm_init(){
    pvcreate /dev/sdb1
    vgcreate vglocal01 /dev/sdb1
}

create_partition_ans_fs(){
    filename=$1
    while read lvmname volume size
    do
        lvcreate -L $size -n $lvmname $volume
        mkfs -t ext4 /dev/mapper/${volume}-${lvmname}
    done < $filename
}

post_partition() {
for dir in pgtemp{1,2} cluster{1,2}data1
do
    mkdir -p /var/lib/pgsql/9.3/$dir
done

for dir in wallog{1,2} backup{1,2}
do
    mkdir -p /var/pg_backup/$dir
done

}

fstab_addition(){
    cat >> fstab_location  <<EOF 
    /dev/mapper/vglocal01-c1data1        /var/lib/pgsql/9.3/cluster1data1   ext4  defaults     0 1
    /dev/mapper/vglocal00-wallog1        /var/pg_backup/wallog1             ext4  defaults     0 1
    /dev/mapper/vglocal00-backup1        /var/pg_backup/backup1             ext4  defaults     0 1
    /dev/mapper/vglocal00-pgtemp1        /var/lib/pgsql/9.3/pgtemp1         ext4  defaults     0 1
     
    /dev/mapper/vglocal01-c2data1        /var/lib/pgsql/9.3/cluster2data1   ext4  defaults     0 1
    /dev/mapper/vglocal00-wallog2        /var/pg_backup/wallog2             ext4  defaults     0 1
    /dev/mapper/vglocal00-backup2        /var/pg_backup/backup2             ext4  defaults     0 1
    /dev/mapper/vglocal00-pgtemp2        /var/lib/pgsql/9.3/pgtemp2         ext4  defaults     0 1
EOF
}




#### main ####


lvm_init

create_partition_ans_fs volume.info

# error checking and call post_partition

post_partition && fstab_addition


