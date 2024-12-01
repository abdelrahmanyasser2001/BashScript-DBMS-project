#!/bin/bash

databasename=$1


table_list(){

	echo "---------------------------------------------------"
	echo "---------------welcome to table menu---------------"
	echo "---------------------------------------------------"


	PS3="-----Table menu----- Please select an option: "
	select op in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "Exit"
		do
    		case $op in

 			"Create Table") create_table;;
      			"List Tables") list_table;;
      			"Drop Table") drop_table;;
      			"Insert into Table") insert_into_table;;
      			"Select From Table") select_from_table;;
      			"Delete From Table") delete_from_table;;
      			"Update Table") update_table;;
		      	"Exit") exit;;
      			*) echo invalid option
    		esac
  		done
}


create_table(){

	database_name=$databasename
	read -p "Enter table name: " tb_name
	if [ -e "./databases/$database_name/$tb_name" ]; then
  	echo "table $tb_name already exists"
	else
  		if [[ $tb_name =~ ^[a-zA-Z] ]] && [[ $tb_name = +([a-zA-Z0-9_]) ]]; then
    		touch ./databases/$databasename/$tb_name
    		echo "table $tb_name created successfully!"
    		cd ./databases/$databasename

  		else
    		echo "table name $tb_name contain invalid characters"
    		exit

  		fi
	fi

	read -p "Enter number of fields: " no_of_fields
	if [[ "$no_of_fields" =~ ^[0-9]+$ ]] && [[ "$no_of_fields" -ne 0 ]]; then

  		condition="True"
  		i=1
  		while [ $i -le $no_of_fields ]; do
    		echo "enter the name of the field"
    		echo "field name can only consists of alphanumeric characters and underscores"
    		read field_name

    		if [[ "$field_name" =~ ^[A-Za-z0-9_]+$ ]]; then
      		echo -n "$field_name" >> $tb_name

    		else
      		echo "invalid field name"
      		rm $tb_name
      		exit
    		fi


    		echo "selct data type :"

    		echo "1) integer"
    		echo "2) varchar"
    		echo "3) boolen"

    		read field_ty
    		case $field_ty in
      			1) echo -n "(int)" >> $tb_name | break;;
      			2) echo -n "(varchar)" >> $tb_name;;
      			3) echo -n "(boolen)" >> $tb_name;;
      			*) echo invalid option
			   rm $table_name
        	  	   exit;;
    		esac


    		while [ $condition == "True" ]; do
      			echo "table must contain a primary key"
      			read -p "Do you want to set this field as PK (Yes/No)" pk
      			if [[ $pk == "yes" || $pk == "Yes" || $pk == "YES" ]]; then
        			echo -n "(pk)" >> $tb_name
				condition="False"
      			else
			break
      			fi
    		done
    		echo -n "|" >> $tb_name
    		i=$((i + 1))
  		done
	else
  		echo "invalid input"
  		rm $tb_name
  		exit
	fi

cd ../..


table_list
}




list_table(){

	database_name=$databasename
	echo "The current tables are: "
	ls ./databases/$database_name

}



drop_table(){

	list_table
	database_name=$databasename
	read -p "Enter table name: " t_name

	if [ -e "./databases/$database_name/$t_name" ]; then
  		read -p "Are you sure you want to drop $t_name table (Yes/No):  " insure
  		if [[ $insure == "yes" || $insure == "Yes" || $insure == "YES" ]]; then
    			rm -r ./databases/$database_name/$t_name
    			echo "$t_name table dropped successfully"

		elif [[ $insure == "no" || $insure == "No" || $insure == "NO" ]]; then
    			echo "$t_name table not dropped"

  		else
    			echo "invalid input"
  		fi

	else
  		echo "table $t_name doesn't exsist"
		read -p "Do you want to create table (Yes/No): " yn

		if [[ $yn == "yes" || $yn == "Yes" || $yn == "YES" ]]; then
			create_table

		elif [[ $yn == "no" || $yn == "No" || $yn == "NO" ]]; then
			exit

		else
			echo "invalid input"

		fi
	fi


table_list
}



