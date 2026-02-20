:: INSTALL/SETUP AWS LOAD BALANCER ::

**Step 1: Verify Cluster**

aws eks list-clusters --region ap-south-1

aws eks update-kubeconfig --region ap-south-1 --name prod-eks

kubectl get nodes


-------------------------------------------------------------

**STEP 2 — Verify / Associate OIDC Provider**

Check OIDC URL:

aws eks describe-cluster --name prod-eks --region ap-south-1 --query "cluster.identity.oidc.issuer" --output text


Now associate (safe to run even if already associated):

eksctl utils associate-iam-oidc-provider --region ap-south-1 --cluster prod-eks --approve

--------------------------------------------------------------

**STEP 3 — Create IAM Policy**

Check:

aws iam list-policies \
  --scope Local \
  --query "Policies[?PolicyName=='AWSLoadBalancerControllerIAMPolicy'].Arn" \
  --output text

If this returns an ARN  Policy already exists → DO NOT create again If this returns empty

Then create it.

If empty → create it:

download policy

curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json



create policy

aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json


check policy if already exist

aws iam list-policies \
  --scope Local \
  --query "Policies[?PolicyName=='AWSLoadBalancerControllerIAMPolicy'].Arn" \
  --output text
--------------------------------------------------------------


**STEP 4 — Create IAM Service Account**

# Check if ServiceAccount already exists
kubectl get sa aws-load-balancer-controller -n kube-system

# Check if IAM role already exists
aws iam get-role --role-name AmazonEKSLoadBalancerControllerRole

# Delete it first:
kubectl delete sa aws-load-balancer-controller -n kube-system

eksctl create iamserviceaccount --cluster prod-eks --region ap-south-1 --namespace kube-system --name aws-load-balancer-controller --attach-policy-arn arn:aws:iam::322172729886:policy/AWSLoadBalancerControllerIAMPolicy --override-existing-serviceaccounts --approve


kubectl describe sa aws-load-balancer-controller -n kube-system

You MUST see:

eks.amazonaws.com/role-arn: arn:aws:iam::322172729886:role/...


-------------------------------------------------------------

**STEP 5 — Add Helm Repo**

helm repo add eks https://aws.github.io/eks-charts

helm repo update

-------------------------------------------------------------

**STEP 6 — Get VPC ID**

aws eks describe-cluster --name prod-eks --region ap-south-1 --query "cluster.resourcesVpcConfig.vpcId" --output text

-------------------------------------------------------------

**STEP 7 — Install AWS Load Balancer Controller (Correct Way)**

Since service account was created using eksctl,
you MUST use --set serviceAccount.create=false

VPC_ID=$(aws eks describe-cluster \
  --name prod-eks \
  --region ap-south-1 \
  --query "cluster.resourcesVpcConfig.vpcId" \
  --output text)

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=prod-eks \
  --set region=ap-south-1 \
  --set vpcId=$VPC_ID \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller

-------------------------------------------------------------

**STEP 8 — Verify Controller**

kubectl get pods -n kube-system

kubectl logs -n kube-system deployment/aws-load-balancer-controller | grep -i error

-------------------------------------------------------------

**step 9 Deploy Your Application (3-Tier)**

Apply namespace first:

cd Kubernetes-Manifests-files

kubectl apply -f namespace.yaml

Apply manifests:

cd Database
kubectl apply -f .

cd Backend
kubectl apply -f .

cd Frontend
kubectl apply -f .


Verify:

kubectl get pods -n three-tier


All should be Running.

--------------------------------------------------------------

**STEP 10 — Apply Ingress (ALB)**

Apply ingress:

kubectl apply -f ingress.yaml -n three-tier


Check:

kubectl get ingress -n three-tier


-------------------------------------------------------------

**STEP 11 — Validate ALB In AWS**

aws elbv2 describe-load-balancers --region ap-south-1

You should see new ALB.

Test Application

Open:

http://<ALB-DNS>


Frontend loads.

Test backend API path:

http://<ALB-DNS>/api/tasks
