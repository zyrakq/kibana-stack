# README

## ELK Setup with Basic Auth

First, create the `kibana_system` user:

```bash
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

```bash
curl --location \
--request PUT http://localhost:9200/_security/user/kibana_system/_password \
--header 'Content-Type: application/json' \
--header 'Accept: */*' \
--header 'Authorization: Basic base64(elastic:${ELASTIC_PASSWORD})' \
--data-raw '{
  "password" : "${KIBANA_PASSWORD}"
}'
```

```bash
./docker-prod.sh up # or bash -c docker-prod.sh
```

```bash
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

```
app_user:app_user_password
```

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
