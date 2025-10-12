# Install CRDs first
helm upgrade --install kserve-crd oci://ghcr.io/kserve/charts/kserve-crd `
  --version v0.15.0 -n kserve --create-namespace

# Then install the controller with our values
helm upgrade --install kserve oci://ghcr.io/kserve/charts/kserve `
  --version v0.15.0 -n kserve `
  -f .\kserve\values-kserve.yaml

# Wait for controller manager to be healthy
kubectl -n kserve rollout status deploy/kserve-controller-manager --timeout=180s

# Basic health checks:
kubectl api-resources | findstr /i inferenceservice
kubectl -n kserve get svc,deploy,po
