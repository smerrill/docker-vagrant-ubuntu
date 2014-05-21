#!/bin/bash -xe

# This image was adapted from
# https://github.com/tianon/dockerfiles/blob/master/sbin-init/ubuntu/upstart/14.04/Dockerfile.
# Many thanks to Tianon.

# much of this was gleaned from https://github.com/lxc/lxc/blob/lxc-0.8.0/templates/lxc-ubuntu.in

# we're going to want this bad boy installed so we can connect :)
apt-get update -y

# Install many common packages.
# rsync and openssh-clients are needed for Vagrant.
DEBIAN_FRONTEND=noninteractive apt-get install -y postfix rsyslog sudo zip tar rsync openssh-client wget curl openssh-server unzip

# undo some leet hax of the base image
rm /usr/sbin/policy-rc.d; \
  rm /sbin/initctl; dpkg-divert --rename --remove /sbin/initctl

# generate a nice UTF-8 locale for our use
locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

# remove some pointless services
/usr/sbin/update-rc.d -f ondemand remove; \
  ( \
    cd /etc/init; \
    for f in \
      u*.conf \
      tty[2-9].conf \
      plymouth*.conf \
      hwclock*.conf \
      module*.conf\
    ; do \
      mv $f $f.orig; \
    done \
  ); \
  echo '# /lib/init/fstab: cleared out for bare-bones lxc' > /lib/init/fstab

# small fix for SSH in 13.10 (that's harmless everywhere else)
sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd

# No more requiretty for sudo. (Vagrant likes to run Puppet/shell via sudo.)
sed -i 's/.*requiretty$/Defaults !requiretty/' /etc/sudoers

# Let this run as an unmodified Vagrant box.
groupadd vagrant
useradd vagrant -g vagrant -G sudo
echo "vagrant:vagrant" | chpasswd
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant
chsh -s /bin/bash vagrant

# Installing vagrant keys
mkdir -pm 700 /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Customize the message of the day
echo 'Welcome to your Vagrant-built Docker container.' > /etc/motd
