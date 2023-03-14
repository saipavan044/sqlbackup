#!/bin/bash

function mysql_backup {
    sudo apt install mysql-server -y
    dbquery=$(mysql -u root -p -e "show databases;")
    l=${#dbquery}
    arr=()
    j=0
    for i in $dbquery
    do
      arr[$j]=$i
      j=$((j+1))
    done
    active_db=""
    whiptail_args=(--title "Select Database" --radiolist "Select Database:" 10 80 "${#arr[@]}")
    i=0
    for db in "${arr[@]}"; 
    do
      whiptail_args+=( "$((++i))" "$db" )
      if [[ $db = "$active_db" ]]; 
      then    
         whiptail_args+=( "on" )
      else
         whiptail_args+=( "off" )
      fi
    done
    echo "${#arr[@]}"
    b=$(whiptail "${whiptail_args[@]}" 3>&1 1>&2 2>&3)
    echo "value of b: " $b
    h=0
    for i in $dbquery
    do
      h=$((h+1))
      if [ $h == $b ]
      then
        DBNAME=$i
      fi
    done
    echo $DBNAME
    DATE=`date +"%Y%m%d"`
    SQLFILE=$DBNAME-${DATE}.sql
    mysqldump --opt --user=root --password $DBNAME > $SQLFILE
    gzip $SQLFILE
}

whiptail --title "Welcome" --msgbox "Sql Backup Database...." --ok-button "Let's Begin" 10 80
mysql_backup
