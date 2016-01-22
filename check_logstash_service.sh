#!/bin/bash
nomail=0

send_email()
{
#Send mail to list persons in file /var/mail/email_list.txt
elist="/var/mail/email_list.txt"
if [ -e "$elist" ]
        then
                printf "\n Email list file is avaialable \n"
        else
                printf "\n Email list file $elist is not available, please create the file and add Email ID's  \n\n"
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

check_service()
{
 if [ "$1" -ge 1 ]
 then
 printf "\n Process $2 is running \n "
 else 
 printf "\n\n Error:  Process $2 is not running \n"
	if [ "$nomail" == 1 ] 
	 then 
	 	return 
	 else 
	 	send_email "Process $2 is not running"
	fi
 fi 
}

apache_tomcat=`ps ax|grep -v grep|grep -ic '/opt/apache-tomcat-7.0.3'`
check_service "$apache_tomcat" "Apache-Tomcat"

mysql=`ps ax|grep -v grep|grep -ic '/usr/libexec/mysqld'`
check_service "$mysql" "MySQL"

logstash=`ps ax|grep -v grep|grep -ic '/opt/logstash-forwarder/bin/logstash-forwarder'`
check_service "$logstash" "LogStash"
