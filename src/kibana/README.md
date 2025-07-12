# 📊 Kibana Stack

Docker-based Kibana deployment with flexible certificate management and authentication options.

## 🔧 Configuration

Copy the example environment file and configure your settings:

```sh
cp .env.example .env
```

Edit `.env` with your specific configuration:

- `KIBANA_PASSWORD` - Password for kibana_system user
- `VIRTUAL_HOST` - Domain name for your Kibana instance
- `LETSENCRYPT_EMAIL` - Email for Let's Encrypt certificates
- `STEP_CA_TRUST` - Enable Step CA certificate trust

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

## 🚀 Quick Start

Use the deployment script to start Kibana with your preferred certificate management:

```sh
# Local development with port forwarding
./deploy.sh --forwarding

# Production with Let's Encrypt certificates
./deploy.sh --letsencrypt

# Virtual network with Step CA certificates
./deploy.sh --step-ca
```

## 🔧 Configuration Integration Services

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

## 🌐 Certificate Management Options

### Port Forwarding (Development)

- Direct port access on localhost:5601
- No SSL certificates required
- Ideal for local development

### Let's Encrypt (Production)

- Automatic SSL certificate generation and renewal
- Requires internet access and valid domain
- Production-ready with trusted certificates

### Step CA (Virtual Networks)

- Self-signed certificate authority
- Works in isolated environments
- Automatic certificate distribution within Docker networks
