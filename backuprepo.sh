#!/bin/bash
red="\033[1;31m"
reset="\033[m"
function mysql_backup {
         dbquery=$(mysql -u root -p -e "show databases;")
         echo $dbquery
         a=0
         for i in $dbquery
         do
           a=$((a+1))
           echo $a. $i
         done
         read -p "Your Choice" b
         h=0
         for i in $dbquery
         do
           h=$((h+1))
           if [ $h -eq $b ]
           then
             DBNAME=$i
           fi
         done
         DATE=`date +"%Y%m%d"`
         SQLFILE=$DBNAME-${DATE}.sql
         mysqldump --opt --user=root --password $DBNAME > $SQLFILE
         gzip $SQLFILE
}

function source_backup {
        read -p "Enter a directory name: " direc
        sudo mkdir $direc
        read -p "Enter github project url: " url
        wget "$url.git"
        ts=$(date +%F)
        read -p "Enter repo name of your project: " name
        tar -cf ${ts}.tar  "$name.git"
	echo "pwd"
        sudo mv *.tar var/www/task/$direc
        sudo apt-get install git
        read -p "Enter your github username: " user
        read -p "Enter your repo name to store the backup file: " repo
        git init
        git remote add origin "https://github.com/$user/$repo.git"
        git add -A
        git commit -m "added backup of $repo"
        echo -e $red Generate a personal access token in your github account and pass that token when password is asked in next step. $reset
        git push -u origin master
}
function add_to_cron {
       crontab -l > mycron
       read -p "Enter time for script execution in following format - minute hour day month day_of_week: " execute_time
       echo "$execute_time /home/ubuntu/test.sh" >> mycron
       crontab mycron
       rm mycron
}

#mysql_backup
source_backup
#add_to_cron
