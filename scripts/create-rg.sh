#!/bin/bash

set -e

RG=$1
LOCATION=$2

echo "Checking resource group: $RG"

az group show -n "$RG" >/dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "Creating resource group..."
  az group create \
    --name "$RG" \
    --location "$LOCATION"
else
  echo "Resource group already exists (idempotent)"
fi
