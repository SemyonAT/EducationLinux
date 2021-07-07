 SELECT * FROM runtime_mysql_servers;
 SELECT * FROM mysql_servers;

mysql -h 127.0.0.1 -P6032 -uadmin -p'admin'

mysql -h 127.0.0.1 -P6033 -uwebuser -p'YjdstRhjrjpz,hs2881'

tcpdump -i eth1 -s0 -vv net 224.0.0.0/4

proxy:6033


mysql_webuser:          'webuser'
mysql_password_webuser: 'YjdstRhjrjpz,hs2881'
mysql_db_name:          'wordppress'
proxysql_host:          'proxy:6033'
site_user: wordpress

site: projekt