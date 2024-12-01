#!/bin/bash

drop_db(){

	./list_db.sh
	read -p "Enter database name: " x

	if [ -d "./databases/$x" ]; then
		read -p "Are you sure you want to drop $x database (Yes/No): " insure

		if [[ $insure == "yes" || $insure == "Yes" || $insure == "YES" ]]; then
			rm -r ./databases/$x
	      		echo "$x database dropped successfully"

	    	elif [[ $insure == "no" || $insure == "No" || $insure == "NO" ]]; then
	      		echo "$x database not dropped"

	    	else
	      		echo "invalid input"
	    	fi

	else
		echo "$x database not found"
	fi

./main.sh

}

drop_db
