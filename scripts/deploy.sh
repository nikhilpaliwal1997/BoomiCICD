#!/bin/bash

set -e

echo "Starting Boomi Deployment..."

# Create Packaged Component
curl -X POST "https://api.boomi.com/api/rest/v1/$BOOMI_ACCOUNT_ID/PackagedComponent" \
-u "$BOOMI_USERNAME:$BOOMI_PASSWORD" \
-H "Content-Type: application/json" \
-d '{
  "componentId": "'"$BOOMI_COMPONENT_ID"'",
  "notes": "CI/CD Deployment"
}'

# Deploy Package
curl -X POST "https://api.boomi.com/api/rest/v1/$BOOMI_ACCOUNT_ID/DeployedPackage" \
-u "$BOOMI_USERNAME:$BOOMI_PASSWORD" \
-H "Content-Type: application/json" \
-d '{
  "environmentId": "'"$BOOMI_ENVIRONMENT_ID"'",
  "notes": "Automated Deployment"
}'

echo "Deployment completed successfully!"
