# Consul Service Mesh L7 Traffic Routing Demo

### Prerequisites
1. Vagrant (https://www.vagrantup.com/downloads.html)
2. Virtual Box 

### Startup
```
vagrant up --parallel
```

This will start up 4 virtual machines. You can use `vagrant status` to list the machines. If everything went well it should return the following

1. consul
2. web
3. apiv1 (api version 1)
4. apiv2 (api version 2)

The `Vagrantfile` has more information on how each of the boxes are set up. 

The home folder where configuration and logs are stored can be found at `/vagrant` folder. This is the same for all the VMs. The configuration is copied directly from the respective folders in the git repository. for e.g the data under the `web` folder in the git repository is copied to `/vagrant` folder in the `web VM`.

### Consul UI
The consul UI can be reached at [http://localhost:8080](http://localhost:8080)


### Test the Service Mesh
SSH into the web VM
```
vagrant ssh web
```
Once inside the  web VM..you can test the service mesh using curl. Web is connected to api. 

```
curl localhost:9191
```

this is because the local bind port is set to 9191 in `web_service.json` file

```
...
      "connect": { "sidecar_service": {
        "proxy": {
          "upstreams": [{
             "destination_name": "api",
             "local_bind_port": 9191
          }]
        }
      }
      },
...
```
  
### Enable Layer 7 Traffic Routing
Layer 7 Configuration files are stored in the Consul VM under the  `l7config' folder. the Following commands can be used to enable L7 traffic routing...

Enter the consul VM
```
vagrant ssh consul
```

Write the configuration files
```
consul config write /vagrant/l7config/api_service_defaults.json
consul config write /vagrant/l7config/api_service_router
consul config write /vagrant/l7config/api_service_resolver.json
```

### Test Layer 7 Traffic routing
SSH into the web VM
```
vagrant ssh web
```

Curl to `curl localhost:9191`. You will notice that it always return API V1 as that is the default being set in the `api_service_resolver.json` file.

```
kind           = "service-resolver"
name           = "api"
default_subset = "v1" <-----
subsets = {
  "v1" = {
    filter = "Service.Meta.version == 1"
  }
  "v2" = {
    filter = "Service.Meta.version == 2"
  }
}
```

Now we can also curl to the paths and we will see how they redirect to the appropriate version of the service.
```
curl localhost:9191/v1
```
The above will direct traffic to API V1. 

```
curl localhost:9191/v2
```
As expected above will direct traffic to API V2.

The key to the routing is in the router file...
```
kind = "service-router"
name = "api"
routes = [
  {
    match {
      http {
        path_prefix = "/v1"
      }
    }

    destination {
      service = "api"
      service_subset = "v1"
      prefix_rewrite  = "/"
    }
  },

   {
    match {
      http {
        path_prefix = "/v2"
      }
    }

    destination {
      service = "api"
      service_subset = "v2"
      prefix_rewrite  = "/"
    }
  },
  
] 
```

