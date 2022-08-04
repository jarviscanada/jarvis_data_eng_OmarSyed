#! /bin/bash

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [[ $# -ne 4 ]]; then
	echo "Invalid Arguments"
	exit 1
fi

memory_free=$(echo "$vmstat_mb" | awk '{print $4}'| tail -n1 | xargs)
cpu_idle=$(vmstat -SM | tail -1 | awk '{ print $15 }')
cpu_kernel=$(vmstat | egrep "1" | awk '{print $14}' | xargs)
disk_io=$(vmstat -d | awk '{print $10}' | xargs)
disk_available=$(df -BM / | egrep "/dev/sda2" | awk '{print $4}' | xargs)

timestamp=$(date -u +"%Y-%m-%d %H:%M:%S")

host_id="(SELECT id FROM host_info WHERE hostname='$hostname')";

insert_stmt="INSERT INTO host_usage(timestamp, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available)
VALUES('$timestamp', $cpu_idle, $cpu_kernel, $disk_io, $disk_available);"

export PGPASSWORD=$psql_password

psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?

