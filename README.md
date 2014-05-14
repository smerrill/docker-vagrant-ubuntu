## vagrant-ubuntu

These are _monolithic_ Docker images (e.g. they runs /sbin/init) that run sshd.
Because of this, it is possible to use all Vagrant provisioners with them.

This is not really the way Docker is meant to be used, but it does result in
configuration management testing with almost no overhead that can be used on a
wide variety of cloud platforms.

### Sample Vagrantfile

    Vagrant.configure("2") do |config|
      config.vm.provider "docker" do |d, override|
        # Use tag :latest or remove the :12.04 to get 14.04 LTS.
        d.image = "smerrill/vagrant-ubuntu:12.04"
        d.has_ssh = true
    
        # This is needed if you have non-Docker provisioners in the Vagrantfile.
        override.vm.box = nil

        # Ensure Vagrant knows the SSH port. See
        # https://github.com/mitchellh/vagrant/issues/3772.
        override.ssh.port = 22
      end
    end

#### Caveats

- The container does not (and cannot) run udev.
  - This may cause services like Avahi to fail to start.
- The container may not load kernel modules. This affect iptables.

