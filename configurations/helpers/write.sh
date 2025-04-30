#!/bin/bash

# Exit immediately if a command fails
set -e

# This script generates nginx.conf files for a reverse proxy setup.

write_service_configuration() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
        echo "Usage: $0 <service_directory> <env_name> <configuration_file>"
        return 1
    fi
    local env_name=$1
    local configuration_file=$2
    local service_directory=$3
    local service_name=$4

    env_file="${service_directory}.env.$env_name"

    # Detect if Dockerized
    if [[ -f "$service_directory/Dockerfile" || -f "$service_directory/docker-compose.yml" ]]; then
        host_name="$service_name"
    else
        host_name="host.docker.internal"
    fi

    # Extract port from .env
    if [[ -f "$env_file" ]]; then
        port=$(grep '^PORT=' "$env_file" | cut -d '=' -f2)
    fi

    if ! [[ -z "$port" ]]; then
        # Append location block to nginx.conf
        cat >> "$configuration_file" <<EOF

            location /${service_name}/ {
                proxy_pass http://${host_name}:${port}/;
                proxy_set_header Host \$host;
            }
EOF

    echo "✔ Added: /${service_name}/ → http://${host_name}:${port}/"

    fi
}

write_environment_configuration() {
    local env_name=$1
    local configurations_directory=$2
    local services_directory=$3

    local configuration_file="$configurations_directory/nginx.$env_name.conf"

    # Start nginx.conf content
    cat > "$configuration_file" <<EOF
    events {}

    http {
        server {
            listen ${PORT:-80};
EOF

    # Loop through each service
    for service_directory in "$services_directory"/*/; do
        [ -d "$service_directory" ] || continue

        nginx_service_name=$(basename "$PWD")
        service_name=$(basename "$service_directory")
        [ "$service_name" == "$nginx_service_name" ] && continue

        write_service_configuration "$env_name" "$configuration_file" "$service_directory" "$service_name"
    done

    # Close config
    echo "    }" >> "$configuration_file"
    echo "}" >> "$configuration_file"
}
