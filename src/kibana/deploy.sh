#!/bin/bash

# Kibana Deployment Script
# Usage: ./deploy.sh [--forwarding|--letsencrypt|--step-ca]

case "$1" in
    --forwarding|-f)
        docker-compose -f docker-compose.yml -f docker-compose.forwarding.yml up -d --build
        ;;
    --letsencrypt|-le)
        docker-compose -f docker-compose.yml -f docker-compose.letsencrypt.yml up -d --build
        ;;
    --step-ca|-sc)
        docker-compose -f docker-compose.yml -f docker-compose.step-ca.yml up -d --build
        ;;
    --help|-h|*)
        echo "Usage: $0 [--forwarding|--letsencrypt|--step-ca]"
        echo ""
        echo "Certificate Management Options:"
        echo "  --forwarding    Local development with port forwarding"
        echo "  --letsencrypt   Production with Let's Encrypt certificates"
        echo "  --step-ca       Virtual network with Step CA certificates"
        echo ""
        echo "Examples:"
        echo "  $0 --forwarding"
        echo "  $0 --letsencrypt"
        echo "  $0 --step-ca"
        ;;
esac