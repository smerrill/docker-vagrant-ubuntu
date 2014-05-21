FROM ubuntu:12.04
MAINTAINER Steven Merrill <steven.merrill@gmail.com>

ADD init-lxc.conf /etc/init/fake-container-events.conf
ADD provision.sh /tmp/provision-vagrant-ubuntu.sh
RUN bash /tmp/provision-vagrant-ubuntu.sh

EXPOSE 22
CMD ["/sbin/init"]

