<#
.SYNOPSIS
    Publica este repositorio de extensiones en GitHub.

.DESCRIPTION
    Crea el repositorio via API, configura el remoto y sube la rama main.

    El token se lee de la variable de entorno GITHUB_TOKEN: nunca se pasa como
    argumento (quedaria en el historial de PowerShell y en la lista de procesos)
    ni se escribe en disco. Durante el push se usa GIT_ASKPASS con un script
    temporal que lo imprime, y el remoto se deja sin usuario ni token.

.PARAMETER Owner
    Usuario u organizacion de GitHub.

.PARAMETER Repo
    Nombre del repositorio. Por defecto "blender-addons-repo".

.PARAMETER Private
    Crear el repositorio como privado. Recomendado: 15 de los 19 paquetes no
    incluyen su fichero LICENSE y se redistribuyen bajo GPL.

.EXAMPLE
    $env:GITHUB_TOKEN = "ghp_..."
    .\publish-github.ps1 -Owner miusuario -Private
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $Owner,
    [string] $Repo = 'blender-addons-repo',
    [string] $Description = 'Repo de extensiones para Blender 5.2 LTS (19 addons, GPL)',
    [switch] $Private
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not $env:GITHUB_TOKEN) { throw "Falta la variable de entorno GITHUB_TOKEN." }
if (-not (Test-Path (Join-Path $root '.git'))) { throw "No es un repositorio git: $root" }

# --- 1. Estado del repo ---------------------------------------------------
if (git status --porcelain) { Write-Warning "Hay cambios sin commitear; se subir tal cual." }

# --- 2. Crear el repositorio ----------------------------------------------
Write-Host "==> Creando $Owner/$Repo ..."
$headers = @{
    'Authorization'      = "Bearer $env:GITHUB_TOKEN"
    'Accept'             = 'application/vnd.github+json'
    'X-GitHub-Api-Version' = '2022-11-28'
    'User-Agent'         = 'blender-extensions-publisher'
}
$body = @{
    name        = $Repo
    description = $Description
    private     = [bool]$Private
    auto_init   = $false
} | ConvertTo-Json

try {
    Invoke-RestMethod -Uri 'https://api.github.com/user/repos' -Method Post `
        -Headers $headers -Body $body -ContentType 'application/json' | Out-Null
    Write-Host "    Creado como $(if ($Private) { 'privado' } else { 'publico' })."
} catch {
    $status = $_.Exception.Response.StatusCode.value__
    if ($status -eq 422) { Write-Host "    Ya existe (HTTP 422); se reutiliza." }
    else { throw "No se pudo crear (HTTP $status): $($_.Exception.Message)" }
}

# --- 3. Remoto -------------------------------------------------------------
$cleanUrl = "https://github.com/$Owner/$Repo.git"
if (git remote | Select-String -Quiet '^origin$') {
    git remote set-url origin $cleanUrl
} else {
    git remote add origin $cleanUrl
}

# --- 4. Autenticacion sin dejar el token en disco -------------------------
# El usuario va en la URL para que git solo pregunte por el password.
$askpass = Join-Path ([System.IO.Path]::GetTempPath()) ("askpass_{0}.cmd" -f [guid]::NewGuid())
Set-Content -Path $askpass -Value "@echo off`r`necho %GITHUB_TOKEN%" -Encoding ASCII
$env:GIT_ASKPASS = $askpass
$env:GIT_TERMINAL_PROMPT = '0'

git add -A
if (-not (git diff --cached --quiet)) { git commit -q -m 'Actualizacion de paquetes' }

try {
    Write-Host "==> Subiendo rama main ..."
    git -c "credential.helper=" push -u "https://x-access-token@github.com/$Owner/$Repo.git" main
    if ($LASTEXITCODE -ne 0) { throw "El push fallo (codigo $LASTEXITCODE)." }
} finally {
    Remove-Item $askpass -Force -ErrorAction SilentlyContinue
    Remove-Item Env:\GIT_ASKPASS -ErrorAction SilentlyContinue
    Remove-Item Env:\GIT_TERMINAL_PROMPT -ErrorAction SilentlyContinue
}

# --- 5. Instrucciones ------------------------------------------------------
$idx = "https://raw.githubusercontent.com/$Owner/$Repo/main/packages/index.json"
Write-Host ""
Write-Host "Listo: https://github.com/$Owner/$Repo"
Write-Host ""
Write-Host "Para registrarlo en Blender:"
Write-Host "  blender --command extension repo-remove mis_addons"
Write-Host "  blender --command extension repo-add mis_addons --name `"Mis Addons`" --url `"$idx`""
Write-Host ""
Write-Host "Comprueba que el indice es accesible:"
Write-Host "  Invoke-WebRequest `"$idx`" -Method Head | Select-Object StatusCode"
