#!/bin/bash
# 20190909

sudo apt-get install tasksel
tasksel --list-task
sudo tasksel install ubuntu-budgie-desktop
sudo reboot
# sudo passwd ubuntu
# configure port forwarding if in chameleonsocks territory
# allow ingress tcp 3389 through security groups

sudo apt-get install xrdp
echo budgie-desktop > ~/.xsession
sudo ufw allow 3389/tcp
sudo reboot

sudo su
sed 's/^exec/#&/' /etc/xrdp/startwm.sh -i
sed 's/^test/#&/' /etc/xrdp/startwm.sh -i
echo budgie-desktop > /etc/xrdp/startwm.sh
exit

# todo: fix timezone