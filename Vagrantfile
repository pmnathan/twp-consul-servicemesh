# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT

echo "Installing dependencies ..."
sudo apt-get update
sudo apt-get install -y unzip curl jq dnsutils
echo "Installing PIP for Flask ..."
sudo apt-get install -y python-pip
echo "Installing Flask for service demo ..."
pip install flask

echo "Installing envoy..."
#https://www.getenvoy.io/install/envoy/ubuntu/

echo "for Envoy: Install packages required for apt to communicate via HTTPS."
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common

echo "for Envoy: Add the Tetrate GPG key."
curl -sL 'https://getenvoy.io/gpg' | sudo apt-key add -

echo "for Envoy: Add the stable repository."
sudo add-apt-repository \
"deb [arch=amd64] https://dl.bintray.com/tetrate/getenvoy-deb \
$(lsb_release -cs) \
stable"

echo "for Envoy: Install Envoy binary."
sudo apt-get install -y getenvoy-envoy



echo "Determining Consul version to install ..."
CHECKPOINT_URL="https://checkpoint-api.hashicorp.com/v1/check"
if [ -z "$CONSUL_DEMO_VERSION" ]; then
    CONSUL_DEMO_VERSION=$(curl -s "${CHECKPOINT_URL}"/consul | jq .current_version | tr -d '"')
fi

echo "Fetching Consul version ${CONSUL_DEMO_VERSION} ..."
cd /tmp/
curl -s https://releases.hashicorp.com/consul/${CONSUL_DEMO_VERSION}/consul_${CONSUL_DEMO_VERSION}_linux_amd64.zip -o consul.zip

echo "Installing Consul version ${CONSUL_DEMO_VERSION} ..."
unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/bin/consul

sudo mkdir /etc/consul.d
sudo chmod a+w /etc/consul.d

SCRIPT

# Specify a Consul version
CONSUL_DEMO_VERSION = ENV['CONSUL_DEMO_VERSION']

# Specify a custom Vagrant box for the demo
DEMO_BOX_NAME = ENV['DEMO_BOX_NAME'] || "debian/stretch64"

# Vagrantfile API/syntax version.
# NB: Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.box = DEMO_BOX_NAME

  config.vm.provision "shell",
                          inline: $script,
                          env: {'CONSUL_DEMO_VERSION' => CONSUL_DEMO_VERSION}

  config.vm.define "consul" do |consul|
      consul.vm.hostname = "consul"
      consul.vm.synced_folder "consul", "/vagrant"
      consul.vm.provision "shell", path: "startconsul.sh"
      consul.vm.network "private_network", ip: "172.20.20.10"
      consul.vm.network "forwarded_port", guest: 8500, host: 8080
  end

  config.vm.define "frontend" do |frontend|
    frontend.vm.hostname = "frontend"
    frontend.vm.synced_folder "frontend", "/vagrant"
    frontend.vm.provision "shell", path: "startconsul.sh"
    frontend.vm.provision "shell", path: "startapi.sh"
    frontend.vm.provision "shell", path: "startenvoyproxy.sh"
    frontend.vm.network "private_network", ip: "172.20.20.11"
    frontend.vm.network "forwarded_port", guest: 19000, host: 19001
    frontend.vm.post_up_message = "Frontend UI: http://172.20.20.11:19001"
    #frontend.vm.post_up_message = "envoy UI: http://localhost:19001"
  end


  config.vm.define "apiv1" do |apiv1|
      apiv1.vm.hostname = "apiv1"
      apiv1.vm.synced_folder "apiv1", "/vagrant"
      apiv1.vm.provision "shell", path: "startconsul.sh"
      apiv1.vm.provision "shell", path: "startapi.sh"
      apiv1.vm.provision "shell", path: "startenvoyproxy.sh"
      apiv1.vm.network "private_network", ip: "172.20.20.15"
      apiv1.vm.network "forwarded_port", guest: 19000, host: 19015
      apiv1.vm.post_up_message = "apiv1 UI: http://172.20.20.15:19001"
      #apiv1.vm.post_up_message = "envoy UI: http://localhost:19015"

  end

  config.vm.define "apiv2" do |apiv2|
      apiv2.vm.hostname = "apiv2"
      apiv2.vm.synced_folder "apiv2", "/vagrant"
      apiv2.vm.provision "shell", path: "startconsul.sh"
      apiv2.vm.provision "shell", path: "startapi.sh"
      apiv2.vm.provision "shell", path: "startenvoyproxy.sh"
      apiv2.vm.network "private_network", ip: "172.20.20.16"
      apiv2.vm.network "forwarded_port", guest: 19000, host: 19016
      apiv2.vm.post_up_message = "apiv2 UI: http://172.20.20.16:19001"
      #apiv2.vm.post_up_message = "envoy UI: http://localhost:19016"

  end

end
