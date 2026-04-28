# Dee Store - E-commerce Platform

A modern, fully containerized e-commerce application with automated CI/CD pipeline and AWS monitoring.

---

## 🚀 Project Overview

**Dee Store** is a complete online shopping platform developed with modern DevOps practices. It features:

- Containerized PHP + MySQL + Nginx application
- Separate Admin Panel
- Automated Build & Deploy using GitHub Actions
- Infrastructure as Code with Terraform
- Secure configuration with Ansible Vault
- Real-time monitoring with AWS CloudWatch

---

## 🛠 Technologies Used

| Category           | Technology                       |
| ------------------ | -------------------------------- |
| Backend            | PHP 8.3 + MySQL 8.0              |
| Web Server         | Nginx + Apache                   |
| Containerization   | Docker + Docker Compose          |
| IaC                | Terraform                        |
| Configuration      | Ansible + Ansible Vault          |
| CI/CD              | GitHub Actions                   |
| Cloud Provider     | AWS (EC2, CloudWatch, IAM)       |
| Container Registry | Docker Hub                       |
| Monitoring         | AWS CloudWatch + CloudWatch Logs |

---

## 🏗 Architecture

- **EC2 Instance** (Amazon Linux 2023, t3.medium)
- **Docker Services**:
  - `dee-store-app` (Main Website)
  - `dee-store-admin` (Admin Panel)
  - `mysql` (Database)
  - `nginx` (Reverse Proxy)
- **CI/CD Flow**: Code Push → Build Images → Push to Docker Hub → Ansible Deploy on EC2
- **Monitoring**: CloudWatch Logs & Metrics + Alarms

---

## 📋 Required GitHub Secrets

Go to **Repository Settings → Secrets and variables → Actions** and add these:

| Secret Name              | Description                             |
| ------------------------ | --------------------------------------- |
| `DOCKER_USERNAME`        | Your Docker Hub username                |
| `DOCKER_TOKEN`           | Docker Hub Access Token                 |
| `SSH_PRIVATE_KEY`        | Content of `dee-store-key.pem`          |
| `ANSIBLE_VAULT_PASSWORD` | Password used for Ansible Vault secrets |
| `AWS_ACCESS_KEY_ID`      | AWS access key ID                       |
| `AWS_SECRET_ACCESS_KEY`  | AWS secrest access key                  |

---

## 🚀 Deployment

### Automatic Deployment (Recommended)

First to create IAC run 'Infrastructure (AWS Infrastructure)'github pipeline and you will get public ip address. Provide that ip address to inventory.ini as ansible host.

after push your code to the `main` branch — everything happens automatically:

1. Build both images (`dee-store` and `dee-store-admin`)
2. Push to Docker Hub
3. Deploy to AWS EC2 using Ansible

### Manual Deployment

```bash
ANSIBLE_CONFIG=ansible/ansible.cfg ansible-playbook ansible/playbooks.yml \
-i ansible/inventory.ini \
--vault-password-file vault_pass.txt
```
