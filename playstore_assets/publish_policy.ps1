$acc = Invoke-RestMethod -Uri "https://api.telegra.ph/createAccount?short_name=CircuitPoint&author_name=CircuitPoint"
$token = $acc.result.access_token

$content = '[{"tag":"p","children":["Circuit Point is an offline electrical engineering reference and calculator tool. We do not collect, store, or share any personal user data. All calculation history and preferences remain strictly on your local device storage."]},{"tag":"p","children":["Contact: circuitpoint.app@gmail.com"]}]'

$body = @{
    access_token = $token
    title = "Privacy Policy - Circuit Point"
    author_name = "Circuit Point"
    content = $content
    return_content = $true
}

$page = Invoke-RestMethod -Uri "https://api.telegra.ph/createPage" -Method Post -Body $body
Write-Output "PAGE_URL:$($page.result.url)"
