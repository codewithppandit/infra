#!/bin/bash

set -e
set -u

function create_user_and_database() {
    local database=$1
    echo "creating user and db '$database'"
    psql -v ON_ERROR_STOP=1 --username "$MYSQL_USER" <<-EOSQL
      CREATE USER $database;
      CREATE DATABASE $database;
      GRANT ALL PRIVILEGES ON DATABASE $database TO $database;
EOSQL
}

if [ -n "$MYSQL_MULTIPLE_DATABASES" ]; then
  echo "Creating multiple databases:" $MYSQL_MULTIPLE_DATABASES
  for db in $(echo $MYSQL_MULTIPLE_DATABASES | tr ',' ' '); do
    create_user_and_database $db
  done
fi