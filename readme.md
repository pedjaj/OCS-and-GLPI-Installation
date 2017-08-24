## OCS Installation
1. Install this on Centos 6 Minimal installation

1. Install wget
    ```
    yum install wget -y
    ```
1. Download and run [ocssetup.sh](https://github.com/muhamadfaiz/OCS-and-Fusion-Inventory-Installation/blob/master/ocssetup.sh) on the server

    ```
    wget -O - https://raw.githubusercontent.com/muhamadfaiz/OCS-and-GLPI-Installation/master/ocssetup.sh | bash
    ```

1. Launch MySQL Secure Installation script

	```
    /usr/bin/mysql_secure_installation
    ```

1. Install additional package 

    ```
    perl -MCPAN -e 'install XML::Entities'
    ```

1.  Exclude ports 80 for Apache, 3306 for MySQL and 25 for SMTP from iptables

    ```
    iptables -I INPUT -m multiport -p tcp --dport 80,3306,25 -j ACCEPT
    service iptables save
    service iptables restart
    ```
    
	OR stop iptables service:
    ```
    services iptables stop
    chkconfig iptables off
    ```

1. Install and activate the REMI and EPEL RPM Repositories

    ```
    wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm && rpm -Uvh epel-release-latest-6.noarch.rpm && wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm && rpm -Uvh remi-release-6*.rpm
    ```

1.    Update PHP
    ```
     yum update php* --enablerepo=remi -y
    ```
1.    Verify the new PHP version
    ```
    php -v
    PHP 5.4.45 (cli) (built: Feb 18 2017 15:55:26)
    Copyright (c) 1997-2014 The PHP Group
    Zend Engine v2.4.0, Copyright (c) 1998-2014 Zend Technologies
    ```
1. Download OCS Inventory and run setup

    ```
    cd /var/www/html
    wget https://github.com/OCSInventory-NG/OCSInventory-ocsreports/releases/download/2.3.1/OCSNG_UNIX_SERVER-2.3.1.tar.gz
    tar -xzvf OCSNG_UNIX_SERVER-2.3.1.tar.gz
    cd OCSNG_UNIX_SERVER-2.3.1
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
> URL: [IP Address]/ocsreports
> Login: admin
> Password: admin
>  MySQL login: ocs
MySQL password: [your password when setting up MySQL]
Name of Database: ocsweb
MySQL Hostname: localhost

1. Change 'Trace Deleted' config to 'ON' in OCS. Config > Config > Server

	![img](http://i.imgur.com/GD8p2TG.png)
    
    ![img](http://i.imgur.com/qtG0R5S.jpg)

1. Remove install script
	
    ```
    rm -f  /usr/share/ocsinventory-reports/ocsreports/install.php

## GLPI Installation

1. Download GLPI

    ```
    cd /var/www/html
    wget https://github.com/glpi-project/glpi/releases/download/9.1.6/glpi-9.1.6.tgz
    tar -xzvf glpi-9.1.6.tgz
    ```

1. Update permissions
    ```
    chown apache:apache -R glpi/
    chmod 777 glpi/files/ glpi/config/
    ```
    
1. Edit /etc/httpd/conf/httpd.conf file
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

    > URL: [IP Address]/glpi
    > Login: glpi
    > Password: glpi
    > MySQL Server: 127.0.0.1
    > User: glpi
    > Password: glpisecret
    
## GLPI and OCS Integration

1. Download OCS plugin, extract and change it's ownership. 
    ```
    cd /var/www/html/glpi/plugins
    wget https://github.com/pluginsGLPI/ocsinventoryng/releases/download/1.3.3/glpi-ocsinventoryng-1.3.3.tar.gz
    tar -xzvf glpi-ocsinventoryng-1.3.3.tar.gz
    chown -R apache:apache ocsinventoryng/
    ```
    
1. Go to GLPI > Setup > Plugin page. Click Install, then Enable.

1. Connect GLPI to OCS DB using 'sync' account.

1. Add OCS Server details

	![img](http://imgur.com/5YQQrKo.png)

1. Go to Datas to import, from dropdown select YES.

	![img](https://image.prntscr.com/image/f9ZGzoGAQEqjcStnB_2Zvw.png)

##OCS Agent Installation

1. http://wiki.ocsinventory-ng.org/index.php?title=Documentation:UnixAgent

## Force Election of Host to do IP Discovery

1. Select host in OCS.
2. Go to CONFIGURATION > EDIT > NETWORK SCANS > Select network in IP Discover dropdown

TODO
Get the Office License Number

*Source:*

*http://tamxuanla.blogspot.my/2016/08/how-to-ocs-inventory-212-on-centos-67.html*

*https://www.zerostopbits.com/how-to-upgrade-php-5-3-to-php-5-4-on-centos-6-7/*