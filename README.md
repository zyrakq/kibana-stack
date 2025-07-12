# 📊 Kibana Stack

A Docker-based stack for log analysis and visualization using Elasticsearch and Kibana.

## 📦 Components

### 📈 [Elasticsearch](src/elasticsearch/README.md)

Distributed search and analytics engine for data storage and indexing.

### 📊 [Kibana](src/kibana/README.md)

Data visualization dashboard for Elasticsearch with interactive charts and reports.

### Certificate Management

### 🌐 [Let's Encrypt Manager](src/letsencrypt-manager/README.md)

Automatic SSL certificate generation and renewal using Let's Encrypt for production deployments with internet access.

### 🔒 [Step CA Manager](src/step-ca-manager/README.md)

Self-signed trusted certificate authority for virtual Docker networks without internet access. Automatically manages and distributes CA certificates within isolated environments.

## 🚀 Quick Start

Each component has its own README with detailed setup instructions. Choose the certificate management solution that fits your deployment scenario.

## 📄 License

This project is dual-licensed under:

- [Apache License 2.0](LICENSE-APACHE)
- [MIT License](LICENSE-MIT)
