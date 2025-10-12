# 1) See the exact model id registered by the server
$models = Invoke-RestMethod -Uri "http://localhost:8085/v1/models" -Method Get
$model  = $models.models[0]     # e.g. "distilgpt2" (or sometimes "distilbert/distilgpt2")

# 2) OpenAI Completions (works for GPT-2 style models)
$req = @{
  model       = $model
  prompt      = "Hello, my name is"
  max_tokens  = 32
  temperature = 0.8
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8085/openai/v1/completions" `
  -Method Post -ContentType "application/json" -Body $req | Format-List

$prompt = @"
System: You are concise.
User: Say hello in one short sentence.
Assistant:
"@

$req = @{ model = $model; prompt = $prompt; max_tokens = 32; temperature = 0.7 } | ConvertTo-Json
Invoke-RestMethod -Uri "http://localhost:8085/openai/v1/completions" -Method Post -ContentType "application/json" -Body $req
