#! /bin/bash

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [[ $# -ne 5 ]]; then
	echo "Invalid Number of Arguements used"
	exit 1
fi

vmstat_mb=$(vmstat --unit M)
hostname=$(hostname -f)

lscpu_out=$(lscpu)
cpu_number=$(echo "$lscpu_out" | grep "^CPU(s):" | awk '{ print $2 }')
cpu_architecture=$(echo "$lscpu_out"  | egrep "^Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out" | grep "^Model name" | awk '{ $1=$2="";  print }' | sed 's/^[[:space:]]*//')
cpu_mhz=$(echo "$lscpu_out" | grep "^CPU MHz:" | awk '{ print $3 }')
l2_cache=$(echo "$lscpu_out"  | egrep "^L2" | awk '{print $3}' | xargs)
total_mem=$(grep "^MemTotal" /proc/meminfo | awk '{ print $2 }')
timestamp=$(date -u +"%Y-%m-%d %H:%M:%S")

psql -h $psql_host -p $psql_port -U $psql_user -w -d $db_name

insert into host_info (
	hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, total_mem, timestamp
)
values 
(
	'$hostname', $cpu_number, '$cpu_architecture', '$cpu_model', $cpu_mhz, $l2_cache, $total_mem, '$timestamp'
)

exit 0
