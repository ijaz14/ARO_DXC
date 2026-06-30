# Deployment Guide

## Create Cluster

Run pipeline:
- Action: create
- Cluster Name: aro-sandbox01

Wait ~30–45 minutes.

---

## Validate Cluster

Run:
- pipelines/validate.yml

---

## Get Access

Use output from pipeline:

```bash
oc login <api-url> -u kubeadmin -p <password>
