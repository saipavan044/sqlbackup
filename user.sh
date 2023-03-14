#!/bin/bash

create_user()
{
	while :
	do
		user=$(whiptail --inputbox "Please enter User Name:" 10 100 3>&1 1>&2 2>&3)
		if id $user &> /etc/null 
		then
			whiptail --msgbox "User already exist...(try again with another name)" --title "Create new user" 10 100		
		else
			useradd $user
			if [ $? -eq 0 ];
				then
				whiptail --msgbox "User Created Successfully" --title "Create new user" 10 100 
			else
				whiptail --msgbox "Failed To Add User" --title "Create new user" 10 100
			fi
		return 0
		fi
	done
}

set_pass()
{
        user=$(whiptail --inputbox "Please enter User Name:" 10 100 3>&1 1>&2 2>&3)
	password=$(whiptail --inputbox "Please enter Password:" 10 100 3>&1 1>&2 2>&3)	
        whiptail --msgbox $password | passwd --stdin $user  --title "Set Password" 10 100
}


view()
{
	users=$(awk -F: '$7=="/bin/bash" { print $1}' /etc/passwd)
	for user in $users
	do
		whiptail --msgbox "User: $user , $(id $user | cut -d " " -f 1)" --title "View Users" 10 100
	done
}

lock()
{
	while :
	do
		user=$(whiptail --inputbox "Enter your user_name to lock password:" 10 100 3>&1 1>&2 2>&3)
		if [ -z $user ]
		then
			whiptail --msgbox "Username can't be empty, please enter user_name..." --title "Lock User" 10 100
			return 0
		else
			if id $user &> /etc/null
			then
				passwd -l $user
				whiptail --msgbox "successfully done...." --title "Lock User" 10 100
				return 0
			else
				whiptail --msgbox "provide valid user_name, user $user does not exist" --title "Lock User" 10 100
			fi
		fi
	done
}

backup()
{
	user=$(whiptail --inputbox "Enter your user_named:" 10 100 3>&1 1>&2 2>&3)
	whiptail --textbox back.txt --title "Back Up" 10 100 
	homedir=$(grep ${user}: /etc/passwd | cut -d ":" -f 6)
	ts=$(date +%F)
	tar -cf ${user}-${ts}.tar $homedir
	return 0
}
function menu(){
while :; do
choice=$(whiptail --menu "Choose an option:" 18 100 10 \
  "1" "Create new user " \
  "2" "Set password" \
  "3" "Lock Password " \
  "4" "Create user backup" \
  "5" "View user-id" \
  "6" "Exit" 3>&1 1>&2 2>&3)

case $choice in 
 1)   create_user ;;
 2)   set_pass echo "Password successfully updated....." ;;
 3)   lock ;;
 4)   backup ;; 
 5)   view ;;
 6)   whiptail --msgbox "ThankYou, have a nice day...." 10 100
	return ;;
 *)   whiptail --msgbox "No option was chosen (user hit Cancel)" 10 100 
	return ;;
esac
done
}
menu
