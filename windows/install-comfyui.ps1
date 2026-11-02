# ═══════════════════════════════════════════════════════════
# install-comfyui.ps1 — Instalación de ComfyUI en Windows
# Autor: redark2 | Fecha: 2025-11-02
# Uso: powershell -ExecutionPolicy Bypass -File install-comfyui.ps1
# ═══════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

# Colores para consola
function Write-Info { param($msg) Write-Host "[✦] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[!] $msg" -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host "[✗] $msg" -ForegroundColor Red }

# ── Configurar paths ─────────────────────────────────────
$ComfyDir       = if ($env:COMFY_DIR) { $env:COMFY_DIR } else { "$env:USERPROFILE\ComfyUI" }
$ModelsData     = if ($env:MODELS_DATA) { $env:MODELS_DATA } else { "D:\ComfyUI-Models" }
$PythonPath     = if ($env:PYTHON)     { $env:PYTHON }     else { "python" }
$InstallDate    = Get-Date -Format "yyyy-MM-dd"

Write-Info "Instalando ComfyUI en Windows"
Write-Info "Directorio: $ComfyDir"
Write-Info "Modelos: $ModelsData"

# ── Verificar dependencias ───────────────────────────────
Write-Info "Verificando dependencias..."

# Python
try {
    $pythonVersion = & $PythonPath --version 2>&1
    Write-Info "Python encontrado: $pythonVersion"
} catch {
    Write-Error "Python no encontrado."
    Write-Host "`nInstala Python 3.10+ desde: https://www.python.org/downloads/" -ForegroundColor Cyan
    Write-Host "O usa: winget install Python.Python.3.12" -ForegroundColor Cyan
    Write-Host "`nDespues, re-ejecuta este script." -ForegroundColor Cyan
    exit 1
}

# Git
try {
    git --version | Out-Null
    Write-Info "Git encontrado"
} catch {
    Write-Error "Git no encontrado."
    Write-Host "Instala Git desde: https://git-scm.com/download/win" -ForegroundColor Cyan
    Write-Host "O usa: winget install Git.Git" -ForegroundColor Cyan
    exit 1
}

# ── Clonar ComfyUI ───────────────────────────────────────
if (Test-Path "$ComfyDir\.git") {
    Write-Warn "ComfyUI ya existe en $ComfyDir. Actualizando..."
    Set-Location $ComfyDir
    git pull
} else {
    Write-Info "Clonando ComfyUI..."
    git clone https://github.com/comfyanonymous/ComfyUI.git $ComfyDir
    Set-Location $ComfyDir
}

# ── Crear Virtualenv ─────────────────────────────────────
if (!(Test-Path "$ComfyDir\venv")) {
    Write-Info "Creando virtualenv..."
    python -m venv venv
} else {
    Write-Info "Virtualenv ya existe."
}

# Activar venv
& "$ComfyDir\venv\Scripts\Activate.ps1"
Write-Info "Virtualenv activado"

# ── Instalar dependencias Python ─────────────────────────
Write-Info "Instalando dependencias Python..."
pip install --upgrade pip setuptools wheel

# Verificar GPU NVIDIA
$nvidiaSmi = Get-Command nvidia-smi -ErrorAction SilentlyContinue
if ($nvidiaSmi) {
    Write-Info "GPU NVIDIA detectada — instalando PyTorch CUDA..."
    pip uninstall -y torch torchvision torchaudio torchsde comfy-kitchen comfy-aimdo 2>$null
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
} else {
    Write-Host "`n⚠ GPU NVIDIA no detectada." -ForegroundColor Yellow
    Write-Host "  Si tienes NVIDIA, verifica drivers:" -ForegroundColor Yellow
    Write-Host "    https://www.nvidia.com/download/index.aspx" -ForegroundColor Yellow
    Write-Host "  Instalando PyTorch CPU (más lento)." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Para GPU NVIDIA, instala CUDA 12.4+ y re-ejecuta." -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "¿Continuar con CPU? (s/n)"
    if ($continue -ne 's' -and $continue -ne 'S' -and $continue -ne '') {
        exit 0
    }
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
}

# Dependencias principales
Write-Info "Instalando requirements..."
pip install -r requirements.txt

# ── Instalar Custom Nodes ────────────────────────────────
$customNodesDir = "$ComfyDir\custom_nodes"
if (!(Test-Path $customNodesDir)) {
    New-Item -ItemType Directory -Path $customNodesDir | Out-Null
}

