if ((-Not (Test-Path "../open-task.sh")) -or (-Not (Test-Path "../close-task.sh"))) {
    Write-Error "open-task.sh and close-task.sh do not exist in the parent folder"
    exit 1
}

Write-Host -NoNewline "Clearing old git aliases if exists... "
git config --global --unset alias.open-task
git config --global --unset alias.close-task
Write-Host "DONE"

$install_dir = Read-Host -Prompt "Folder's absolute path for git aliases (If left blank `$Env:UserProfile\git_aliases)"
if ($install_dir -eq "") {
    $install_dir = "$Env:UserProfile\git_aliases"
}

Write-Host -NoNewline "Copying aliases in $install_dir ... "
[System.IO.Directory]::CreateDirectory($install_dir) | Out-Null
Copy-Item "../open-task.sh" -Destination "$install_dir"
Copy-Item "../close-task.sh" -Destination "$install_dir"
Write-Host "DONE"

Write-Host -NoNewline "Setting global aliases... "
$install_dir_bash = $install_dir -replace "C:", "/c" -replace "\\", "/"
git config --global alias.open-task "! $install_dir_bash/open-task.sh"
git config --global alias.close-task "! $install_dir_bash/close-task.sh"
Write-Host "DONE"

Write-Host "Installation complete"