#!/usr/bin/env bash

echo "=== Installing Composer..."
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo "=== Installing Drush..."
composer global require drush/drush
sudo ln -s ~/.config/composer/vendor/drush/drush/drush /usr/sbin/drush

exit 0
