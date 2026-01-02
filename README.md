# Static Website Deployment Pipeline

A complete DevOps pipeline for deploying static websites with automated testing, deployment, and rollback capabilities.

## 🎯 Features

- ✅ **Automated Testing**: HTML validation, link checking, and performance audits
- ✅ **CI/CD Pipeline**: GitHub Actions workflow for automated deployment
- ✅ **Multi-Platform Deployment**: Deploy to AWS S3 and Netlify
- ✅ **Rollback Support**: Easy rollback to previous versions
- ✅ **Infrastructure as Code**: Terraform configuration for AWS resources
- ✅ **Monitoring**: Performance monitoring with Lighthouse
- ✅ **Security**: Security headers and best practices

## 🏗️ Architecture
```bash
GitHub Repository
│
├── Push/PR triggers GitHub Actions
│
├── Testing Phase
│ ├── HTML Validation
│ ├── Link Checking
│ └── Performance Audit
│
├── Build Phase
│ └── Asset Optimization
│
└── Deploy Phase
├── AWS S3 + CloudFront
└── Netlify (Alternative)
```
## Prerequisites

- Node.js 18+
- AWS Account (for S3 deployment)
- GitHub Account
- Git

## Project Directory Structure
```bash
static-ci-cd-githubactions-pipeline/
│
├── src/
│   ├── index.html
│   ├── about.html
│   ├── styles/
│   │   └── style.css
│   ├── js/
│   │   └── app.js
│   └── assets/
│       └── images/
│
├── tests/
│   ├── html-test.js
│   └── screenshot-test.js
│
├── .github/
│   └── workflows/
│       ├── deploy.yml
│       └── test.yml
│
├── scripts/
│   ├── deploy.sh
│   └── rollback.sh
│
├── terraform/ (Optional for AWS)
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── netlify.toml (Netlify config)
├── .gitignore
├── package.json
└── README.md
```
Install dependencies
```bash
npm install
```
Run tests locally
```bash
npm test
```
Open website locally
```bash
open src/index.html
# or use a local server
npx serve src
```
## ⚙️ Configuration
GitHub Secrets Setup

Go to your repository Settings > Secrets and variables > Actions

Add the following secrets:

For AWS Deployment:

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

S3_BUCKET_NAME

CLOUDFRONT_DISTRIBUTION_ID (optional)

For Netlify Deployment:

NETLIFY_AUTH_TOKEN

NETLIFY_SITE_ID

## Environment Variables
```bash
S3_BUCKET=your-bucket-name
DEPLOY_ENV=development
```
## 📦 Deployment
Manual Deployment
```bash
# Make script executable
chmod +x scripts/deploy.sh

# Deploy to staging
DEPLOY_ENV=staging ./scripts/deploy.sh

# Deploy to production
DEPLOY_ENV=production ./scripts/deploy.sh
```
Automated Deployment (GitHub Actions)
```bash
The pipeline automatically deploys when:

1. Push to main branch → Production

2. Pull Request to main → Staging preview