$nodes = @(
    @{ url="https://github.com/ljmkomik/academiasd.git"; dir="academiasd" },
    @{ url="https://github.com/chris-guo/everywhere.git"; dir="cg-use-everywhere" },
    @{ url="https://github.com/Fannovel16/controlnet_aux.git"; dir="comfyui_controlnet_aux" },
    @{ url="https://github.com/AlekPet/comfyui_custom_nodes_alekpet.git"; dir="comfyui_custom_nodes_alekpet" },
    @{ url="https://github.com/dobbinn/comfyui-custom-scripts.git"; dir="comfyui-custom-scripts" },
    @{ url="https://github.com/chrisism/ComfyUI-DeGrid.git"; dir="ComfyUI-DeGrid-main" },
    @{ url="https://github.com/Fannovel16/comfyui-easy-use.git"; dir="comfyui-easy-use" },
    @{ url="https://github.com/Gourhass/comfyui_essentials.git"; dir="comfyui_essentials" },
    @{ url="https://github.com/Fannovel16/comfyui-frame-interpolation.git"; dir="comfyui-frame-interpolation" },
    @{ url="https://github.com/city96/ComfyUI-GGUF.git"; dir="ComfyUI-GGUF" },
    @{ url="https://github.com/city96/comfyui-gguf-loader.git"; dir="comfyui-gguf-loader" },
    @{ url="https://github.com/ltdrdata/ComfyUI-Manager.git"; dir="ComfyUI-Manager" },
    @{ url="https://github.com/Fannovel16/comfyui-impact-pack.git"; dir="comfyui-impact-pack" },
    @{ url="https://github.com/ltdrdata/comfyui-impact-subpack.git"; dir="comfyui-impact-subpack" },
    @{ url="https://github.com/Jrop/ComfyUI-iTools.git"; dir="ComfyUI-iTools" },
    @{ url="https://github.com/kijai/ComfyUI-KJNodes.git"; dir="ComfyUI-KJNodes" },
    @{ url="https://github.com/Gourhass/comfyui_layerstyle.git"; dir="comfyui_layerstyle" },
    @{ url="https://github.com/Fannovel16/comfyui-logic.git"; dir="comfyui-logic" },
    @{ url="https://github.com/Lightricks/ComfyUI-LTXVideo.git"; dir="ComfyUI-LTXVideo" },
    @{ url="https://github.com/Gourhass/ComfyUI-MediaMixer.git"; dir="ComfyUI-MediaMixer" },
    @{ url="https://github.com/chrisgoringe/comfyui_memory_cleanup.git"; dir="comfyui_memory_cleanup" },
    @{ url="https://github.com/Fannovel16/comfyui-minimax-h3-turbo.git"; dir="comfyui-minimax-h3-turbo" },
    @{ url="https://github.com/lldoahh/ComfyUI_ModelLoaderSwitch.git"; dir="ComfyUI_ModelLoaderSwitch" },
    @{ url="https://github.com/Nkhn/comfyui-nkd-basic-tools.git"; dir="comfyui-nkd-basic-tools" },
    @{ url="https://github.com/Nkhn/comfyui-nkd-klein-tools.git"; dir="comfyui-nkd-klein-tools" },
    @{ url="https://github.com/Nkhn/comfyui-nkd-preview-tools.git"; dir="comfyui-nkd-preview-tools" },
    @{ url="https://github.com/Nkhn/comfyui-nkd-radial-menu.git"; dir="comfyui-nkd-radial-menu" },
    @{ url="https://github.com/Nkhn/comfyui-nkd-reroutes.git"; dir="comfyui-nkd-reroutes" },
    @{ url="https://github.com/Nkhn/comfyui-nkd-vfx-tools.git"; dir="comfyui-nkd-vfx-tools" },
    @{ url="https://github.com/chrisgoringe/comfyui_nvidia_rtx_nodes.git"; dir="comfyui_nvidia_rtx_nodes" },
    @{ url="https://github.com/Gourhass/ComfyUI-Pixaroma.git"; dir="ComfyUI-Pixaroma" },
    @{ url="https://github.com/Fannovel16/ComfyUI-Qwen-Image-2.1-Prompt-Enhancer.git"; dir="ComfyUI-Qwen-Image-2.1-Prompt-Enhancer-main" },
    @{ url="https://github.com/Fannovel16/comfyui_ryanonyheinside.git"; dir="comfyui_ryanonyheinside" },
    @{ url="https://github.com/Fannovel16/comfyui-spectrum-minimax-h3.git"; dir="comfyui-spectrum-minimax-h3" },
    @{ url="https://github.com/Fannovel16/Comfyui-Spectrum-Qwen2.1.git"; dir="Comfyui-Spectrum-Qwen2.1-main" },
    @{ url="https://github.com/Gourhass/comfyui-ultralytics-studio.git"; dir="comfyui-ultralytics-studio" },
    @{ url="https://github.com/Nuked88/ComfyUI-VFI-main.git"; dir="ComfyUI-VFI-main" },
    @{ url="https://github.com/Gourhass/comfyui-videohelpersuite.git"; dir="comfyui-videohelpersuite" },
    @{ url="https://github.com/Fannovel16/controlaltai-nodes.git"; dir="controlaltai-nodes" },
    @{ url="https://github.com/Fannovel16/foreach.git"; dir="foreach" },
    @{ url="https://github.com/city96/gguf.git"; dir="gguf" },
    @{ url="https://github.com/Gourhass/h3_direct_latent_head.git"; dir="h3_direct_latent_head" },
    @{ url="https://github.com/Gourhass/ltx25_smart_controls.git"; dir="ltx25_smart_controls" },
    @{ url="https://github.com/Gourhass/minimax-h3-audio-t8.git"; dir="minimax-h3-audio-t8" },
    @{ url="https://github.com/Gourhass/MiniMax-H3-LongVideos.git"; dir="MiniMax-H3-LongVideos" },
    @{ url="https://github.com/Fannovel16/nkd-sigmas-curve.git"; dir="nkd-sigmas-curve" },
    @{ url="https://github.com/lldoahh/RES4LYF.git"; dir="RES4LYF" },
    @{ url="https://github.com/Gourhass/rescalecfgadvanced.git"; dir="rescalecfgadvanced" },
    @{ url="https://github.com/rgthree/rgthree-comfy.git"; dir="rgthree-comfy" },
    @{ url="https://github.com/Gourhass/SaveImageWithMetaDataUniversal.git"; dir="SaveImageWithMetaDataUniversal" },
    @{ url="https://github.com/Gourhass/seedvr2_videoupscaler.git"; dir="seedvr2_videoupscaler" },
    @{ url="https://github.com/Gourhass/was-node-suite-comfyui.git"; dir="was-node-suite-comfyui" },
    @{ url="https://github.com/Gourhass/zhihui_nodes_comfyui.git"; dir="zhihui_nodes_comfyui" }
)

