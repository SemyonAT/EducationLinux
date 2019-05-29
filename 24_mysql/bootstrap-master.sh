#!/bin/bash

# Variables
DBNAME=sample
DBUSER=root
DBPASSWD=root
DBDIRPATH=/var/lib/mysql_vagrant
DBCONFIG_FILE=/vagrant/config/master/my-master.cnf
MASTER_IP='192.168.100.11'
REPLICA_IP='192.168.100.12'
REPLICA_SSH_USER='vagrant'
REPLICA_SSH_PASS='vagrant'


#echo -e "--- Updating package list and upgrade system... --- "
# Download and Install the Latest Updates for the OS
#sudo apt-get update && sudo apt-get upgrade -y

# Set the Server Timezone to CST
timedatectl set-timezone Europe/Moscow

# Returns true once mysql can connect.
mysql_ready() {
    sudo mysqladmin ping --host=localhost --user=$DBUSER --password=$DBPASSWD > /dev/null 2>&1
}

if [ ! -f /var/log/setup_mysql ]
then

	echo -e "--- Install MySQL ---"
	sudo yum install https://repo.percona.com/yum/percona-release-latest.noarch.rpm+
	sudo yum install http://repo.percona.com/centos/7/RPMS/x86_64/Percona-Server-selinux-56-5.6.42-rel84.2.el7.noarch.rpm
	sudo yum install Percona-Server-server-57

	wget https://www.percona.com/downloads/Percona-Server-5.7/Percona-Server-5.7.10-3/binary/redhat/7/x86_64/Percona-Server-5.7.10-3-r63dafaf-el7-x86_64-bundle.tar
	tar xvf Percona-Server-5.7.10-3-r63dafaf-el7-x86_64-bundle.tar
	sudo rpm -ivh *.rpm
	#rpm -ivh Percona-Server-server-57-5.7.10-3.1.el7.x86_64.rpm Percona-Server-client-57-5.7.10-3.1.el7.x86_64.rpm Percona-Server-shared-57-5.7.10-3.1.el7.x86_64.rpm

	#sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
	#sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"
	#sudo apt-get -y install mysql-server mysql-client 

    # Move initial database file to persistent directory
	echo -e "--- Move initial database file to persistent directory ---"

	sudo service mysql stop

	sudo chown -R mysql:mysql $DBDIRPATH
	sudo rm -rf $DBDIRPATH/*
	sudo cp -r -p /var/lib/mysql/* $DBDIRPATH

	#sudo mv /var/lib/mysql /var/lib/mysql.bak
	#echo "alias /var/lib/mysql/ -> $DBDIRPATH," | sudo tee -a /etc/apparmor.d/tunables/alias
	#sudo /etc/init.d/apparmor reload

    #sudo cp $DBCONFIG_FILE /etc/mysql/conf.d/my_override.cnf
    #sudo service mysql start

    while !(mysql_ready)
    do
       sleep 10s
       echo "---- Waiting for MySQL Connection... Check again after 10 secs..."
    done

	echo -e "--- Setting up MySQL user and db ---"
	sudo mysql -uroot -p$DBPASSWD -e "CREATE DATABASE IF NOT EXISTS $DBNAME" 
	sudo mysql -uroot -p$DBPASSWD -e "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASSWD'"


	# Set up root user's host to be accessible from any remote
	echo -e "--- Set up root user's host to be accessible from any remote ---"
	sudo mysql -uroot -p$DBPASSWD -e 'USE mysql; UPDATE `user` SET `Host`="%" WHERE `User`="root" AND `Host`="localhost"; DELETE FROM `user` WHERE `Host` != "%" AND `User`="root"; FLUSH PRIVILEGES;'

	# Create replication user in master machine
	echo -e "---- Create replication user in master machine"
	mysql -uroot -p$DBPASSWD -e "CREATE USER 'repl'@'%' IDENTIFIED BY 'mysqluser';GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';FLUSH PRIVILEGES;"

    sudo service mysql restart

	touch /var/log/setup_mysql
else
    # If already initialized, then just restart MySQL server
    sudo service mysql start

    while !(mysql_ready)
    do
       sleep 10s
       echo "---- Waiting for MySQL Connection... Check again after 10 secs..."
    done
fi

