# Get the hostname (something like: distilgpt2-predictor-default.default.example.com)
$SERVICE_HOSTNAME = (kubectl -n default get inferenceservice distilgpt2 -o jsonpath='{.status.url}' | % { $_.Split("/")[-1] })

# Build a minimal OpenAI-compatible chat request
$body = @{
  model    = "distilgpt2"
  messages = @(
    @{ role = "system"; content = "You are concise." },
    @{ role = "user";   content = "Say hello in one short sentence." }
  )
  max_tokens = 32
  stream     = $false
} | ConvertTo-Json -Depth 5

# Send it through the ingress, with the correct Host header
Invoke-RestMethod -Uri "http://localhost:18080/openai/v1/chat/completions" `
  -Headers @{ "Host" = $SERVICE_HOSTNAME; "Content-Type" = "application/json" } `
  -Method Post -Body $body
