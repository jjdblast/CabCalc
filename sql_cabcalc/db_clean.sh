#!/bin/bash 

#Load the basic setup
source db_setup.sh

echo "Deleting superfluous columns"
SQL_CMD="ALTER TABLE "$FINAL_TABLE_NAME" DROP COLUMN pick_lat, DROP COLUMN pick_lon, DROP COLUMN drop_lat, DROP COLUMN drop_lon"
mysql -e "$SQL_CMD" -u root  $DB_NAME

echo "Reclaim free space"
SQL_CMD="OPTIMIZE TABLE "$FINAL_TABLE_NAME
mysql -e "$SQL_CMD" -u root  $DB_NAME

echo "Curr size:"
mysql -e "$DB_SZ_COMMAND" -u root $DB_NAME