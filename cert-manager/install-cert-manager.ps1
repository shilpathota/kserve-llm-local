# Add Jetstack repo + install cert-manager CRDs & controllers
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Install into cert-manager namespace
helm upgrade --install cert-manager jetstack/cert-manager `
  --namespace cert-manager --create-namespace `
  --set crds.enabled=true

# Wait until cert-manager is ready
kubectl -n cert-manager rollout status deploy/cert-manager --timeout=120s
kubectl -n cert-manager rollout status deploy/cert-manager-webhook --timeout=120s
kubectl -n cert-manager rollout status deploy/cert-manager-cainjector --timeout=120s

# Verify (should show 3 pods Running)
kubectl -n cert-manager get pods -o wide
