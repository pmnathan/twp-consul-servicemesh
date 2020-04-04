#!/bin/bash

consul config write api_service_defaults.json
sleep 10
consul config write api_service_router.hcl
sleep 10I was abl
consul config write api_service_resolver.hcl