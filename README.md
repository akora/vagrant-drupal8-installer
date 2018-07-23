### Install Drupal 8 & Drush inside a Vagrant (VirtualBox) VM

Based on HashiCorp's "ubuntu/xenial64" box.

The base VM is built as described in the `Vagrantfile` and `bootstrap.sh`.

Start the process by running

``` shell
vagrant up
```

Once the VM is ready, issue

``` shell
vagrant ssh
```

Now you are inside the box. Here install MySQL, Apache, PHP 7.2, Composer, Drush 9, and finally the latest stable Drupal 8.

``` shell
cd shared
sudo ./install-mysql-apache-php72.sh
./install-composer-drush.sh
./install-drupal8.sh
```

Once it's all finished, visit 192.168.100.102 in a web browser.

Inside the VM Drush is fully functional in the web root: `/var/www/html/web`

The username and password for the login is admin/admin.

To remove/reset everything exit the VM and use `vagrant-cleanup.sh` to clean up. BEWARE that the cleanup process destroys the VM!

#### Tested on

* MacOS High Sierra 10.13.6
* VirtualBox 5.2.16r123759