insert_into_table(){

	list_table
	database_name=$databasename
	read -p "Enter table name you want to insert into: " table
	if [ -e "./databases/$database_name/$table" ]; then
		echo "insert"
		cd ./databases/$database_name
		sentence=$(head -n 1 $table)
		IFS='|' read -a words <<< "$sentence"
		echo "" >> $table
		for word in "${words[@]}"; do
	  		if [[ "$word" =~ "(pk)" ]]; then
	     			if [[ "$word" =~ "(int)" ]]; then
					echo "$word"
					read -p "Enter Int value: " value
					if [[ "$value" =~ ^[0-9]+$ ]] && [[ -n "$value" ]]; then
		  				echo -n "$value|" >> $table

					else
		  			echo "value must be int "
					fi

	     			elif [[ "$word" =~ "(varchar)" ]]; then
					echo "$word"
					read -p "Enter Varchar value: " value 2>> /dev/null
					if [ -n $value ]; then
		  				echo -n "$value|" >> $table

					else
		  				echo "value must be str"
					fi

				elif [[ "$word" =~ "(boolen)" ]]; then
					echo "$word"
					read -p "Enter True or False: " value
					if [[ $value == "true" || $value == "True" || $value == "TRUE" ]]; then
		  				echo -n "$value|" >> $table

					elif [[ $value == "false" || $value == "False" || $value == "FALSE" ]]; then
		  				echo -n "$value|" >> $table

					else
					   	echo "invalid input"
		   				exit
					fi
	     			fi

			else
	     		if [[ "$word" =~ "(int)" ]]; then
	       			echo "$word"
	       			read -p "Enter Int Value: " value
	       			if [[ "$value" =~ ^[0-9]+$ ]]; then
			 		echo -n "$value|" >> $table

	       			elif [[ -z "$value" ]]; then
			 		echo -n "null|" >> $table

	       			else
			 		echo "invalid input"
					 exit
		       		fi

		     	elif [[ "$word" =~ "(varchar)" ]]; then
	       			echo "$word"
	       			read -p "Enter Varchar value: " value

	       			if [[ -n "$value" ]]; then
			 		echo -n "$value|" >> $table

	       			elif [[ -z "$value" ]]; then
			 		echo -n "null|" >> $table

		       		else
		 			echo "invalid input"
			 		exit
		       		fi

		     	elif [[ "$word" =~ "(boolen)" ]]; then
	       			echo "$word"
	       			read -p "Enter True or False: " value

		   		if [[ $value == "true" || $value == "True" || $value == "TRUE" ]]; then
			 		echo -n "$value|" >> $table

		       		elif [[ $value == "false" || $value == "False" || $value == "FALSE" ]]; then
			 		echo -n "$value|" >> $table

		       		elif [[-z $value ]]; then
			 		echo -n "null|" >> $table

	       			else
			  		echo "invalid input"
			  		exit
		       		fi
		     	fi
		fi
		done

	else
		echo "Table $table doesn't exsist"
		read -p "Do you want to create table (Yes/No): " yn

		if [[ $yn == "yes" || $yn == "Yes" || $yn == "YES" ]]; then
			create_table

		elif [[ $yn == "no" || $yn == "No" || $yn == "NO" ]]; then
			exit

		else
			echo "invalid input"

		fi

	fi

cd ../..

}




select_from_table(){

	list_table
	database_name=$databasename
	cd ./databases/$database_name
	read -p "Enter table name to select data from: " table
	if [[ -f $table ]];then
  		head -n 1 $table
	  	read -p "Would you like to print all records (Yes/No): " response
  		if [[ $response == "yes" || $response == "Yes" || $response == "YES" ]]; then
    			read -p "would you like to print specific field (Yes/No): " answer
    			if [[ $answer == "yes" || $answer == "Yes" || $answer == "YES" ]]; then
			      	read -p "Enter field number: " field_no
      				awk $'{print $0}' $table | cut -f$field_no -d"|"

    			elif [[ $answer == "no" || $answer == "No" || $answer == "NO" ]]; then
      				column $table -t -s '|'

    			else
      			exit
    			fi

  		elif [[ $response == "no" || $response == "No" || $response == "NO" ]]; then
    			read -p "Enter the value you want to search for: " value 2>> /dev/null
    			awk -v pat=$value '$0~pat{print $0}' $table | column -t -s '|'

  		else
    		exit

		fi

	else
  		echo "table $table doesn't exsist"
		read -p "Do you want to create table (Yes/No): " yn

		if [[ $yn == "yes" || $yn == "Yes" || $yn == "YES" ]]; then
			create_table

		elif [[ $yn == "no" || $yn == "No" || $yn == "NO" ]]; then
			exit

		else
			echo "invalid input"

		fi
	fi

cd ../..

}



update_table(){

	list_table
	database_name=$databasename
	cd ./databases/$database_name
	read -p "Enter table name you want to update: " table

	if [ -f $table ]; then
  		head -n 1 $table
  		read -p "Enter field number: " field_number
  		read -p "Enter value: " value
  		awk ' BEGIN { count=0 ; FS="|" } $($field_number) ~ /'$value'/ { count++ } ' $table

 		if [[ $count == 0 ]]; then
    			echo "no values found"

  		else
   			NR=$(awk 'BEGIN { FS="|" } { if ($'$field_number' == "'$value'" ) print NR }' $table)
   			old_value=$(awk 'BEGIN { FS="|" } { if (NR == "'$NR'") { for (i = 1; i <= NF; i++) { if (i == '$field_number') print $i }}}' $table)
   			read -p "Enter New value: " new_value
   			sed -i ''$NR's/'$old_value'/'$new_value'/g' $table
   			echo "value updated succesfully"

   		fi
	else
  		echo "table $table doesn't exsist"
		read -p "Do you want to create table (Yes/No): " yn

		if [[ $yn == "yes" || $yn == "Yes" || $yn == "YES" ]]; then
			create_table

		elif [[ $yn == "no" || $yn == "No" || $yn == "NO" ]]; then
			exit

		else
			echo "invalid input"

		fi

	fi

cd ../..

}



delete_from_table(){

	list_table
	database_name=$databasename
	cd ./databases/$database_name
	read -p "Enter table name to delete data: " table

	if [ -f $table ]; then
  		head -n 1 $table
  		read -p "Enter field number: " field_number
  		read -p "Enter value: " value
  		awk ' BEGIN { count=0 ; FS="|" } $($field_number) ~ /'$value'/ { count++ } ' $table

  		if [[ $count == 0 ]]; then
    			echo "no values found"

  		else
   			NR=$(awk 'BEGIN { FS="|" } { if ($'$field_number' == "'$value'" ) print NR }' $table)
   			sed -i  ''$NR'g' $table
   			echo "records deleted succesfully"
  		fi

	else
 		echo "table $table doesn't exsist"
		read -p "Do you want to create table (Yes/No): " yn

		if [[ $yn == "yes" || $yn == "Yes" || $yn == "YES" ]]; then
			create_table

		elif [[ $yn == "no" || $yn == "No" || $yn == "NO" ]]; then
			exit

		else
			echo "invalid input"

		fi
	fi

cd ../..

}




table_list

