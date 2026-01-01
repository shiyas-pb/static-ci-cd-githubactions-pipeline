#!/bin/bash

# Rollback Script
set -e

echo "🔄 Initiating rollback..."

S3_BUCKET="${S3_BUCKET:-your-bucket-name}"
BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Create backup directory
mkdir -p $BACKUP_DIR

# Download current version for backup
echo "📦 Creating backup of current version..."
aws s3 sync s3://$S3_BUCKET $BACKUP_DIR/current-$TIMESTAMP

# List available backups
echo "📚 Available backups:"
ls -la $BACKUP_DIR/

# Restore from latest backup
LATEST_BACKUP=$(ls -td $BACKUP_DIR/*/ | head -1)
if [ -n "$LATEST_BACKUP" ]; then
    echo "🔄 Restoring from: $LATEST_BACKUP"
    aws s3 sync $LATEST_BACKUP s3://$S3_BUCKET --delete
    echo "✅ Rollback completed"
else
    echo "❌ No backups found"
    exit 1
fi
