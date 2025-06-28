# README

## Deployment

```bash
docker-compose up --build -d
```

## Enabling External Access to Containers with SSL from Let's Encrypt

To make a container accessible from outside, you need to:
- add the `cert-network` network
- fill in `VIRTUAL_PORT` - the container port that requires external access
- fill in `VIRTUAL_HOST` - the domain on which the container will be accessible
- fill in `LETSENCRYPT_HOST` - the domain for which the certificate is issued
- fill in `LETSENCRYPT_EMAIL` - email for certificate request

Example:

```yml
  kibana:
    environment:
      VIRTUAL_PORT: 5601
      VIRTUAL_HOST: ${VIRTUAL_HOST}
      LETSENCRYPT_HOST: ${LETSENCRYPT_HOST}
      LETSENCRYPT_EMAIL: ${LETSENCRYPT_EMAIL}
    networks:
      - cert-network

networks:
  cert-network:
    name: cert-network
    external: true