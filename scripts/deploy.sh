#!/bin/bash

set -e

RG=$1
CLUSTER=$2
LOCATION=$3
WORKERS=$4

echo "Deploying ARO cluster: $CLUSTER"

OUTPUT=$(az deployment group create \
  --resource-group "$RG" \
  --template-file bicep/main.bicep \
  --parameters \
    clusterName="$CLUSTER" \
    location="$LOCATION" \
    workerCount="$WORKERS" \
  --query "properties.outputs" \
  -o json)

echo "Deployment Outputs:"
echo "$OUTPUT"

echo "$OUTPUT" > aro-outputs.json
