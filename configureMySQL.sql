\set mysqlhost 'sql11.freemysqlhosting.net'
\set mysqlport '3306'
\set mysqldb 'sql11178311'
\set mysqlusername 'sql11178311'
\set mysqlpassword 'PECxHPkfsv'

CREATE EXTENSION mysql_fdw;

CREATE SERVER mysql_server
     FOREIGN DATA WRAPPER mysql_fdw
     OPTIONS (host :'mysqlhost', port :'mysqlport');

CREATE USER MAPPING FOR :USER
SERVER mysql_server
OPTIONS (username :'mysqlusername', password :'mysqlpassword');

---test
CREATE FOREIGN TABLE warehouse(
     warehouse_id int,
     warehouse_name text)
SERVER mysql_server
     OPTIONS (dbname :'mysqldb', table_name 'warehouse');
--you have to create the same table on mysql_server with primary key!
