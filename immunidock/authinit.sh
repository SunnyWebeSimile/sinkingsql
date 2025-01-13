cp /docker-entrypoint-initdb.d /
</dev/urandom tr -dc '1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM' | head -c32 > /docker-entrypoint-initdb.d/sqlevalpass;
sed "s/\?sqlevalpass/$(echo ./sqlevalpass)/" < ./config.sql > /docker-entrypoint.initdb.d/newconfig;
mv /docker-entrypoint.initdb.d/newconfig /docker-entrypoint.initdb.d/config.sql;
echo "[client]
password=$(cat /docker-entrypoint.initdb.d/sqlevalpass)
host=localhost
user=evaluator
" > /docker-entrypoint.initdb.d/evaluator-client.cnf;
chmod 400 /docker-entrypoint.initdb.d/evaluator-client.cnf;