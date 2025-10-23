# Pre-Deployment Checklist Script
# Run this on your local machine to verify everything is ready

Write-Host "🔍 Pre-Deployment Checklist" -ForegroundColor Cyan
Write-Host "================================`n" -ForegroundColor Cyan

$allChecksPass = $true

# Check 1: Git repository
Write-Host "1. Checking Git repository..." -NoNewline
if (Test-Path ".git") {
    Write-Host " ✅" -ForegroundColor Green
} else {
    Write-Host " ❌ Not a git repository" -ForegroundColor Red
    $allChecksPass = $false
}

# Check 2: Required files
Write-Host "2. Checking required files..." -NoNewline
$requiredFiles = @("Dockerfile", "docker-compose.yml", ".dockerignore", "Gemfile", "package.json")
$missingFiles = @()
foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        $missingFiles += $file
    }
}
if ($missingFiles.Count -eq 0) {
    Write-Host " ✅" -ForegroundColor Green
} else {
    Write-Host " ❌ Missing: $($missingFiles -join ', ')" -ForegroundColor Red
    $allChecksPass = $false
}

# Check 3: GitHub workflow
Write-Host "3. Checking GitHub workflow..." -NoNewline
if (Test-Path ".github\workflows\deploy.yml") {
    Write-Host " ✅" -ForegroundColor Green
} else {
    Write-Host " ❌ Missing deploy.yml" -ForegroundColor Red
    $allChecksPass = $false
}

# Check 4: Git remote
Write-Host "4. Checking Git remote..." -NoNewline
$gitRemote = git remote -v 2>$null
if ($gitRemote -match "github.com") {
    Write-Host " ✅" -ForegroundColor Green
    $repoUrl = (git remote get-url origin 2>$null)
    Write-Host "   Repository: $repoUrl" -ForegroundColor Gray
} else {
    Write-Host " ❌ No GitHub remote found" -ForegroundColor Red
    $allChecksPass = $false
}

# Check 5: Current branch
Write-Host "5. Checking current branch..." -NoNewline
$currentBranch = git branch --show-current 2>$null
if ($currentBranch -eq "main") {
    Write-Host " ✅ On main branch" -ForegroundColor Green
} else {
    Write-Host " ⚠️  On branch: $currentBranch (deployment triggers on 'main')" -ForegroundColor Yellow
}

# Check 6: Uncommitted changes
Write-Host "6. Checking for uncommitted changes..." -NoNewline
$gitStatus = git status --porcelain 2>$null
if ([string]::IsNullOrEmpty($gitStatus)) {
    Write-Host " ✅ No uncommitted changes" -ForegroundColor Green
} else {
    Write-Host " ⚠️  You have uncommitted changes" -ForegroundColor Yellow
    Write-Host "   Run 'git status' to see changes" -ForegroundColor Gray
}

# Check 7: SSH key exists
Write-Host "7. Checking SSH key..." -NoNewline
$sshKeyPath = "$env:USERPROFILE\.ssh\id_rsa"
if (Test-Path $sshKeyPath) {
    Write-Host " ✅ SSH key found" -ForegroundColor Green
} else {
    Write-Host " ⚠️  No SSH key found at $sshKeyPath" -ForegroundColor Yellow
    Write-Host "   Generate one with: ssh-keygen -t rsa -b 4096" -ForegroundColor Gray
}

Write-Host "`n================================" -ForegroundColor Cyan
Write-Host "Summary:`n" -ForegroundColor Cyan

if ($allChecksPass) {
    Write-Host "✅ All checks passed!" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Cyan
    Write-Host "1. Set up GitHub Secrets (see GITHUB_SECRETS.md)" -ForegroundColor White
    Write-Host "2. Prepare your server (run setup-server.sh on server)" -ForegroundColor White
    Write-Host "3. Push to main branch: git push origin main" -ForegroundColor White
} else {
    Write-Host "❌ Some checks failed. Please fix the issues above." -ForegroundColor Red
}

Write-Host "`n📚 Documentation:" -ForegroundColor Cyan
Write-Host "   • Full deployment guide: DEPLOYMENT.md" -ForegroundColor White
Write-Host "   • GitHub secrets setup: GITHUB_SECRETS.md" -ForegroundColor White
Write-Host "`n"

# Offer to show GitHub secrets checklist
Write-Host "Would you like to see the GitHub Secrets checklist? (Y/N)" -NoNewline -ForegroundColor Yellow
$response = Read-Host " "
if ($response -eq "Y" -or $response -eq "y") {
    Write-Host "`n📋 GitHub Secrets Required:" -ForegroundColor Cyan
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "1. SERVER_HOST       - Your server IP or domain" -ForegroundColor White
    Write-Host "2. SERVER_USER       - SSH username (e.g., ubuntu)" -ForegroundColor White
    Write-Host "3. SERVER_SSH_KEY    - Your private SSH key" -ForegroundColor White
    Write-Host "4. SERVER_PORT       - SSH port (usually 22)" -ForegroundColor White
    Write-Host "5. DEPLOY_PATH       - Deployment directory (e.g., /opt/chat-app)" -ForegroundColor White
    Write-Host "6. GHCR_TOKEN        - GitHub Personal Access Token" -ForegroundColor White
    Write-Host "`nSee GITHUB_SECRETS.md for detailed instructions`n" -ForegroundColor Gray
}

# Test server connection if SERVER_HOST is available
Write-Host "Would you like to test SSH connection to your server? (Y/N)" -NoNewline -ForegroundColor Yellow
$response = Read-Host " "
if ($response -eq "Y" -or $response -eq "y") {
    $serverHost = Read-Host "Enter SERVER_HOST (IP or domain)"
    $serverUser = Read-Host "Enter SERVER_USER (username)"
    $serverPort = Read-Host "Enter SERVER_PORT (press Enter for 22)"
    if ([string]::IsNullOrEmpty($serverPort)) { $serverPort = "22" }
    
    Write-Host "`nTesting SSH connection..." -ForegroundColor Cyan
    ssh -p $serverPort -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$serverUser@$serverHost" "echo 'Connection successful!'"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ SSH connection successful!" -ForegroundColor Green
    } else {
        Write-Host "❌ SSH connection failed. Check your credentials and firewall." -ForegroundColor Red
    }
}

Write-Host "`n🚀 Ready to deploy? Run: git push origin main`n" -ForegroundColor Green
