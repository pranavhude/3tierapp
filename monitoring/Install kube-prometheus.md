**Install kube-prometheus-stack**

cd monitoring

kubectl apply -f namespace.yaml

-------------------------------------------------------------------------------------

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring \
  -f monitoring-values.yaml

------------------------------------------------------------------------------------

Wait until:

kubectl get pods -n monitoring

All pods Running.
----------------------------------------------------------------------------------------

kubectl apply -f grafana-ingress.yaml

kubectl get ingress -n monitoring

----------------------------------------------------------------------------------------

kubectl get secret monitoring-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode

get pw and login with id is "admin"


