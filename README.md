# weave-service

[Setup your service](#setup-your-service)
[Available commands](#available-commands)

## Setup your service

- **Set your environment variables for each environment**

Modify env-remote files for remote modifications

Modify root environment files for local modifications

- Configure nginx.conf file manually or generate it automatically using *generate-configuration.sh* script.

## Available scripts and commands
**Execute from your service's root directory**

- **configurations/generate.sh**

Generates basic nginx configurations for your applications environments.
```bash
configurations/generate.sh <environment_name(optional)>
```
*Optional: Select environment with first argument dev|staging|prod*
*If none is given, will try to generate for all three environments*

- **r | run**

Starts the service
```bash
./weave.sh r
```
*Development mode*: -d|-dev

- **k | kill**

Stops the service
```bash
./weave.sh k
```
*Development mode*: -d|-dev

- **log | log-available-ports**

Logs the service's available ports
```bash
./weave.sh log
```
*Development mode*: -d|-dev

- **bak | backup-task**

Executes the service's backup-task
```bash
./weave.sh backup-task
```
*Development mode*: -d|-dev
