# 1) Pull a known-good CA bundle from another KServe webhook (servingruntime is usually healthy)
$GOOD = kubectl get validatingwebhookconfiguration servingruntime.serving.kserve.io -o jsonpath='{.webhooks[0].clientConfig.caBundle}'

# 2) Replace the validator (index 0) bundle for the InferenceService webhook
@"
[
  { "op":"replace", "path":"/webhooks/0/clientConfig/caBundle", "value":"$GOOD" }
]
"@ | Out-File -Encoding UTF8 patch-validator-ca.json

kubectl patch validatingwebhookconfiguration inferenceservice.serving.kserve.io `
  --type=json --patch-file patch-validator-ca.json

# 3) Optional: nudge cert-manager injector and verify sizes
kubectl -n cert-manager rollout restart deploy/cert-manager-cainjector
Start-Sleep -Seconds 10
$vh = kubectl get validatingwebhookconfiguration inferenceservice.serving.kserve.io -o json | ConvertFrom-Json
$vh.webhooks | % { "$($_.name) len=" + (($_.clientConfig.caBundle) | Measure-Object -Character).Characters }
