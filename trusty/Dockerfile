FROM ubuntu:14.04
MAINTAINER Steven Merrill <steven.merrill@gmail.com>

# This image was adapted from
# https://github.com/tianon/dockerfiles/blob/master/sbin-init/ubuntu/upstart/14.04/Dockerfile.
# Many thanks to Tianon.

# much of this was gleaned from https://github.com/lxc/lxc/blob/lxc-0.8.0/templates/lxc-ubuntu.in

# we're going to want this bad boy installed so we can connect :)
RUN apt-get update -y

# Install many common packages.
# rsync and openssh-clients are needed for Vagrant.
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y postfix rsyslog sudo zip tar rsync openssh-client wget curl openssh-server unzip

ADD init-lxc.conf /etc/init/fake-container-events.conf

# undo some leet hax of the base image
RUN rm /usr/sbin/policy-rc.d; \
  rm /sbin/initctl; dpkg-divert --rename --remove /sbin/initctl

# generate a nice UTF-8 locale for our use
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

# remove some pointless services
RUN /usr/sbin/update-rc.d -f ondemand remove; \
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
RUN sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd

# No more requiretty for sudo. (Vagrant likes to run Puppet/shell via sudo.)
RUN sed -i 's/.*requiretty$/Defaults !requiretty/' /etc/sudoers

# Let this run as an unmodified Vagrant box.
RUN groupadd vagrant
RUN useradd vagrant -g vagrant -G sudo
RUN echo "vagrant:vagrant" | chpasswd
RUN echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/vagrant
RUN chmod 0440 /etc/sudoers.d/vagrant
RUN chsh -s /bin/bash vagrant

# Installing vagrant keys
RUN mkdir -pm 700 /home/vagrant/.ssh
RUN wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
RUN chmod 0600 /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant /home/vagrant/.ssh

# Customize the message of the day
RUN echo 'Welcome to your Vagrant-built Docker container.' > /etc/motd

EXPOSE 22
CMD ["/sbin/init"]

