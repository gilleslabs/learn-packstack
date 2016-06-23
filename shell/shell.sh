sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network
sudo yum install ntp
sudo chkconfig ntpd on
sudo ntpdate  0.fr.pool.ntp.org
sudo /etc/init.d/ntpd start
sudo hostname 'packstack.example.com'
echo "packstack.example.com" | sudo tee /etc/hostname
echo -e "192.168.0.52 `hostname` `hostname -s`" | sudo tee -a /etc/hosts
sudo yum install -y centos-release-openstack-mitaka
sudo yum update -y
sudo yum install -y openstack-packstack
sudo packstack --answer-file /home/vagrant/sync/config/packstack.txt
su -
sed -i "s/#OPENSTACK_HOST = \"127.0.0.1\"/OPENSTACK_HOST = \"192.168.0.52\"/g" /etc/openstack-dashboard/local_settings
sed -i "s/10.0.2.15/192.168.0.52/g" /etc/openstack-dashboard/local_settings
sed -i "s/10.0.2.15/192.168.0.52/g" /etc/httpd/conf.d/15-horizon_vhost.conf
echo Updating System... Please Wait ...
sleep 10m
echo Rebooting
reboot