## OCS Installation
1. Install this on Centos 6 Minimal installation

1. Run [ocssetup.sh](https://github.com/muhamadfaiz/OCS-and-Fusion-Inventory-Installation/blob/master/ocssetup.sh) on the server
1. Install additional package 

    ```
    cpan
    install XML::Entities
    ```
1. open EPEL Repository and disable (set enabled=0)

    `````
    vi /etc/yum.repos.d/epel.repo
    
    [epel]
	...
    enabled=0
	...

    [epel-debuginfo]
	...
    enabled=0
    ...

    [epel-source]
    ...
    enabled=0
    ...
    ```
1.  IPTABLES exlude ports 80 for Apache, 3306 for MySQL and 25 for SMTP.

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
    wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm && rpm -Uvh epel-release-latest-6.noarch.rpm
    wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm && rpm -Uvh remi-release-6*.rpm
    ```

1. Enable REMI repository globally

    ```
    vi /etc/yum.repos.d/remi.repo
    ```
1.	Under the section that looks like [remi] make the following changes:

    ```
    [remi]
	...
    enabled=1
	...
    ```
1.    Then update PHP
    ```
    yum -y update php*
    ```
1.    Verify the new PHP version
    ```
    php -v
	PHP 5.4.45 (cli) (built: Sep 19 2016 15:31:07)
	Copyright (c) 1997-2014 The PHP Group
	Zend Engine v2.4.0, Copyright (c) 1998-2014 Zend Technologies
    ```
1. Download and setup OCS Inventory

    ```
    cd /var/www/html
    wget https://github.com/OCSInventory-NG/OCSInventory-ocsreports/releases/download/2.3/OCSNG_UNIX_SERVER-2.3.tar.gz
    tar –xvzf OCSNG_UNIX_SERVER-2.3.tar.gz
    cd OCSNG_UNIX_SERVER-2.3
    sh setup.sh
    ```

1. Increase post_max_size and upload_max_filesize in /etc/php.ini
    ```
    vi /etc/php.ini
    post_max_size = 200M
    upload_max_filesize = 200M
    service httpd restart
    ```

1. Perform initial OCS config then login to OCS 
> URL: [IP Address]/ocsreports
> Login: admin
> Password: admin
>  MySQL login: root
MySQL password: [your password when setting up MySQL]
Name of Database: ocsweb
MySQL Hostname: localhost

1. Remove install script
	
    ```rm -f  /usr/share/ocsinventory-reports/ocsreports/install.php```

1. Add write permission to the directory

	``` chmod +w /var/lib/ocsinventory-reports```

1. Change 'Trace Deleted' config to 'ON' in OCS. Config > Config > Server

	![img](http://i.imgur.com/GD8p2TG.png)
    
    ![img](http://i.imgur.com/qtG0R5S.jpg)

1. Go to Config > Plugin and change the 'OCS_SERVER_ADDRESS' to 127.0.0.1

## GLPI Installation

1. Download GLPI

    ```wget https://github.com/glpi-project/glpi/releases/download/9.1.2/glpi-9.1.2.tgz```

2. Move to /var/www/html
    ```
    tar -xzvf glpi-9.1.2.tgz
    mv glpi /var/www/html
    ```
    
3. Turn off SELINUX or set boolean accordingly.

	```
    setenforce 0
    vi /etc/selinux/config
    SELINUX=disabled
    ```

4. Update permissions
    ```
    cd /var/www/html/
    chown apache:apache -R glpi/
    chmod 777 glpi/files/ glpi/config/
    ```
    
4. Edit /etc/httpd/conf/httpd.conf file
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
    
5. Restart Apache ```service httpd restart```

6. Setting up database for GLPI use
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
7. Login to GLPI

    > URL: [IP Address]/glpi
    > Login: glpi
    > Password: glpi

8. Install GLPI cronjob

	```
    crontab -u apache -e
    * * * * * /usr/bin/php /var/www/html/glpi/front/cron.php &>/dev/null
    ```
    
## GLPI and OCS Integration

1. Download OCS plugin https://github.com/pluginsGLPI/ocsinventoryng/releases

2. Extract and put in /var/www/html/glpi/plugins

3. Change ownership to Apache

	```chown -R apache:apache ocsinventoryng/```
    
4. Go back to GLPI Plugin page, click Install, then Enable.

5. Connect GLPI to OCS DB using 'sync' account.

6. Add OCS Server details

	![img](http://imgur.com/5YQQrKo.png)

##Fusion Inventory Installation

1. Transfer and activate Fusion Inventory plugin on GLPI.

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