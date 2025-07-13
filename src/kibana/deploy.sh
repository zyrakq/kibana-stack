#!/bin/bash

# Kibana Deployment Script
# Usage: ./deploy.sh [--forwarding|--devcontainer|--letsencrypt|--step-ca] [--stack] [--ssl] [--keycloak] [--keycloak-network]

# Function to create keycloak network if needed
create_keycloak_network() {
    if ! docker network ls | grep -q "keycloak-network"; then
        echo "Creating keycloak-network..."
        docker network create keycloak-network
    fi
}

# Function to parse arguments
parse_args() {
    KEYCLOAK_ENABLED=false
    KEYCLOAK_NETWORK_ENABLED=false
    STACK_ENABLED=false
    SSL_ENABLED=false
    
    for arg in "$@"; do
        case $arg in
            --keycloak|-k)
                KEYCLOAK_ENABLED=true
                ;;
            --keycloak-network|-kn)
                KEYCLOAK_NETWORK_ENABLED=true
                ;;
            --stack)
                STACK_ENABLED=true
                ;;
            --ssl)
                SSL_ENABLED=true
                ;;
        esac
    done
}

# Function to build docker-compose command
build_compose_command() {
    local cert_mode=$1
    local compose_cmd="docker-compose"
    
    # Add base compose file
    compose_cmd="$compose_cmd -f docker-compose.yml"
    
    # Add stack compose file if enabled
    if [ "$STACK_ENABLED" = true ]; then
        compose_cmd="$compose_cmd -f docker-compose.stack.yml"
    fi
    
    # Add SSL compose file if enabled
    if [ "$SSL_ENABLED" = true ]; then
        compose_cmd="$compose_cmd -f docker-compose.ssl.yml"
    fi
    
    # Add keycloak compose file if enabled
    if [ "$KEYCLOAK_ENABLED" = true ]; then
        compose_cmd="$compose_cmd -f docker-compose.keycloak.yml"
        
        # Add keycloak network compose file if enabled
        if [ "$KEYCLOAK_NETWORK_ENABLED" = true ]; then
            compose_cmd="$compose_cmd -f docker-compose.keycloak-bridge.yml"
            compose_cmd="$compose_cmd --profile keycloak-network"
            create_keycloak_network
        fi
    fi
    
    # Add certificate mode specific compose file
    case $cert_mode in
        forwarding)
            compose_cmd="$compose_cmd -f docker-compose.forwarding.yml"
            ;;
        devcontainer)
            compose_cmd="$compose_cmd -f docker-compose.devcontainer.yml"
            ;;
        letsencrypt)
            compose_cmd="$compose_cmd -f docker-compose.letsencrypt.yml"
            ;;
        step-ca)
            compose_cmd="$compose_cmd -f docker-compose.step-ca.yml"
            ;;
    esac
    
    compose_cmd="$compose_cmd up -d"
    echo $compose_cmd
}

# Parse all arguments
parse_args "$@"

case "$1" in
    --forwarding|-f)
        cmd=$(build_compose_command "forwarding")
        eval $cmd
        ;;
    --devcontainer|-dc)
        cmd=$(build_compose_command "devcontainer")
        eval $cmd
        ;;
    --letsencrypt|-le)
        cmd=$(build_compose_command "letsencrypt")
        eval $cmd
        ;;
    --step-ca|-sc)
        cmd=$(build_compose_command "step-ca")
        eval $cmd
        ;;
    --help|-h|*)
        echo "Usage: $0 [--forwarding|--devcontainer|--letsencrypt|--step-ca] [--stack] [--ssl] [--keycloak] [--keycloak-network]"
        echo ""
        echo "Certificate Management Options:"
        echo "  --forwarding    Local development with port forwarding"
        echo "  --letsencrypt   Production with Let's Encrypt certificates"
        echo "  --step-ca       Virtual network with Step CA certificates"
        echo "  --devcontainer  DevContainer environment"
        echo ""
        echo "Integration Options:"
        echo "  --stack         Connect to elk-network for Elasticsearch integration"
        echo "  --ssl           Enable SSL configuration for Elasticsearch connection"
        echo "  --keycloak      Enable Keycloak OIDC integration"
        echo "  --keycloak-network  Enable external keycloak-network and bridge service"
        echo ""
        echo "Examples:"
        echo "  $0 --forwarding"
        echo "  $0 --forwarding --stack"
        echo "  $0 --forwarding --stack --ssl"
        echo "  $0 --forwarding --keycloak"
        echo "  $0 --forwarding --keycloak --keycloak-network"
        echo "  $0 --letsencrypt --stack --ssl --keycloak --keycloak-network"
        echo "  $0 --step-ca --stack --ssl"
        echo "  $0 --devcontainer"
        ;;
esac