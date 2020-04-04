#!/bin/bash

sudo cp /vagrant/consul.service  /etc/systemd/system/consul.service
sudo systemctl enable consul
sudo systemctl start consul
sudo systemctl status consul

