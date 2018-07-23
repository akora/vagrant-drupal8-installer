#!/usr/bin/env bash

MySQL_config_file="/etc/mysql/my.cnf"

echo "=== Installing MySQL server and setting root password..."
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get install -y mysql-client mysql-server

echo "=== Fixing warnings about changed setting names in $MySQL_config_file..."
if grep -Fxq "key_buffer_size" $MySQL_config_file
then
  echo "=== key_buffer_size found, nothing to do..."
else
  echo "=== key_buffer_size..."
  sed -i 's/key_buffer/key_buffer_size/g' $MySQL_config_file
fi

if grep -Fxq "myisam-recover-options" $MySQL_config_file
then
  echo "=== myisam-recover-options found, nothing to do..."
else
  echo "=== myisam-recover-options..."
  sed -i 's/myisam-recover/myisam-recover-options/g' $MySQL_config_file
fi

echo "=== Allowing remote management of MySQL server..."
if grep -Fxq "0.0.0.0" $MySQL_config_file
then
  echo "=== 0.0.0.0 found, nothing to do..."
else
  echo "=== 0.0.0.0..."
  sed -i 's/127.0.0.1/0.0.0.0/g' $MySQL_config_file
fi

mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY 'root';"
mysql -uroot -proot -e "FLUSH PRIVILEGES;"

echo "=== Restarting service for changes to take effect..."
service mysql restart

echo "=== Installing Apache & PHP 7.2..."
add-apt-repository ppa:ondrej/php -y
apt-get update
apt-get install -y apache2 php7.2 libapache2-mod-php7.2 php7.2-mysql php7.2-gd php7.2-curl php7.2-mbstring php7.2-xml php-uploadprogress

echo "=== Enabling mod_rewrite & clean URLs..."
a2enmod rewrite
sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

echo "=== Restarting service & removing default index.html..."
service apache2 restart
rm /var/www/html/index.html

exit 0
