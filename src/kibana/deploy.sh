#!/bin/bash

# Kibana Deployment Script
# Usage: ./deploy.sh [--forwarding|--devcontainer|--letsencrypt|--step-ca] [--stack]

# Check arguments
STACK_ARG=""

for arg in "$@"; do
    case $arg in
        --stack)
            STACK_ARG="-f docker-compose.stack.yml"
            ;;
    esac
done

case "$1" in
    --forwarding|-f)
        docker-compose -f docker-compose.yml $STACK_ARG -f docker-compose.forwarding.yml up -d
        ;;
    --devcontainer|-dc)
        docker-compose -f docker-compose.yml -f docker-compose.devcontainer.yml up -d
        ;;
    --letsencrypt|-le)
        docker-compose -f docker-compose.yml $STACK_ARG -f docker-compose.letsencrypt.yml up -d
        ;;
    --step-ca|-sc)
        docker-compose -f docker-compose.yml $STACK_ARG -f docker-compose.step-ca.yml up -d
        ;;
    --help|-h|*)
        echo "Usage: $0 [--forwarding|--devcontainer|--letsencrypt|--step-ca] [--stack]"
        echo ""
        echo "Certificate Management Options:"
        echo "  --forwarding    Local development with port forwarding"
        echo "  --letsencrypt   Production with Let's Encrypt certificates"
        echo "  --step-ca       Virtual network with Step CA certificates"
        echo "  --devcontainer  DevContainer environment"
        echo ""
        echo "Integration Options:"
        echo "  --stack         Connect to elk-network for Elasticsearch integration"
        echo ""
        echo "Examples:"
        echo "  $0 --forwarding"
        echo "  $0 --forwarding --stack"
        echo "  $0 --letsencrypt --stack"
        echo "  $0 --step-ca --stack"
        echo "  $0 --devcontainer"
        ;;
esac