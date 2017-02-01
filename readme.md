1. Install this on Centos 6 Minimal installation

2. Run [ocssetup.sh](https://github.com/muhamadfaiz/OCS-and-Fusion-Inventory-Installation/blob/master/ocssetup.sh) on the server
3. Install additional package 

    ```
    yum install -y mod_perl perl-Archive-Zip perl-CPAN perl-YAML
    cpan
    install XML::Entities
    ```
4. open EPEL Repository and disable (set enabled=0)

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
1.  IPTABLES exlude ports 80 for Apache and 3306 for MySQL

    ```
    # iptables -I INPUT -m multiport -p tcp --dport 80,3306 -j ACCEPT
    # service iptables save
    # service iptables restart
    ```
    
	OR stop iptables service:
    ```
    #services iptables stop
    #chkconfig iptables off
    ```
    
1. Install OCS Inventory pre-requisite packages
    ```
	# yum install -y php-pecl-zip libphp-pclzip libxml-simple-perl libio-compress-perl libdbi-perl libdbd-mysql-perl libapache-dbi-perl libnet-ip-perl libsoap-lite-perl php-gd php5-gd perl-XML-Simple perl-Net-IP perl-SOAP-Lite httpd-devel perl-DBI perl-DBD-MySQL perl-Compress-Zlib perl-Apache-DBI
	# yum install -y --enablerepo=epel perl-Apache-DBI perl-Apache2-SOAP perl-XML-Entities
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
	Under the section that looks like [remi] make the following changes:

    ```
    [remi]
    name=Remi's RPM repository for Enterprise Linux 6 - $basearch
    #baseurl=http://rpms.remirepo.net/enterprise/6/remi/$basearch/
    mirrorlist=http://rpms.remirepo.net/enterprise/6/remi/mirror
    enabled=1
    gpgcheck=1
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi
    ```