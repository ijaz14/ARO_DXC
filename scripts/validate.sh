#!/bin/bash

set -e

RG=$1
CLUSTER=$2

echo "Checking ARO provisioning state..."

STATE=$(az aro show \
  --name "$CLUSTER" \
  --resource-group "$RG" \
  --query "provisioningState" -o tsv)

echo "State: $STATE"

if [ "$STATE" != "Succeeded" ]; then
  echo "Cluster not ready"
  exit 1
fi

echo "Fetching endpoints..."

API=$(az aro show \
  --name "$CLUSTER" \
  --resource-group "$RG" \
  --query apiserverProfile.url -o tsv)

CONSOLE=$(az aro show \
  --name "$CLUSTER" \
  --resource-group "$RG" \
  --query consoleProfile.url -o tsv)

echo "API: $API"
echo "Console: $CONSOLE"
