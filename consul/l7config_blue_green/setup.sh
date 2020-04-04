#!/bin/bash

consul config write api_service_defaults.json
consul config write api_service_router.hcl
consul config write api_service_resolver.hcl