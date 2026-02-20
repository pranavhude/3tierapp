# Support RBAC Configuration

This directory contains Kubernetes RBAC configuration for Support team access.

## Access Model

IAM Role → aws-auth → support-group → ClusterRoleBinding


Create policy:

aws iam create-policy \
  --policy-name SupportEKSAccessPolicy \
  --policy-document file://support-eks-policy.json
---------------------------------------------------


Create IAM User (AWS Side)

aws iam create-user --user-name support-user

-----------------------------------------------

Attach minimum required policy:

aws iam attach-user-policy \
  --user-name support-user \
  --policy-arn arn:aws:iam::<ACCOUNT_ID>:policy/SupportEKSAccessPolicy
-----------------------------------------------

Map IAM User to EKS (aws-auth)

Edit configmap:

kubectl edit configmap aws-auth -n kube-system

Add inside mapUsers:

mapUsers: |
  - userarn: arn:aws:iam::<ACCOUNT_ID>:user/support-user
    username: support-user
    groups:
      - support-group


----------------------------------------------

Apply RBAC

kubectl apply -f support-role.yaml
kubectl apply -f support-rolebinding.yaml

---------------------------------------------

Test Support User

Switch profile: aws-configure


aws eks update-kubeconfig \
  --region ap-south-1 \
  --name prod-eks \
  --profile support

Test allowed:

kubectl get pods -A
kubectl get nodes
kubectl get ingress -A
kubectl logs <pod>

Test restricted:

kubectl delete pod <pod>
kubectl create deployment test --image=nginx
kubectl exec -it <pod> -- bash
kubectl get secrets
