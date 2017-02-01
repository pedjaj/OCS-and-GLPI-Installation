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
1. OR stop iptables service:
```
#services iptables stop
#chkconfig iptables off
```