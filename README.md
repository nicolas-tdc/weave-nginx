# weave-service

See weave documentation [weave](https://github.com/nicolas-tdc/weave)

## Setup your service

- **Set your environment variables for each environment**

Modify environment files if needed.

- **Configure Nginx**

Configure nginx.conf file manually or generate a generic version automatically using *generate-configuration.sh* script.
It will fetch ports for each installed service and create a corresponding location using the service name.

When using the Nginx service, you can adapt other services docker-compose files to only expose ports internally to docker.
Replace ${PORT}:${PORT} with EXPOSE: ${PORT}

## Available scripts and commands
**Execute from your service's root directory**

- **configurations/generate.sh**

Generates basic nginx configurations for your application's environments.
Fetches ports and service names to create corresponding nginx locations.
```bash
configurations/generate.sh <environment_name(optional)>
```
*Optional: Select environment with first argument dev|staging|prod*
*If none is given, will try to generate for all three environments*
