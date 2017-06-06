\set mysqlhost '127.0.0.1'
\set mysqlport '3306'
\set mysqldb 'mydb'
\set mysqlusername 'root'
\set mysqlpassword '123456'

CREATE EXTENSION mysql_fdw;

CREATE SERVER mysql_server
     FOREIGN DATA WRAPPER mysql_fdw
     OPTIONS (host :'mysqlhost', port :'mysqlport');

CREATE USER MAPPING FOR :USER
SERVER mysql_server
OPTIONS (username :'mysqlusername', password :'mysqlpassword');

