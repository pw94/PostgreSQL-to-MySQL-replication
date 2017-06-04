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
# modify dump to apply on foreign server

echo LOG: Configuring connection to MySQL
psql -U ${username} -d ${db} -a -f configureMySQL.sql

# apply it

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
