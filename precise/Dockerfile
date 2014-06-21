FROM ubuntu:12.04
MAINTAINER Steven Merrill <steven.merrill@gmail.com>

# Update libselinux so that sshd will work on hosts with newer libselinux
# (such as Fedora.)
RUN add-apt-repository ppa:ariel-wikimedia/ppa && \
  apt-get update && \
  apt-get install -y libselinux1

ADD init-lxc.conf /etc/init/fake-container-events.conf
ADD provision.sh /tmp/provision-vagrant-ubuntu.sh
RUN bash /tmp/provision-vagrant-ubuntu.sh

EXPOSE 22
CMD ["/sbin/init"]

