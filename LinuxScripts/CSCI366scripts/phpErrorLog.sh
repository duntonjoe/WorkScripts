#enable PHP error logging on all DWD VMs

cd /etc/php/7.0/apache2
rm php.ini
scp jmdunotn.millersville.edu /etc/php/7.0/apache2/php.ini /etc/php/7.0/apache2
touch /var/log/php-errors.log
chown www-data:www-data /var/log/php-errors.log
systemctl restart apache2.service
systemctl status apache2.service
