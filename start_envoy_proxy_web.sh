#!/bin/bash

nohup consul connect envoy -sidecar-for web > /vagrant/envoy.log &
exit
