#!/bin/bash

set -e

RG=$1
CLUSTER=$2

echo "Fetching kubeadmin credentials..."

PASSWORD=$(az aro list-credentials \
  --name "$CLUSTER" \
  --resource-group "$RG" \
  --query kubeadminPassword -o tsv)

USERNAME=$(az aro list-credentials \
  --name "$CLUSTER" \
  --resource-group "$RG" \
  --query kubeadminUsername -o tsv)

API=$(az aro show \
  --name "$CLUSTER" \
  --resource-group "$RG" \
  --query apiserverProfile.url -o tsv)

echo "Login command:"
echo "oc login $API -u $USERNAME -p $PASSWORD"
