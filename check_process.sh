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

sensu_server=`ps ax | grep -v grep | grep -ic sensu-server`
check_service "$sensu_server"  "Sensu Server"

chef_bookshelf=`ps ax|grep -v grep|grep -ic '/opt/chef-server/embedded/service/bookshelf/erts-5.9.2/bin/epmd -daemon'`
check_service "$chef_bookshelf"  "Chef BookShelf"

chef_solr=`ps ax|grep -v grep|grep -ic '/opt/chef-server/chef-solr'`
check_service "$chef_solr" "Chef Solr"

chef_erchef=`ps ax|grep -v grep|grep -ic '/opt/chef-server/erchef'`
check_service "$chef_erchef" "Chef-Erchef"

chef_rabbitmq=`ps ax|grep -v grep|grep -ic '/opt/chef-server/rabbitmq'`
check_service "$chef_rabbitmq" "Chef Rabbitmq"

chef_webui=`ps ax|grep -v grep|grep -ic 'unicorn master'`
check_service "$chef_webui" "Chef-WEBGUI"

carbon_cache=`ps ax|grep -v grep|grep -ic '/usr/bin/python ./carbon-cache.py start'`
check_service "$carbon_cache" "Python-Carbon-cache"

django_admin=`ps ax|grep -v grep|grep -ic 'django-admin'`
check_service "$django_admin"  "Graphite/django_admin"

apache_tomcat=`ps ax|grep -v grep|grep -ic '/opt/apache-tomcat-7.0.3'`
check_service "$apache_tomcat" "Apache-Tomcat"

mysql=`ps ax|grep -v grep|grep -ic '/usr/libexec/mysqld'`
check_service "$mysql" "MySQL"

logstash=`ps ax|grep -v grep|grep -ic '/opt/logstash-forwarder/bin/logstash-forwarder'`
check_service "$logstash" "LogStash"
