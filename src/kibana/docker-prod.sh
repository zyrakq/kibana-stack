#!/bin/bash

docker-compose -f docker-compose.yml -f docker-compose.cert.yml up -d --build
