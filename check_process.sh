#!/bin/bash

check_service()
{
 if [ "$1" -ge 1 ]
 then
 printf "\n Process $2 is running \n "
 else 
 printf "\n Process $2 is not running \n"
 fi 

}

sensu_server=`ps ax | grep -v grep | grep -ic sensu-server`
printf " \n Service status count is $sensu_server "
check_service "$sensu_server"  "Sensu Server"

chef_bookshelf=`ps ax|grep -v grep|grep -ic '/opt/chef-server/embedded/service/bookshelf/erts-5.9.2/bin/epmd -daemon'`
check_service "$chef_bookshelf"  "Chef BookShelf"

chef_solr=`ps ax|grep -v grep|grep -ic '/opt/chef-server/chef-solr'`
check_service "chef_solr" "Chef Solr"
