source .env
export PGPASSWORD=$DB_PASSWORD
psql --host $DB_HOST -U $DB_USERNAME -p $DB_PORT -d $DB_NAME -f insert_categories.sql