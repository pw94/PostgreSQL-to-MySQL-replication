#!/bin/bash
db="postgres"
username="postgres"
export PGPASSWORD=123 # user password
echo LOG: Dropping schema public in db: ${db}
psql -U ${username} -d ${db} -a -c "DROP SCHEMA public CASCADE;"
echo LOG: Creating new schema public in db: ${db}
psql -U ${username} -d ${db} -a -c "CREATE SCHEMA public;"
psql -U ${username} -d ${db} -a -c "GRANT ALL ON SCHEMA public TO postgres;"
psql -U ${username} -d ${db} -a -c "GRANT ALL ON SCHEMA public TO public;"

