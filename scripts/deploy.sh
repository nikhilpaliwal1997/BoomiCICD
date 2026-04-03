#!/bin/bash

set -e

echo "Starting Boomi Deployment..."

echo "Step 1: Creating Package..."

PACKAGE_RESPONSE=$(curl -s -o response1.json -w "%{http_code}" -X POST "https://api.boomi.com/api/rest/v1/$BOOMI_ACCOUNT_ID/PackagedComponent" \
-u "$BOOMI_USERNAME:$BOOMI_PASSWORD" \
-H "Content-Type: application/json" \
-d '{
  "componentId": "'"$BOOMI_COMPONENT_ID"'",
  "notes": "CI/CD Deployment"
}')

echo "HTTP Status: $PACKAGE_RESPONSE"
cat response1.json

# ❌ Fail if not success
if [ "$PACKAGE_RESPONSE" -ne 200 ]; then
  echo "Package creation FAILED"
  exit 1
fi

# Extract packageId
PACKAGE_ID=$(grep -o '"packageId":"[^"]*' response1.json | cut -d'"' -f4)

echo "Package ID: $PACKAGE_ID"

echo "Step 2: Deploying Package..."

DEPLOY_RESPONSE=$(curl -s -o response2.json -w "%{http_code}" -X POST "https://api.boomi.com/api/rest/v1/$BOOMI_ACCOUNT_ID/DeployedPackage" \
-u "$BOOMI_USERNAME:$BOOMI_PASSWORD" \
-H "Content-Type: application/json" \
-d '{
  "packageId": "'"$PACKAGE_ID"'",
  "environmentId": "'"$BOOMI_ENVIRONMENT_ID"'",
  "notes": "Automated Deployment"
}')

echo "HTTP Status: $DEPLOY_RESPONSE"
cat response2.json

# ❌ Fail if deployment fails
if [ "$DEPLOY_RESPONSE" -ne 200 ]; then
  echo "Deployment FAILED"
  exit 1
fi

echo "Deployment SUCCESSFUL 🎉"
