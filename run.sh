#!/bin/bash
db="postgres"
username="postgres"
export PGPASSWORD=123 # user password

echo LOG: Creating tables in db: ${db}
psql -U ${username} -d ${db} -a -f create_tables.sql

echo LOG: Inserting data
psql -U ${username} -d ${db} -a -f insert_COMPANY_MEMEBERS1.sql
psql -U ${username} -d ${db} -a -f insert_DEPARTMENT1.sql

echo LOG: Preparing replication mechanism

echo LOG: Dumping ${db} data and schema
pg_dump -U ${username} --no-owner --schema-only -f dump_schema.sql
pg_dump -U ${username} --no-owner --data-only -f dump_data.sql

echo LOG: Modifing database schema to recreate it on MySQL database
sed -i '/^--/d' dump_schema.sql
sed -i '/^COMMENT/d' dump_schema.sql
sed -i '/^SET/d' dump_schema.sql
sed -i '/^GRANT/d' dump_schema.sql
sed -i '/^CREATE EXTENSION/d' dump_schema.sql
sed -i 's/^ALTER TABLE ONLY/ALTER TABLE/' dump_schema.sql
sed -i '/^$/N;/^\n$/D' dump_schema.sql

echo LOG: Configuring connection to MySQL
psql -U ${username} -d ${db} -a -f configureMySQL.sql

echo LOG: Creating schema in MySQL database
mysql --host=`grep mysqlhost configureMySQL.sql | awk 'NR==1{print $3}' | tr -d \'` --user=`grep mysqlusername configureMySQL.sql | awk 'NR==1{print $3}' | tr -d \'` `grep mysqldb configureMySQL.sql | awk 'NR==1{print $3}' | tr -d \'` --password=`grep mysqlpassword configureMySQL.sql | awk 'NR==1{print $3}' | tr -d \'` < dump_schema.sql

echo LOG: Creating foreign tables
awk '{if (/[^;]$/) printf "%s", $0; else print $0}' < dump_schema.sql | awk '/^CREATE TABLE/' | sed 's/^CREATE TABLE/CREATE FOREIGN TABLE/' | awk -v dbname=`grep mysqldb configureMySQL.sql | awk 'NR==1{print $3}' | tr -d \'` '{$4=$4"_ft"; sub(/;$/," SERVER mysql_server OPTIONS (dbname \x27"dbname"\x27, table_name \x27"$4"\x27);"); print}' > dump_schema_ft.sql
# execute dump_schema_ft.sql on postgres


sed -i '/^--/d' dump_data.sql
sed -i '/^SET/d' dump_data.sql
# append something to the name of the table -> _FT
# applied dumped data via foreign tables

# set up triggers

# maybe move the rest to test script?
echo LOG: Inserting new data into db: ${db}
psql -U ${username} -d ${db} -a -f insert_COMPANY_MEMEBERS2.sql
psql -U ${username} -d ${db} -a -f insert_DEPARTMENT2.sql

# maybe check if data was transfer on foreign server?

echo LOG: Updating data in db: ${db}
psql -U ${username} -d ${db} -a -f update_COMPANY_MEMBERS.sql

echo LOG: Deleting some data in db: ${db}
psql -U ${username} -d ${db} -a -f delete_DEPARTMENT.sql
