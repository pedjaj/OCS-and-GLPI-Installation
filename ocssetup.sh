#!/bin/bash
setenforce 0
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf && echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6
yum -y update
yum -y install wget
yum -y install httpd mysql mysql-server mysql-devel php php-mysql php-fpm;
service mysqld start
yum -y install epel-release
yum -y install php-mbstring php-gd httpd-devel apxs php-mcrypt php-mysql pdo-mysql php-sqlite php-mcrypt php-soap
yum -y install epel-release rpm-build redhat-rpm-config
yum -y install mysql-community-release-el7-5.noarch.rpm proj
yum -y install tinyxml libzip mysql-workbench-community
yum -y install unzip
yum install -y mod_perl perl-Archive-Zip perl-CPAN perl-YAML
yum install -y perl-Digest-SHA1 php-pecl-zip php-gd php5-gd perl-XML-Simple perl-Net-IP perl-SOAP-Lite httpd-devel perl-DBI perl-DBD-MySQL perl-Compress-Zlib perl-Apache-DBI
yum install -y --enablerepo=epel perl-Apache-DBI perl-XML-Entities
chmod 755 -R /var/www/;
printf "<?php\nphpinfo();\n?>" > /var/www/html/info.php;
/usr/bin/mysql_secure_installation
service mysqld restart
service httpd restart
chkconfig httpd on
chkconfig mysqld on