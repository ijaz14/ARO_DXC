#!/bin/bash

set -e

echo "Logging into Azure..."

az login --service-principal \
  -u "$AZURE_CLIENT_ID" \
  -p "$AZURE_CLIENT_SECRET" \
  --tenant "$AZURE_TENANT_ID"

az account set --subscription "$AZURE_SUBSCRIPTION_ID"

echo "Login successful"
