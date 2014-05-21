FROM smerrill/vagrant-ubuntu
MAINTAINER Steven Merrill <steven.merrill@gmail.com>

RUN wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb -O /tmp/puppetlabs-release-precise.deb && \
  dpkg -i /tmp/puppetlabs-release-precise.deb && \
  apt-get -y update && \
  apt-get -y install puppet=3.4.3-1puppetlabs1 puppet-common=3.4.3-1puppetlabs1
