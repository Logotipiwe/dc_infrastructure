cont="ms"
p="U4j54ywe8y53w4y93JFIE9i4"
dump_dir="/kuber/infra/dumps"

#cont="sql"
#p="CosmOs888lOgiS999_12_99"
#dump_dir=""

dbs_args=$(docker exec $cont mysql -uroot -p$p -N -e 'show databases' |
grep -wv 'mysql\|performance_schema\|sys\|information_schema' |
xargs -d'\n')

docker exec $cont mysqldump -u root -p$p --databases $dbs_args > $dump_dir/dump-$(date +"%Y.%m.%d_%I%p").sql