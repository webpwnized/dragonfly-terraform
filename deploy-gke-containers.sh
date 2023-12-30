#!/bin/bash

# GET CREDENTIALS TO GKE SERVICE
gcloud container clusters get-credentials dragonfly-gke-cluster

# DEPLOY WORKLOADS
kubectl create deployment dragonfly-www --image=docker.io/webpwnized/dragonfly:www
kubectl expose deployment dragonfly-www --name=www --type=LoadBalancer --protocol=TCP --port=80 --target-port=80
