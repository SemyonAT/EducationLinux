!/bin/bash

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

# Set the Server Timezone to CST
timedatectl set-timezone Europe/Moscow

# Returns true once mysql can connect.
mysql_ready() {
    sudo mysqladmin ping --host=localhost --user=$DBUSER --password=$DBPASSWD > /dev/null 2>&1
}

sudo yum install -y epel-release
sudo yum install -y htop

if [ ! -f /var/log/setup_mysql ]
then

	echo -e "--- Install MySQL ---"
	sudo yum install -y https://repo.percona.com/yum/percona-release-latest.noarch.rpm
	sudo yum install -y http://repo.percona.com/centos/7/RPMS/x86_64/Percona-Server-selinux-56-5.6.42-rel84.2.el7.noarch.rpm
	sudo yum install -y Percona-Server-server-57
	sudo yum install -y wget

	#jemalloc
	sudo wget https://www.percona.com/downloads/Percona-Server-5.7/Percona-Server-5.7.10-3/binary/redhat/7/x86_64/Percona-Server-5.7.10-3-r63dafaf-el7-x86_64-bundle.tar
	sudo tar xvf Percona-Server-5.7.10-3-r63dafaf-el7-x86_64-bundle.tar
	sudo rpm -ivh Percona-Server-server-57-5.7.10-3.1.el7.x86_64.rpm  Percona-Server-client-57-5.7.10-3.1.el7.x86_64.rpm  Percona-Server-shared-57-5.7.10-3.1.el7.x86_64.rpm
	
	# Move initial database file to persistent directory
	echo -e "--- Move initial database file to persistent directory ---"

	sudo cp /vagrant/config/my.cnf.d-master /etc/my.cnf.d/

	sudo systemctl start mysql
	
	DBPASSWD=sudo cat /var/log/mysqld.log | grep 'root@localhost:' | awk '{print $11}'
	echo $DBPASSWD
	sedo mysql --connect-expired-password -uroot -p$DBPASSWD -e 'ALTER USER USER() IDENTIFIED BY $DBPASSWD;'
	#mysql -e "SET PASSWORD = PASSWORD(''{{ mysql_password.stdout }}'');" --connect-expired-password -uroot -p"{{ mysql_password.stdout }}"'
	#sudo mysql -uroot -p$DBPASSWD -e 'USE mysql; UPDATE `user` SET `Host`="%" WHERE `User`="root" AND `Host`="localhost"; DELETE FROM `user` WHERE `Host` != "%" AND `User`="root"; FLUSH PRIVILEGES;'
	#sudo chown -R mysql:mysql $DBDIRPATH
	#sudo rm -rf $DBDIRPATH/*
	#sudo cp -r -p /var/lib/mysql/* $DBDIRPATH

	sudo systemctl enable mysql
	sudo systemctl start mysql

    ssudo systemctl mysql restart

	touch /var/log/setup_mysql
else
    # If already initialized, then just restart MySQL server
    sudo systemctl mysql start

    #while !(mysql_ready)
    #do
    #   sleep 10s
    #   echo "---- Waiting for MySQL Connection... Check again after 10 secs..."
    #done
fi

