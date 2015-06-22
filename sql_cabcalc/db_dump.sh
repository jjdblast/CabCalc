#!/bin/bash

#Dump/Load taxi database into/from local text file - backup purpose

#Load the basic setup
source db_setup.sh

if [ $1 = "store" ];
then 
	echo "Storing the database into txt files"
	#csv files located in /usr/local/mysql/data/taxi

	for i in {1..12}
	do
		echo "Dumping month $i" 
		TABLE_NAME=$TABLE_PREFIX$i
		SQL_CMD="SELECT * INTO OUTFILE '"$TABLE_NAME"_dump.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n' FROM $TABLE_NAME"
		mysql -e "$SQL_CMD" -u root  $DB_NAME

	done
	
elif [ $1 = "load" ];
then
	echo "    Loading the database from txt files in $DB_DUMP_FOLDER"

mysql> show columns from trip_10;

	for i in {1..12}
	do
		TABLE_NAME=$TABLE_PREFIX$i
		SQL_CMD="CREATE TABLE IF NOT EXISTS $TABLE_NAME (pick_date DATETIME, trip_time_in_secs SMALLINT, trip_distance FLOAT, pick_x FLOAT, pick_y FLOAT, drop_x FLOAT, drop_y FLOAT, err_flag TINYINT(1), total_wo_tip FLOAT, pick_lon DOUBLE, pick_lat DOUBLE, drop_lon DOUBLE, drop_lat DOUBLE, ord_no INT, precip_f FLOAT, precip_b TINYINT(1), manhattan TINYINT(1))"
		mysql -e "$SQL_CMD" -u root  $DB_NAME

		SQL_CMD="LOAD DATA LOCAL INFILE '"$DB_DUMP_FOLDER"/$TABLE_NAME_dump.csv' IGNORE INTO TABLE $TABLE_NAME FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' (pick_date, trip_distance, pick_x, pick_y, drop_x, drop_y, err_flag, total_wo_tip)"
		mysql -e "$SQL_CMD" -u root  $DB_NAME
	done
else
	echo "    Unrecognized option"
fi




