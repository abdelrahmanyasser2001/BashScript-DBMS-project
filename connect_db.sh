#!/bin/bash

connect_db(){

	./list_db.sh
	read -p "Enter database name: " database_n
	if [ -z $database_n ]; then
		echo "database name can't be empty!"
		exit

	else
		if [ -e  "./databases/$database_n" ]; then
			./table_list.sh $database_n

		else
	  		echo "database $database_n not found"
	  		echo "do you want to create new database: Yes No "
	  		read answer
			if [[ $answer == "yes" || $answer == "Yes" || $answer == "YES" ]]; then
				./create_db.sh

			elif [[ $answer == "no" || $answer == "No" || $answer == "NO" ]]; then
				exit

			else
				echo "invalid answer"
				exit
			fi
		fi
	fi

}

connect_db

