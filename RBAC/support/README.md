# Support RBAC Configuration

This directory contains Kubernetes RBAC configuration for Support team access.

## Access Model

IAM Role → aws-auth → support-group → ClusterRoleBinding

## Permissions

Support team can:

- View nodes
- View pods
- View logs
- View deployments
- View HPA
- View events

Support team cannot:

- Delete resources
- Modify deployments
- Access secrets
- Execute into containers

## Apply

kubectl apply -f clusterrole.yaml
kubectl apply -f clusterrolebinding.yaml
