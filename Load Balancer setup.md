**Step 1: Verify Cluster**



aws eks list-clusters --region ap-south-1



aws eks update-kubeconfig --region ap-south-1 --name prod-eks



kubectl get nodes





-------------------------------------------------------------



**STEP 2 — Verify / Associate OIDC Provider**

Check OIDC URL:



aws eks describe-cluster \\

&nbsp; --name prod-eks \\

&nbsp; --region ap-south-1 \\

&nbsp; --query "cluster.identity.oidc.issuer" \\

&nbsp; --output text

Now associate (safe to run even if already associated):



eksctl utils associate-iam-oidc-provider \\

&nbsp; --region ap-south-1 \\

&nbsp; --cluster prod-eks \\

&nbsp; --approve

--------------------------------------------------------------




**STEP 3 — Create IAM Policy**

Check:



aws iam list-policies \\

&nbsp; --query "Policies\[?PolicyName=='AWSLoadBalancerControllerIAMPolicy']"

If empty → create it:



curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam\_policy.json


aws iam create-policy \\

&nbsp; --policy-name AWSLoadBalancerControllerIAMPolicy \\

&nbsp; --policy-document file://iam\_policy.json


--------------------------------------------------------------


**STEP 4 — Create IAM Service Account**

eksctl create iamserviceaccount \\

&nbsp; --cluster prod-eks \\

&nbsp; --region ap-south-1 \\

&nbsp; --namespace kube-system \\

&nbsp; --name aws-load-balancer-controller \\

&nbsp; --attach-policy-arn arn:aws:iam::322172729886:policy/AWSLoadBalancerControllerIAMPolicy \\

&nbsp; --override-existing-serviceaccounts \\

&nbsp; --approve

kubectl describe sa aws-load-balancer-controller -n kube-system

You MUST see:



eks.amazonaws.com/role-arn: arn:aws:iam::322172729886:role/...


-------------------------------------------------------------



**STEP 5 — Add Helm Repo**

helm repo add eks https://aws.github.io/eks-charts

helm repo update


-------------------------------------------------------------

**STEP 6 — Get VPC ID**

aws eks describe-cluster \\

&nbsp; --name prod-eks \\

&nbsp; --region ap-south-1 \\

&nbsp; --query "cluster.resourcesVpcConfig.vpcId" \\

&nbsp; --output text


-------------------------------------------------------------

**STEP 7 — Install AWS Load Balancer Controller (Correct Way)**



&nbsp;DO NOT use serviceAccount.create=false

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \\

&nbsp; -n kube-system \\

&nbsp; --set clusterName=prod-eks \\

&nbsp; --set region=ap-south-1 \\

&nbsp; --set vpcId=vpc-03dacc851a5ef2970
  --set serviceAccount.create=false \\

&nbsp; --set serviceAccount.name=aws-load-balancer-controller


-------------------------------------------------------------

**STEP 8 — Verify Controller**

kubectl get pods -n kube-system










