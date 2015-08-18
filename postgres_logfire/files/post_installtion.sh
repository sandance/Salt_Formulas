#!/bin/bash

lvm_init(){
    pvcreate /dev/sdb1
    vgcreate vglocal01 /dev/sdb1
}

create_partition_ans_fs(){
    while read lvmname volume size
    do
        lvcreate -L $size -n $lvmname $volume
        mkfs -t ext4 /dev/mapper/${volume}-${lvmname}
    done
}

for dir in pgtemp{1,2} cluster{1,2}data1
do
    mkdir -p /var/lib/pgsql/9.3/$dir
done

for dir in wallog{1,2} backup{1,2}
do
    mkdir -p /var/pg_backup/$dir
done

fstab_addition(){
    cat <<EOF

    
EOF
}



