# PostgreSQL to MySQL replication
Example of the custom replication from PostgreSQL to MySQL using triggers and [MySQL Foreign Data Wrapper for PostgreSQL](https://github.com/EnterpriseDB/mysql_fdw).

## Run
Before the run you have to:
* edit variables used to connect to the databases at the top of the ```run.sh``` and ```configureMySQL.sql``` 
* make sure that MySQL using triggers and [MySQL Foreign Data Wrapper for PostgreSQL](https://github.com/EnterpriseDB/mysql_fdw) is installed correctly.
* the structure in MySQL database would not be duplicated
Then you can execute ```run.sh```:
```
./run.sh
```
If you would like it run it next time you have to clear MySQL database and restore PostgreSQL database. ```clean.sh``` is prepared to restore PostgreSQL database.
