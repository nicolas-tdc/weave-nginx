#!/bin/bash

# Exit immediately if a command fails
set -e

# This script generates nginx.conf files for a reverse proxy setup.

if [ -f "./configurations/helpers/write.sh" ]; then
    source "./configurations/helpers/write.sh"
else
    echo -e "\e[31mError: write.sh script not found. Please check the path.\e[0m"
    exit 1
fi

if [ -f "./weave-service/helpers/environment.sh" ]; then
    source "./weave-service/helpers/environment.sh"
else
    echo -e "\e[31mError: environment.sh script not found. Please check the path.\e[0m"
    exit 1
fi

services_directory=".."
configurations_directory="configurations"

if [ -z "$1" ]; then
    # Generate configurations for all environments
    for env_name in dev staging prod
    do
        if [ -f "$configurations_directory/nginx.$env_name.conf" ]; then
            echo -e "\e[33mConfiguration file for $env_name already exists. Skipping...\e[0m"
        else
            echo -e "\e[32mGenerating configuration for $env_name in $configurations_directory...\e[0m"
            prepare_environment_files "$env_name"

            write_environment_configuration \
                "$env_name" \
                "$configurations_directory" \
                "$services_directory"

            echo -e "\e[32mnginx.$env_name.conf generated successfully in $configurations_directory.\e[0m"
        fi
    done
else
    # Generate configuration for a specific environment
    env_name=$1
    if [ -f "$configurations_directory/nginx.$env_name.conf" ]; then
        echo -e "\e[33mConfiguration file for $env_name already exists. Skipping...\e[0m"
    else
        echo -e "\e[32mGenerating configuration for $env_name in $configurations_directory...\e[0m"
        prepare_environment_files "$env_name"

        write_environment_configuration \
            "$env_name" \
            "$configurations_directory" \
            "$services_directory"

        echo -e "\e[32mnginx.$env_name.conf generated successfully in $configurations_directory.\e[0m"
    fi
fi