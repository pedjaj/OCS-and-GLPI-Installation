## OCS 2.9.2 and GLPI 9.5.7 Installation
1. Install this on Centos 7 Minimal installation

1. Install wget, latest MariaDB
    ```
    yum install wget nano mc
    wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
    chmod +x mariadb_repo_setup
    ./mariadb_repo_setup
    yum install MariaDB-server MariaDB
    
    ```
1. Download and run [ocssetup.sh](https://github.com/pedjaj/OCS-and-GLPI-Installation/blob/master/ocssetup.sh) on the server

    ```
    wget -O - https://raw.githubusercontent.com/muhamadfaiz/OCS-and-GLPI-Installation/master/ocssetup.sh | bash
    ```

1. Launch MySQL Secure Installation script

	```
    /usr/bin/mysql_secure_installation
    ```

1. Install additional package 

    ```
    cpan XML::Entities
    cpan Apache::DBI
    cpan ModPerl::MM
    cpan Apache2::SOAP
    yum install perl-Mojolicious
    yum install perl-Switch
    yum install perl-Plack
    
    service httpd restart
    ```

1.  Exclude ports 80 for Apache, 3306 for MySQL and 25 for SMTP from iptables

    ```
    firewall-cmd --zone=public --add-port=80/tcp --permanent
    firewall-cmd --zone=public --add-port=3306/tcp --permanent
    firewall-cmd --zone=public --add-port=25/tcp --permanent
    firewall-cmd --reload
    ```

1. Install and activate the REMI and EPEL RPM Repositories

    ```
    wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && rpm -Uvh *.rpm
    ```

1. Update PHP
    ```
    #yum update php* --enablerepo=remi -y
    #wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && rpm -Uvh *.rpm
    #yum update php* --enablerepo=remi -y
    yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
    yum -y install yum-utils
    yum-config-manager --enable remi-php74
    yum update
    yum install php php-cli
    ```

1. Verify the new PHP version

    ```
    php -v

	PHP 7.4.28 (cli) (built: Feb 15 2022 13:23:10) ( NTS )
	Copyright (c) The PHP Group
	Zend Engine v3.4.0, Copyright (c) Zend Technologies
    	with Zend OPcache v7.4.28, Copyright (c), by Zend Technologies

    ```
    
1. Download OCS Inventory and run setup

    ```
    OCS_VER=2.9.2 &&
    cd /var/www/html &&
    wget https://github.com/OCSInventory-NG/OCSInventory-ocsreports/releases/download/2.9.2/OCSNG_UNIX_SERVER-2.9.2.tar.gz &&
    tar -xzvf OCSNG_UNIX_SERVER_$OCS_VER.tar.gz &&
    cd OCSNG_UNIX_SERVER_$OCS_VER &&
    ./setup.sh
    ```

1. Increase post_max_size and upload_max_filesize in /etc/php.ini
    ```
    post_max_size = 200M
    upload_max_filesize = 200M
    ```

1. Restart Apache
    ```
    service httpd restart
    ```

1. Add write permission to the directory

	```
    	chmod +w /var/lib/ocsinventory-reports
    	chown -R apache:apache /usr/share/ocsinventory-reports/
	chown -R apache:apache /var/lib/ocsinventory-reports/
	find /usr/share/ocsinventory-reports/ocsreports/ -type f -exec chmod 0644 {} \;
	find /usr/share/ocsinventory-reports/ocsreports/ -type d -exec chmod 0755 {} \;
	chcon -t httpd_sys_rw_content_t /usr/share/ocsinventory-reports/ocsreports
	chcon -t httpd_sys_rw_content_t /usr/share/ocsinventory-reports/ocsreports/upload
	chcon -t httpd_sys_rw_content_t /usr/share/ocsinventory-reports/ocsreports/dbconfig.inc.php

    ```

1. Run mysql_upgrade

    ```
    mysql_upgrade -uroot -p[password]
    ```

1. Create OCS user in MySQL and assign privileges for OCSWEB database
    ```
    mysql -uroot -p[password]
    GRANT ALL PRIVILEGES ON `ocsweb` .* TO 'ocs'@'localhost' IDENTIFIED BY 'ocs' WITH GRANT OPTION;
    ```

1. Perform initial OCS config then login to OCS 
    ```
    URL: [IP Address]/ocsreports
    Login: admin
    Password: admin
    MySQL login: ocs
    MySQL password: [your password when setting up MySQL]
    Name of Database: ocsweb
    MySQL Hostname: localhost
    ```

1. Change 'Trace Deleted' config to 'ON' in OCS. Config > Config > Server

	![img](http://i.imgur.com/GD8p2TG.png)
    
    ![img](http://i.imgur.com/qtG0R5S.jpg)

1. Remove install script
	
    ```
    rm -f  /usr/share/ocsinventory-reports/ocsreports/install.php
    ```

## GLPI Installation

1. Download GLPI and install dependeses

    ```
    cd /var/www/html
    wget https://github.com/glpi-project/glpi/releases/download/9.5.7/glpi-9.5.7.tgz
    tar -xzvf glpi-9.5.7.tgz
    yum install php-intl  php-ldap  php-apcu php-opcache php-xmlrpc php-zip
        
    ```

1. Update permissions
    ```
    chown apache:apache -R glpi/
    chmod 777 glpi/files/ glpi/config/
    ```
    
1. Edit /etc/httpd/conf/httpd.conf file. Change all occurrences of AllowOverride None to AllowOverride All
    ```
    ...
    <Directory />
        Options FollowSymLinks
        AllowOverride All
    </Directory>
    ...
    AllowOverride All
	...
    ```
    
1. Restart Apache 
    ```
    service httpd restart
    ```

1. Setting up database for GLPI use
    ```
    mysql -u root -p [rootsecret]
    CREATE USER 'glpi'@'%' IDENTIFIED BY 'glpisecret';
    GRANT USAGE ON *.* TO 'glpi'@'%' IDENTIFIED BY 'glpisecret';
    CREATE DATABASE IF NOT EXISTS `glpi`;
    GRANT ALL PRIVILEGES ON `glpi`.* TO `glpi`@'%';
    CREATE USER 'sync'@'%' IDENTIFIED BY 'syncsecret';
    GRANT USAGE ON *.* TO 'sync'@'%' IDENTIFIED BY 'syncsecret';
    GRANT SELECT ON `ocsweb`.* TO `sync`@'%';
    GRANT DELETE ON `ocsweb`.`deleted_equiv` TO `sync`@`%`;
    GRANT UPDATE (`CHECKSUM`) ON `ocsweb`.`hardware` TO `sync`@`%`;
    FLUSH PRIVILEGES;
    exit
    ```
    
1. Install GLPI cronjob

	```
    crontab -u apache -e
    * * * * * /usr/bin/php /var/www/html/glpi/front/cron.php &>/dev/null
    ```    
    
1. Login to GLPI
    ```
    URL: [IP Address]/glpi
    Login: glpi
    Password: glpi
    MySQL Server: 127.0.0.1
    User: glpi
    Password: glpisecret
    ```

## GLPI and OCS Integration

1. Download OCS plugin, extract and change it's ownership. 
    ```
    cd /var/www/html/glpi/plugins
    wget https://github.com/pluginsGLPI/ocsinventoryng/releases/download/1.4.3/glpi-ocsinventoryng-1.4.3.tar.gz
    tar -xzvf glpi-ocsinventoryng-1.4.3.tar.gz
    chown -R apache:apache ocsinventoryng/
    ```
    
1. Go to GLPI > Setup > Plugin page. Click Install, then Enable.

1. Connect GLPI to OCS DB using 'sync' account.

1. Add OCS Server details

	![img](http://imgur.com/5YQQrKo.png)

1. Go to Datas to import, from dropdown select YES.

	![img](https://image.prntscr.com/image/f9ZGzoGAQEqjcStnB_2Zvw.png)

## OCS Agent Installation

http://wiki.ocsinventory-ng.org/index.php?title=Documentation:UnixAgent

## Force Election of Host to do IP Discovery

1. Select host in OCS.
2. Go to CONFIGURATION > EDIT > NETWORK SCANS > Select network in IP Discover dropdown

*Source:*

*http://tamxuanla.blogspot.my/2016/08/how-to-ocs-inventory-212-on-centos-67.html*
*https://www.zerostopbits.com/how-to-upgrade-php-5-3-to-php-5-4-on-centos-6-7/*
