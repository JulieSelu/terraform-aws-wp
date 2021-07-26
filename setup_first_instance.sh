#!/bin/bash
sudo yum update -y
sudo yum install -y mysql httpd
sudo service httpd start
sudo wget -c https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns_name}:/ /var/www/html
sudo cp -r wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
sudo cp /tmp/wp-config.php /var/www/html/wp-config.php
sudo service httpd restart
sleep 20