#!/bin/bash

# Static Website Deployment Script
set -e  # Exit on error

echo "🚀 Starting deployment process..."

# Configuration
S3_BUCKET="${S3_BUCKET:-your-bucket-name}"
CLOUDFRONT_ID="${CLOUDFRONT_ID:-}"
DEPLOY_ENV="${DEPLOY_ENV:-staging}"
BUILD_ID="${GITHUB_RUN_NUMBER:-local-$(date +%s)}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Validate AWS credentials
validate_aws() {
    if ! command -v aws &> /dev/null; then
        log_error "AWS CLI not found"
        exit 1
    fi
    
    if ! aws sts get-caller-identity &> /dev/null; then
        log_error "AWS credentials not configured"
        exit 1
    fi
}

# Build step
build_site() {
    log_info "Building website..."
    
    # Create build directory
    mkdir -p build
    
    # Copy source files
    cp -r src/* build/
    
    # Inject build information
    sed -i "s/#\${GITHUB_RUN_NUMBER}/$BUILD_ID/g" build/index.html
    sed -i "s/\${GITHUB_SHA}/${GITHUB_SHA:-local}/g" build/index.html
    
    log_info "Build completed"
}

# Deploy to S3
deploy_to_s3() {
    log_info "Deploying to S3 bucket: $S3_BUCKET"
    
    # Sync with S3
    aws s3 sync ./build s3://$S3_BUCKET \
        --delete \
        --cache-control "max-age=3600,public" \
        --exclude "*.html" \
        --exclude "*.js" \
        --exclude "*.css"
    
    # Upload HTML files with different cache settings
    aws s3 sync ./build s3://$S3_BUCKET \
        --include "*.html" \
        --cache-control "max-age=300,public" \
        --content-type "text/html"
    
    # Upload CSS/JS files
    aws s3 sync ./build s3://$S3_BUCKET \
        --include "*.css" --include "*.js" \
        --cache-control "max-age=31536000,public" \
        --content-type "application/javascript"
    
    log_info "Deployment to S3 completed"
}

# Invalidate CloudFront cache
invalidate_cloudfront() {
    if [ -n "$CLOUDFRONT_ID" ]; then
        log_info "Invalidating CloudFront distribution: $CLOUDFRONT_ID"
        
        INVALIDATION_ID=$(aws cloudfront create-invalidation \
            --distribution-id $CLOUDFRONT_ID \
            --paths "/*" \
            --query 'Invalidation.Id' \
            --output text)
        
        log_info "CloudFront invalidation created: $INVALIDATION_ID"
    fi
}

# Health check
health_check() {
    local url="https://${S3_BUCKET}.s3.amazonaws.com/index.html"
    log_info "Performing health check on: $url"
    
    if curl -s -f "$url" > /dev/null; then
        log_info "Health check passed"
    else
        log_error "Health check failed"
        exit 1
    fi
}

# Main deployment flow
main() {
    log_info "Starting deployment (Environment: $DEPLOY_ENV, Build: $BUILD_ID)"
    
    # Run steps
    validate_aws
    build_site
    deploy_to_s3
    
    if [ "$DEPLOY_ENV" = "production" ]; then
        invalidate_cloudfront
    fi
    
    health_check
    
    log_info "✅ Deployment completed successfully!"
}

# Handle rollback on error
rollback() {
    log_error "Deployment failed, initiating rollback..."
    # Implement rollback logic here
    exit 1
}

# Set trap for errors
trap rollback ERR

# Run main function
main
