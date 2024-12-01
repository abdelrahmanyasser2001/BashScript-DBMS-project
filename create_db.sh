#!/bin/bash

create_db(){

	read -p "Enter new database name: " db_name

	if [ -d "./databases/$db_name" ]; then
		echo "Database already exists"
	else
		if [[ $db_name =~ ^[a-zA-Z] ]] && [[ $db_name = +([a-zA-Z0-9_]) ]]; then
			mkdir ./databases/$db_name
			echo "Database created successfully!"
		else
    			echo "Database name $db_name contain invalid characters"
  		fi
	fi

./main.sh

}

create_db
