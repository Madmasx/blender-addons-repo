<#
.SYNOPSIS
    Publica este repositorio de extensiones en GitHub por SSH.

.DESCRIPTION
    Configura el remoto y sube la rama main usando la clave SSH de
    ~/.ssh/id_ed25519. No necesita token ni variable de entorno.

    SSH no permite crear repositorios: el repo debe existir ya en GitHub
    (boton "New repository" en la web). Este script solo hace el push.

    Requisito previo: la clave publica de github-ssh-key.pub debe estar
    registrada en https://github.com/settings/keys

.PARAMETER Owner
    Usuario u organizacion de GitHub. Por defecto "Madmasx".

.PARAMETER Repo
    Nombre del repositorio. Por defecto "blender-addons-repo".

.EXAMPLE
    .\publish-github.ps1
    .\publish-github.ps1 -Owner Madmasx -Repo blender-addons
#>
[CmdletBinding()]
param(
    [string] $Owner = 'Madmasx',
    [string] $Repo = 'blender-addons-repo',
    [string] $Branch = 'main'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$keyFile = Join-Path $env:USERPROFILE '.ssh\id_ed25519'

if (-not (Test-Path (Join-Path $root '.git'))) { throw "No es un repositorio git: $root" }
if (-not (Test-Path $keyFile)) { throw "No existe la clave SSH: $keyFile" }

# --- 1. Autenticacion ------------------------------------------------------
$env:GIT_SSH_COMMAND = 'ssh -o IdentitiesOnly=yes -i "' + $keyFile + '"'
$remote = "git@github.com:$Owner/$Repo.git"

# Comprueba que la clave esta aceptada por GitHub antes de tocar nada.
Write-Host "==> Probando autenticacion SSH con GitHub ..."
$sshOut = & ssh -o IdentitiesOnly=yes -o BatchMode=yes -o StrictHostKeyChecking=accept-new `
    -i $keyFile -T git@github.com 2>&1
$sshOut | ForEach-Object { Write-Host "    $_" }

# GitHub responde con "Hi <user>!" y codigo 1 aunque la auth sea correcta.
if (($sshOut -join ' ') -match 'successfully authenticated') {
    Write-Host "    Autenticacion correcta."
} else {
    throw @"
La clave SSH no esta aceptada por GitHub.

  1. Abre https://github.com/settings/keys/new
  2. Title:  DESKTOP-N3E49D2
  3. Key:    pega el contenido de github-ssh-key.pub
  4. Pulsa "Add SSH key"
  5. Vuelve a ejecutar este script.
"@
}

# --- 2. Remoto -------------------------------------------------------------
if (git remote | Select-String -Quiet '^origin$') {
    git remote set-url origin $remote
} else {
    git remote add origin $remote
}
Write-Host "==> Remoto: $remote"

# --- 3. Commit y push ------------------------------------------------------
git add -A
if (-not (git diff --cached --quiet)) {
    git commit -q -m 'Actualizacion de paquetes'
    Write-Host "==> Commit creado."
}

Write-Host "==> Subiendo rama $Branch ..."
git push -u origin $Branch
if ($LASTEXITCODE -ne 0) { throw "El push fallo (codigo $LASTEXITCODE)." }

# --- 4. Instrucciones ------------------------------------------------------
$idx = "https://raw.githubusercontent.com/$Owner/$Repo/main/packages/index.json"
Write-Host ""
Write-Host "Listo: https://github.com/$Owner/$Repo"
Write-Host ""
Write-Host "Para registrarlo en Blender:"
Write-Host "  blender --command extension repo-remove mis_addons"
Write-Host "  blender --command extension repo-add mis_addons --name `"Mis Addons`" --url `"$idx`""