Write-Info "Instalando Custom Nodes ($($nodes.Count) paquetes)..."

foreach ($node in $nodes) {
    $nodePath = Join-Path $customNodesDir $node.dir
    if (Test-Path "$nodePath\.git") {
        Write-Host "  [✓] $($node.dir) - actualizando..." -ForegroundColor Yellow
        Set-Location $nodePath
        git pull
        Set-Location $ComfyDir
    } elseif (Test-Path $nodePath) {
        Write-Host "  [✓] $($node.dir) - ya existe" -ForegroundColor Gray
    } else {
        Write-Host "  [+] $($node.dir) - clonando..." -ForegroundColor Cyan
        git clone $node.url $nodePath
        Set-Location $nodePath
        if (Test-Path "requirements.txt") {
            pip install -r requirements.txt 2>$null
        }
        Set-Location $ComfyDir
    }
}

# ── Configurar directorio de modelos ─────────────────────
Write-Info "Configurando directorio de modelos..."

# Crear estructura
$modelStructure = @(
    "models\checkpoints",
    "models\loras",
    "models\vae",
    "models\embeddings",
    "models\unet",
    "models\safety_models"
)

foreach ($dir in $modelStructure) {
    $fullPath = Join-Path $ComfyDir $dir
    if (!(Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
    }
}

# Crear enlace simbólico a la carpeta de modelos
# En Windows 10/11 se necesita permisos de admin para symlink
Write-Host "`nCreando enlace simbólico para models..." -ForegroundColor Cyan
Write-Host "  $ComfyDir\models -> $ModelsData" -ForegroundColor Gray

# Intentar crear symlink (puede requerir permisos de admin)
$modelsLink = Join-Path $ComfyDir "models"
if (Test-Path $modelsLink) {
    Remove-Item $modelsLink -Recurse -Force 2>$null
}
New-Item -ItemType Junction -Path $modelsLink -Target $ModelsData -Force 2>$null

# Crear directorio de modelos si no existe
if (!(Test-Path $ModelsData)) {
    Write-Warn "$ModelsData no existe. Creando..."
    New-Item -ItemType Directory -Path $ModelsData -Force | Out-Null
    New-Item -ItemType Directory -Path "$ModelsData\models\checkpoints" -Force | Out-Null
    New-Item -ItemType Directory -Path "$ModelsData\models\loras" -Force | Out-Null
    New-Item -ItemType Directory -Path "$ModelsData\models\vae" -Force | Out-Null
    New-Item -ItemType Directory -Path "$ModelsData\models\embeddings" -Force | Out-Null
}

# ── Crear extras ─────────────────────────────────────────
Write-Info "Creando archivos de configuración..."

# extra_model_paths.yaml
$extraPath = Join-Path $ComfyDir "extra_model_paths.yaml"
@"
comfyui:
  base_path: $ModelsData
"@ | Out-File -FilePath $extraPath -Encoding utf8

# user/default
$userDir = Join-Path $ComfyDir "user\default"
if (!(Test-Path $userDir)) {
    New-Item -ItemType Directory -Path $userDir -Force | Out-Null
}

# ── Crear scripts de ayuda ───────────────────────────────

# Script para iniciar ComfyUI
$runScript = Join-Path $ComfyDir "run-comfyui.bat"
@"
@echo off
chcp 65001 >nul
echo ============================================================
echo   ComfyUI - Stable Diffusion Web Interface
echo ============================================================
echo.
echo   Acceso: http://localhost:8188
echo   GPU:    %COMFYUI_GPU_MODE%
echo.

cd /d "%~dp0"
call venv\Scripts\activate.bat

python main.py ^
    --listen 0.0.0.0 ^
    --port 8188 ^
    %COMFYUI_GPU_ARGS%

pause
"@ | Out-File -FilePath $runScript -Encoding utf8

# Script para instalar en otra PC
$cloneScript = Join-Path $env:USERPROFILE "ComfyUI-Windows-Setup.bat"
@"
@echo off
REM ═══════════════════════════════════════════════════════════
REM ComfyUI Windows Setup - Instalacion rapida
REM Autor: redark2 | Fecha: 2025-11-02
REM ═══════════════════════════════════════════════════════════
echo Instalando ComfyUI en Windows...
echo.

REM Verificar Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python no encontrado.
    echo Instala desde: https://www.python.org/downloads/
    echo O: winget install Python.Python.3.12
    pause
    exit /b 1
)

