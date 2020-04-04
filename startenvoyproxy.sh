#!/bin/bash

nohup consul connect envoy -sidecar-for api > /vagrant/envoy.log &
exit
