#!/usr/bin/env bash

echo "=== Installing Drupal 8 - Composer part..."
sudo chown vagrant:www-data /var/www/html/
composer create-project drupal-composer/drupal-project:8.x-dev /var/www/html --stability dev --no-interaction

echo "=== Installing Drupal 8 - Drush part..."
cd /var/www/html/web/
drush site-install minimal --site-name=D8 --account-name=admin --account-pass=admin --db-url=mysql://root:root@localhost/d8 --account-mail=vagrant@vm02.vbox.local.dev --site-mail=vagrant@vm02.vbox.local.dev -y

sudo chmod 777 sites/default/settings.php
echo "\$settings['trusted_host_patterns'] = ['^192\.168\.\d{1,3}\.\d{1,3}$',];" >> sites/default/settings.php
sudo chmod 644 sites/default/settings.php

# drush config-set system.theme default bartik -y
# drush config-set system.theme admin bartik -y

sudo chmod -R 777 sites/default/files/

drush pm:en toolbar field_ui menu_ui path taxonomy views views_ui language locale -y
drush cr
drush status

echo "=== Setting new DocumentRoot excluding /web..."
sudo sed -i 's|DocumentRoot \/var\/www\/html|DocumentRoot \/var\/www\/html\/web|g' /etc/apache2/sites-enabled/000-default.conf
sudo /etc/init.d/apache2 restart

exit 0
