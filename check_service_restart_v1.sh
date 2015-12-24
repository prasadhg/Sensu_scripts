#!/bin/sh

restart_service()
{
#Restart service if not running
        service "$1" restart &> /dev/null
        if [ $? -eq 0 ]
        then
                echo "Successfully restarted the service"
        else
                echo "Could not start the service" >&2
        fi
        sleep 3
        check_service $1
}

check_service()
{
#check if service running or not
        if service "$1" status |  egrep -i "(not|error|stopped)" > /dev/null
        then
                echo "ERROR!    Service is not running  \n "
                echo "Restarting the service $1 \n"
                sleep 1
                restart_service $1
        else
                echo "OK  Service $1 is running \n "
        fi
}

verify_service()
{
#check if service exists
 service=$1
 file="/etc/init.d/$service"
 if [ -e "$file" ]
        then
                echo "Service name: $1"
                #check_service $1
                check_service "$service"
        else
                echo "$1!:  No such service \n"
                return
        fi
}
echo "\n ### Script to check Sensu related services running or not! ### \n "
verify_service rabbitmq-server
verify_service redis-server
verify_service sensu-server
verify_service sensu-api
#verify_service uchiwa
verify_service sensu-client
verify_service sensu-dashboard
