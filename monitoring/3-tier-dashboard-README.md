# 3-Tier Application Monitoring Dashboard

## Overview

This dashboard monitors a Kubernetes-based 3-tier application:

-   Frontend (UI Layer)
-   Backend (API Layer)
-   MongoDB (Database Layer)

It provides visibility into: - Pod Restarts - CPU Usage - Memory Usage -
Network Traffic - Application Stability

------------------------------------------------------------------------

## Step 1: Verify Monitoring Stack

kubectl get pods -n monitoring


Ensure Prometheus, Grafana, Alertmanager, kube-state-metrics, and
node-exporter are running.

------------------------------------------------------------------------

## Step 2: Access Grafana

Get ALB DNS:

kubectl get ingress -n monitoring

Retrieve admin password:

kubectl get secret monitoring-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode


Login: - Username: admin - Password: `<decoded-password>`{=html}

------------------------------------------------------------------------

## Step 3: Create Dashboard

Navigate to: Dashboards → New → New Dashboard → Add Visualization

Select Data Source: Prometheus

------------------------------------------------------------------------

## Step 4: Panel Queries

### Pod Restart (Stat Panel)

sum(increase(kube_pod_container_status_restarts_total{namespace="three-tier"}[5m])) by (pod)

### MongoDB Memory Usage

container_memory_usage_bytes{pod=~"mongodb.*", namespace="three-tier"}

------------------------------------------------------------------------

### Frontend CPU Usage

rate(container_cpu_usage_seconds_total{pod=~"frontend.*", namespace="three-tier"}[5m])

------------------------------------------------------------------------

### Network Receive

sum(rate(container_network_receive_bytes_total{namespace="three-tier"}[5m])) by (pod)

------------------------------------------------------------------------

### Network Transmit

sum(rate(container_network_transmit_bytes_total{namespace="three-tier"}[5m])) by (pod)

------------------------------------------------------------------------

### Backend CPU Usage

rate(container_cpu_usage_seconds_total{pod=~"backend.*", namespace="three-tier"}[5m])

------------------------------------------------------------------------

### Backend Memory Usage

container_memory_usage_bytes{pod=~"backend.*", namespace="three-tier"}

------------------------------------------------------------------------

## Step 5: Add Namespace Variable (Recommended)

Dashboard Settings → Variables → Add Variable

Name: namespace

Query:

label_values(kube_pod_info, namespace)

Replace hardcoded namespace with:

namespace="\$namespace"

------------------------------------------------------------------------

## Step 6: Export Dashboard

Dashboard → Settings → JSON Model → Export

Save as:

monitoring/dashboards/3-tier-dashboard.json

Commit to Git for version control.

