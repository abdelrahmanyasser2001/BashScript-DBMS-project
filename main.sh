#!/bin/bash

main_menu(){

echo "---------------------------------------------------"
echo "---------------welcome to main menu----------------"
echo "---------------------------------------------------"

PS3="-----Main menu----- Please select an option: "

select option in "Create Database" "List Database" "Connect Database" "Drop Database" "Exit"
	do
	case $option in

		"Create Database") ./create_db.sh;;
		"List Database") ./list_db.sh;;
		"Connect Database") ./connect_db.sh;;
		"Drop Database") ./drop_db.sh;;
 		"Exit") exit;;
		*) echo invalid option

	esac
	done
}

main_menu
