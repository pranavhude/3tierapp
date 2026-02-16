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

aws iam list-policies --query "Policies[?PolicyName=='AWSLoadBalancerControllerIAMPolicy']"


If empty → create it:


curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam\_policy.json


check policy if already exist

aws iam list-policies \
  --scope Local \
  --query "Policies[?PolicyName=='AWSLoadBalancerControllerIAMPolicy'].Arn" \
  --output text


aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam\_policy.json

--------------------------------------------------------------


**STEP 4 — Create IAM Service Account**

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



DO NOT use serviceAccount.create=false

helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=prod-eks --set region=ap-south-1 --set vpcId=vpc-03dacc851a5ef2970 --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller


-------------------------------------------------------------

**STEP 8 — Verify Controller**

kubectl get pods -n kube-system
