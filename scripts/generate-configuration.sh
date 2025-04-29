#!/bin/bash

SERVICES_DIR="./services"
NGINX_CONF="./nginx.conf"
BACKUP_CONF="./nginx.conf.bak"

echo "Generating new nginx.conf..."

# Backup existing config
if [ -f "$NGINX_CONF" ]; then
    cp "$NGINX_CONF" "$BACKUP_CONF"
    echo "Backed up existing nginx.conf to nginx.conf.bak"
fi

# Start nginx.conf content
cat > "$NGINX_CONF" <<EOF
events {}

http {
    server {
        listen 80;
EOF

# Loop through each service
for dir in "$SERVICES_DIR"/*/; do
    [ -d "$dir" ] || continue

    service_name=$(basename "$dir")
    env_file="${dir}/.env"

    # Detect if Dockerized
    if [[ -f "$dir/Dockerfile" || -f "$dir/docker-compose.yml" ]]; then
        host_name="$service_name"
    else
        host_name="host.docker.internal"
    fi

    # Extract port from .env
    if [[ -f "$env_file" ]]; then
        port=$(grep '^PORT=' "$env_file" | cut -d '=' -f2)
    fi

    if [[ -z "$port" ]]; then
        echo "⚠️  No PORT found for $service_name — using default 8080"
        port=8080
    fi

    # Append location block to nginx.conf
    cat >> "$NGINX_CONF" <<EOF

        location /${service_name}/ {
            proxy_pass http://${host_name}:${port}/;
            proxy_set_header Host \$host;
        }
EOF

    echo "✔ Added: /${service_name}/ → http://${host_name}:${port}/"

done

# Close config
echo "    }" >> "$NGINX_CONF"
echo "}" >> "$NGINX_CONF"

echo "✅ nginx.conf generated successfully."
