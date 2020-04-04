#!/bin/bash

nohup python /vagrant/main.py > /vagrant/service.log  2>&1  &
exit