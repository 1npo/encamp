Write-Output "Downloading Bitwarden CLI..."
Invoke-RestMethod -OutFile bitwarden.zip -Uri "https://vault.bitwarden.com/download/?app=cli&platform=linux"

$install_dir = (Join-Path -Path $env:localAppData -ChildPath "\Programs\Bitwarden CLI\")

Write-Output "Creating folder for the Bitwarden CLI binary..."
New-Item -ItemType Directory -Path $install_dir -Force | Out-Null

Write-Output "Installing Bitwarden CLI..."
Expand-Archive -Path "bitwarden.zip" -DestinationPath $install_dir -Force

Write-Output "Installed 'bw' in $install_dir (don't forget to add this to your path!)"
