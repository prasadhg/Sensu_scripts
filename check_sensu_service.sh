#!/bin/bash
nomail=0

send_email()
{
#Send mail to list persons in file /var/mail/email_list.txt
elist="/var/mail/email_list.txt"
if [ -e "$elist" ]
        then
                printf "\n Email list file avaialable \n"
        else
                printf "\n Email list file $elist is not available, please create the file and add Email ID's  \n"
		nomail=1
                return
        fi

while IFS="," read -ra  line
do
 for (( i=0; i<${#line[@]}; ++i )); do
  if [[ "${line[$i]}" == *"@aricent.com" ]]
  then
        printf  " Mail sent to ${line[$i]} saying $1 \n"
        #mail -s "random msg !" -t "$line" < /dev/null 2> /dev/null
  else
        printf  " ${line[$i]} is not an valid mail ID, Please enter valid mail ID in file /var/mail/email_list.txt \n"
  fi
 done
done < "/var/mail/email_list.txt"

}

restart_service()
{
#Restart service if not running
        service "$1" restart &> /dev/null
        if [ $? -eq 0 ]
        then
                printf " Successfully restarted the service \n"
		send_email "Successfully restarted the service $1 "
		return
        else
                printf "\n !!!Could not start the service!!! \n" >&2
		send_email "Failed to restart the service $1 "
		return
        fi
        sleep 3
        check_service $1
}

check_service()
{
#check if service running or not
        if service "$1" status |  egrep -i "(not|error|stopped|nodedown)" > /dev/null
        then
                printf "\n ERROR!    Service is not running  \n "
			if [ "$nomail" == 1 ] 
	 		then 
	 			return
			else 
			send_email "Error! service is not running"
			fi
                printf "\n Restarting the service $1 \n"
                sleep 1
                restart_service $1
        else
                printf "\n OK  Service $1 is running  \n "
        fi
}

verify_service()
{
#check if service exists
 service=$1
 file="/etc/init.d/$service"
 if [ -e "$file" ]
        then
                printf "\n Service name: $1 "
                #check_service $1
                check_service "$service"
        else
                printf "\n ERROR!!   $service:  No such service  \n"
		send_email "Service $service is not installed"
                return
        fi
}
printf  "\n ### Script to check Sensu related services running or not! ###  \n "
verify_service rabbitmq-server
verify_service redis-server
verify_service sensu-server
verify_service sensu-api
verify_service sensu-client
verify_service sensu-dashboard
verify_service elasticsearch
verify_service apache2