REM Verificar Git
git --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git no encontrado.
    echo Instala desde: https://git-scm.com/download/win
    echo O: winget install Git.Git
    pause
    exit /b 1
)

REM Clonar repositorio
set COMFY_DIR=%%USERPROFILE%%\ComfyUI
if exist "%%COMFY_DIR%%\.git" (
    echo Actualizando ComfyUI...
    cd /d "%%COMFY_DIR%%"
    git pull
) else (
    echo Clonando ComfyUI...
    git clone https://github.com/comfyanonymous/ComfyUI.git "%%COMFY_DIR%%"
)

cd /d "%%COMFY_DIR%%"

REM Virtualenv
if not exist "venv" python -m venv venv
call venv\Scripts\activate.bat

REM Dependencias
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt

echo.
echo [OK] ComfyUI instalado en %%COMFY_DIR%%
echo [OK] Ejecuta run-comfyui.bat para iniciar
echo.
pause
"@ | Out-File -FilePath $cloneScript -Encoding utf8

# ── Resumen ──────────────────────────────────────────────
echo ""
echo ============================================================
echo   ✓ ComfyUI instalado exitosamente!
echo ============================================================
echo.
echo   Instalacion:  $ComfyDir
echo   Modelo data:  $ModelsData
echo   Virtualenv:   $ComfyDir\venv\Scripts\activate.bat
echo   Acceso web:   http://localhost:8188
echo   Script inicio: $ComfyDir\run-comfyui.bat
echo.
echo   Para activar y ejecutar:
echo     cd $ComfyDir
echo     venv\Scripts\activate
echo     python main.py --listen 0.0.0.0 --port 8188 --gpu-only --highvram
echo.
echo   # Instalar modelos: descarga archivos .safetensors en:
echo   #   $ComfyDir\models\checkpoints\   (modelos principales)
echo   #   $ComfyDir\models\loras\         (LoRAs)
echo   #   $ComfyDir\models\vae\           (VAEs)
echo.
