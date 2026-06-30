#!/bin/bash

set -e

RG=$1

echo "WARNING: Destroying entire sandbox resource group: $RG"

az group delete \
  --name "$RG" \
  --yes \
  --no-wait

echo "Delete initiated"
