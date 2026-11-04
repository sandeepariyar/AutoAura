# Copy the local Qt Design Studio project into this repository and publish it.
[CmdletBinding()]
param(
    [string]$SourceDirectory = (Join-Path $env:USERPROFILE "Documents\projects\AutoAura\AutoAura"),
    [string]$CheckoutDirectory = (Join-Path $env:USERPROFILE "Documents\projects\AutoAura-Git")
)

$ErrorActionPreference = "Stop"
$repositoryUrl = "https://github.com/sandeepariyar/AutoAura.git"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git for Windows is required: https://git-scm.com/downloads/win"
}

if (-not (Test-Path -LiteralPath (Join-Path $SourceDirectory "CMakeLists.txt"))) {
    throw "CMakeLists.txt was not found in: $SourceDirectory. Pass -SourceDirectory with the correct source folder."
}

$SourceDirectory = (Resolve-Path -LiteralPath $SourceDirectory).Path
if (-not (Test-Path -LiteralPath $CheckoutDirectory)) {
    git clone $repositoryUrl $CheckoutDirectory
    if ($LASTEXITCODE -ne 0) { throw "Unable to clone the repository." }
}

if (-not (Test-Path -LiteralPath (Join-Path $CheckoutDirectory ".git"))) {
    throw "The checkout directory already exists but is not a Git repository: $CheckoutDirectory"
}

git -C $CheckoutDirectory pull --ff-only origin main
if ($LASTEXITCODE -ne 0) {
    throw "Unable to update the local checkout. Resolve local Git changes before continuing."
}

$excludedDirectories = @(
    ".git", ".qtcreator", ".qtc_clangd", ".vscode", ".idea",
    "CMakeFiles", "AutoAuraApp-Debug", "AutoAuraApp-Release"
)
$excludedNames = @(
    "CMakeCache.txt", "cmake_install.cmake", "Makefile",
    "compile_commands.json", "temp.qrc", ".env"
)
$excludedExtensions = @(
    ".qmlrc", ".exe", ".dll", ".a", ".so", ".dylib",
    ".lib", ".obj", ".o", ".pdb", ".qm", ".qmlc", ".jsc", ".pem", ".key"
)

$copied = 0
Get-ChildItem -LiteralPath $SourceDirectory -Recurse -File -Force | ForEach-Object {
    $relativePath = $_.FullName.Substring($SourceDirectory.TrimEnd("\").Length + 1)
    $parts = $relativePath -split "[\\/]"
    $skip = $false

    foreach ($part in $parts) {
        if ($part -in $excludedDirectories -or $part -match "^(build-|cmake-build-)") {
            $skip = $true
            break
        }
    }

    if ($_.Name -in $excludedNames -or
        $_.Extension.ToLowerInvariant() -in $excludedExtensions -or
        $_.Name -like "*.user*" -or
        $_.Name -like ".env.*" -or
        $_.Length -gt 100MB) {
        $skip = $true
    }

    if (-not $skip) {
        $target = Join-Path $CheckoutDirectory $relativePath
        $parent = Split-Path -Parent $target
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
        Copy-Item -LiteralPath $_.FullName -Destination $target -Force
        $copied++
    }
}

Write-Host "Copied $copied source files into $CheckoutDirectory"

git -C $CheckoutDirectory add --all
if ($LASTEXITCODE -ne 0) { throw "Git staging failed." }

git -C $CheckoutDirectory diff --cached --quiet
if ($LASTEXITCODE -eq 1) {
    git -C $CheckoutDirectory commit -m "Add AutoAura application source"
    if ($LASTEXITCODE -ne 0) { throw "Git commit failed. Check your Git user.name and user.email settings." }
} elseif ($LASTEXITCODE -ne 0) {
    throw "Unable to inspect staged Git changes."
} else {
    Write-Host "No changes to commit."
}

git -C $CheckoutDirectory push origin main
if ($LASTEXITCODE -ne 0) { throw "Git push failed. Check GitHub authentication and repository permissions." }

Write-Host "AutoAura source published to https://github.com/sandeepariyar/AutoAura"
