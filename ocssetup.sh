#!/bin/bash
setenforce 0
yum -y update
yum -y install wget
sudo yum -y install httpd mysql mysql-server mysql-devel php php-mysql php-fpm;
service mysqld start
/usr/bin/mysql_secure_installation
service mysqld restart
sudo yum -y install epel-release
sudo yum -y install php-mbstring php-gd httpd-devel apxs php-mcrypt php-mysql pdo-mysql php-sqlite php-mcrypt php-soap
sudo yum -y install epel-release rpm-build redhat-rpm-config
sudo yum -y install mysql-community-release-el7-5.noarch.rpm proj
sudo yum -y install tinyxml libzip mysql-workbench-community
sudo yum -y install unzip
sudo yum install -y mod_perl perl-Archive-Zip perl-CPAN perl-YAML
sudo yum install -y perl-Digest-SHA1 php-pecl-zip php-gd php5-gd perl-XML-Simple perl-Net-IP perl-SOAP-Lite httpd-devel perl-DBI perl-DBD-MySQL perl-Compress-Zlib perl-Apache-DBI
sudo yum install -y --enablerepo=epel perl-Apache-DBI perl-XML-Entities
sudo chmod 755 -R /var/www/;
sudo printf "<?php\nphpinfo();\n?>" > /var/www/html/info.php;
sudo service mysqld restart;
sudo service httpd restart;
sudo chkconfig httpd on;
sudo chkconfig mysqld on;