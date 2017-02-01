 #!/bin/bash
# ******************************************
# Program: LAMP Stack Installation Script
# Developer: La Dai Hiep
# Date: 17-08-2016
# Last Updated: 17-08-2016
# ******************************************
setenforce 0
yum -y update
yum -y install wget
sudo yum -y install httpd mysql mysql-server mysql-devel php php-mysql php-fpm;
service mysqld start
/usr/bin/mysql_secure_installation
service mysqld restart
wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm --import https://fedoraproject.org/static/0608B895.txt
rpm -ivh epel-release-6-8.noarch.rpm
sudo yum -y install php-mbstring php-gd httpd-devel apxs php-mcrypt php-mysql pdo-mysql php-sqlite php-mcrypt php-soap;
sudo yum -y install epel-release rpm-build redhat-rpm-config;
sudo yum -y install mysql-community-release-el7-5.noarch.rpm proj;
sudo yum -y install tinyxml libzip mysql-workbench-community;
sudo chmod 755 -R /var/www/;
sudo printf "<?php\nphpinfo();\n?>" > /var/www/html/info.php;
cd //var/www/html
wget https://files.phpmyadmin.net/phpMyAdmin/4.0.10.15/phpMyAdmin-4.0.10.15-all-languages.zip
echo y | yum install unzip
unzip phpMyAdmin-4.0.10.15-all-languages.zip
rm -rf phpMyAdmin-4.0.10.15-all-languages.zip
mv phpMyAdmin-4.0.10.15-all-languages/ phpmyadmin
sudo service mysqld restart;
sudo service httpd restart;
sudo chkconfig httpd on;
sudo chkconfig mysqld on;