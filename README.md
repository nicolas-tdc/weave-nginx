# weave-service

[Setup your service](#setup-your-service)
[Available commands](#available-commands)

## Setup your service

- **Set your environment variables for each environment**

Modify default-env files for remote modifications

Copy env files to the service's root directory.
Modify root environment files for local modifications

- Configure nginx.conf file manually or generate it automatically using *generate-configuration.sh* script.

## Available scripts and commands
**Execute from your service's root directory**

- **scripts/generate-configuration.sh**

*Generates a default nginx configuration for all your services*
*Backs-up the previous configuration in 'nginx.conf.bak'*
```bash
scripts/generate-configuration.sh
```

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
