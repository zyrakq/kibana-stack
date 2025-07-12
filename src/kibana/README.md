# 📊 Kibana Service

Docker-based Kibana deployment with security enabled.

## ✨ Features

- 🔒 Kibana with X-Pack security (configurable version)
- 🔑 Authentication with configurable password
- 🌍 Multiple environments (development, production, devcontainer)
- 🔐 SSL/TLS support via Let's Encrypt and Step CA integration
- 💾 Persistent data storage with Docker volumes

## ⚙️ Configuration

Create `.env` file from template:

```sh
cp .env.example .env
```

Configure variables:

```sh
# Required
KIBANA_VERSION=9.0.2
KIBANA_PASSWORD=your_secure_password

# Required for production
VIRTUAL_HOST=kibana.yourdomain.com
LETSENCRYPT_HOST=kibana.yourdomain.com
LETSENCRYPT_EMAIL=your-email@domain.com
```

## 🔐 ELK Setup with Basic Auth

First, create the `kibana_system` user:

```sh
curl --location \
--request PUT http://localhost:9200/_security/user/kibana_system \
--header 'Content-Type: application/json' \
--header 'Accept: */*' \
--header 'Authorization: Basic base64(elastic:${ELASTIC_PASSWORD})' \
--data-raw '{
  "password" : "${KIBANA_PASSWORD}",
  "roles" : [ "superuser", "kibana_system" ]
}'
```

Or change the password if it has already been created:

```sh
curl --location \
--request PUT http://localhost:9200/_security/user/kibana_system/_password \
--header 'Content-Type: application/json' \
--header 'Accept: */*' \
--header 'Authorization: Basic base64(elastic:${ELASTIC_PASSWORD})' \
--data-raw '{
  "password" : "${KIBANA_PASSWORD}"
}'
```

## 🚀 Deployment

```sh
# Local development with port forwarding
./deploy.sh --forwarding

# Local development with Elasticsearch integration
./deploy.sh --forwarding --stack

# Production with Let's Encrypt certificates
./deploy.sh --letsencrypt --ssl

# Virtual network with Step CA certificates
./deploy.sh --step-ca --ssl

# DevContainer environment
./deploy.sh --devcontainer

# Show help
./deploy.sh --help
```

## 🌍 Environment Details

### 🛠️ Forwarding (Local Development)

- **Ports:** 5601 exposed to host
- **Network:** `elk-network` (optional with --stack)
- **SSL:** Disabled

### 🔐 Let's Encrypt (Production)

- **Ports:** Internal only (proxied via nginx)
- **Network:** `letsencrypt-network` + `elk-network` (optional with --stack)
- **SSL:** Automatic Let's Encrypt certificates

### 🏢 Step CA (Virtual Network)

- **Ports:** Internal only (proxied via nginx)
- **Network:** `step-ca-network` + `elk-network` (optional with --stack)
- **SSL:** Step CA managed certificates

### 🐳 DevContainer

- **Network:** `kibana-stack-workspace-network`
- **Usage:** VS Code DevContainer development

## 🔗 Stack Integration

### Network Connection

Use `--stack` argument to connect Kibana to Elasticsearch via `elk-network`:

```sh
# Connect to Elasticsearch in the same Docker network (local development)
./deploy.sh --forwarding --stack
```

### SSL Configuration

Use `--ssl` argument to enable SSL configuration for Elasticsearch connection:

```sh
# Enable SSL for secure Elasticsearch connection (production environments)
./deploy.sh --letsencrypt --ssl
./deploy.sh --step-ca --ssl
```

**Notes:**

- DevContainer mode doesn't require `--stack` as it uses its own network
- `--ssl` is typically used for standalone SSL connections to external Elasticsearch
- `--stack` is for connecting to Elasticsearch in the same Docker network
- Both arguments are independent and serve different use cases

## � Configuration Integration Services

Create an application user for your services:

```sh
curl --location \
--request PUT http://localhost:9200/_security/user/app_user \
--header 'Content-Type: application/json' \
--header 'Accept: */*' \
--header 'Authorization: Basic base64(elastic:${ELASTIC_PASSWORD})' \
--data-raw '{
  "password" : "app_user_password",
  "roles" : [ "superuser", "kibana_system" ]
}'
```

Convert to base64:

```sh
app_user:app_user_password
```

## 📝 Application Integration

Example of adding configurations via *Serilog*:

```json
{
  "Serilog": {
    "WriteTo": [
      {
        "Name": "Elasticsearch",
        "Args": {
          "nodeUris": "http://localhost:9200",
          "indexFormat": "app-{0:yyyy.MM}",
          "connectionGlobalHeaders": "Authorization=Basic base64(login:password)"
        }
      }
    ]
  }
}
```

## 🔗 Integration

### Certificate Management

This service integrates with different certificate management stacks:

- **Let's Encrypt:** [`../letsencrypt-manager/README.md`](../letsencrypt-manager/README.md) - For production deployments with internet access using public SSL certificates
- **Step CA:** [`../step-ca-manager/README.md`](../step-ca-manager/README.md) - For virtual Docker networks without internet access using self-signed trusted certificate authority
