kubectl -n default create secret generic hf-token `
  --from-literal=token=hf_****************************

kubectl apply -f .\models\isvc-distilgpt2.yaml
kubectl -n default wait --for=condition=Ready inferenceservice/distilgpt2 --timeout=10m
