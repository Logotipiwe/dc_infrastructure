cont="ms"
dump_dir="/home/dumps"

#cont="sql"
#dump_dir=""
mkdir -p $dump_dir
dbs_args=$(docker exec $cont mysql -uroot -p${PASS} -N -e 'show databases' |
grep -wv 'mysql\|performance_schema\|sys\|information_schema' |
xargs -d'\n')

docker exec $cont mysqldump -u root -p${PASS} --databases $dbs_args > $dump_dir/dump-$(date +"%Y.%m.%d_%I%p").sql