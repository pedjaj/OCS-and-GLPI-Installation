#!/bin/bash
setenforce 0
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6
yum -y update
yum -y install wget
yum -y install httpd  php php-mysql php-fpm
yum -y install epel-release
#yum -y install php-mbstring php-gd httpd-devel apxs php-mcrypt php-mysql pdo-mysql php-sqlite php-mcrypt php-soap
yum -y install php-mbstring php-gd httpd-devel php-mcrypt php-mysql php-ZendFramework-Db-Adapter-Pdo-Mysql sqlite php-mcrypt php-soap
yum -y install rpm-build redhat-rpm-config
yum -y install telnet-server telnet nmap
#yum -y install mysql-community-release-el7-5.noarch.rpm proj
yum -y install proj
yum -y install tinyxml 
yum -y install mod_perl perl-Archive-Zip perl-CPAN perl-YAML
yum -y install perl-Digest-SHA1 php-pecl-zip php-gd php-gd perl-XML-Simple perl-Net-IP perl-SOAP-Lite httpd-devel perl-DBI perl-DBD-MySQL perl-Compress-Zlib perl-Apache-DBI
yum -y install --enablerepo=epel perl-XML-Entities
chmod 755 -R /var/www/
printf "<?php\nphpinfo();\n?>" > /var/www/html/info.php;
systemctl restart mariadb
systemctl restart httpd
systemctl enable httpd
systemctl enable mariadb
