#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════
# install-comfyui.sh — Instalación completa de ComfyUI
# Autor: redark2 | Fecha: 2025-11-02
# Uso: bash install-comfyui.sh [/ruta/a/ComfyUI]
# ═══════════════════════════════════════════════════════════
set -euo pipefail

COMFY_DIR="${1:-$HOME/ComfyUI}"
COMFY_MODELS="$HOME/.local/share/ComfyUI/models"
INSTALL_DATE="$(date +%Y-%m-%d)"

# Colores
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "${GREEN}[✦] $*${NC}"; }
warn()  { echo -e "${YELLOW}[!] $*${NC}"; }
error() { echo -e "${RED}[✗] $*${NC}" >&2; }

# ── Verificar dependencias ───────────────────────────────
info "Verificando dependencias del sistema..."

# Python 3.10+
if ! command -v python3 &>/dev/null; then
    error "Python 3 no encontrado. Instala: sudo pacman -S python"
    exit 1
fi
python3_version=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
info "Python encontrado: $python3_version"

# pip
if ! command -v pip3 &>/dev/null; then
    error "pip3 no encontrado. Instala: sudo pacman -S python-pip"
    exit 1
fi

# CUDA/NVIDIA
if ! command -v nvidia-smi &>/dev/null; then
    warn "nvidia-smi no encontrado. Verifica drivers NVIDIA."
    warn "Para GPU NVIDIA, instala: sudo pacman -S nvidia nvidia-utils"
fi

# Git
if ! command -v git &>/dev/null; then
    error "Git no encontrado. Instala: sudo pacman -S git"
    exit 1
fi

# ── Clonar ComfyUI ──────────────────────────────────────
if [ -d "$COMFY_DIR/.git" ]; then
    warn "ComfyUI ya existe en $COMFY_DIR. Actualizando..."
    cd "$COMFY_DIR"
    git pull
else
    info "Clonando ComfyUI en $COMFY_DIR..."
    git clone https://github.com/comfyanonymous/ComfyUI.git "$COMFY_DIR"
    cd "$COMFY_DIR"
fi

# ── Crear Virtualenv ─────────────────────────────────────
if [ ! -d "venv" ]; then
    info "Creando virtualenv..."
    python3 -m venv venv
    source venv/bin/activate
else
    info "Virtualenv ya existe."
    source venv/bin/activate
fi

# ── Instalar dependencias Python ─────────────────────────
info "Instalando dependencias Python..."
pip install --upgrade pip setuptools wheel

# Detectar CUDA o usar CPU como fallback
if command -v nvidia-smi &>/dev/null; then
    info "GPU NVIDIA detectada — instalando PyTorch CUDA..."
    pip uninstall -y torch torchvision torchaudio torchsde \
        comfy-kitchen comfy-aimdo 2>/dev/null || true
    pip install torch torchvision torchaudio --index-url \
        https://download.pytorch.org/whl/cu124
else
    warn "Sin GPU NVIDIA detectada — instalando PyTorch CPU"
    pip install torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cpu
fi

# Dependencias principales
pip install -r requirements.txt

# ── Instalar Custom Nodes ────────────────────────────────
CUSTOM_NODES_DIR="$COMFY_DIR/custom_nodes"
mkdir -p "$CUSTOM_NODES_DIR"

install_node() {
    local url="$1"
    local dir="$2"
    local path="$CUSTOM_NODES_DIR/$dir"

    if [ -d "$path/.git" ]; then
        warn "  $dir ya existe. Actualizando..."
        cd "$path" && git pull && cd "$COMFY_DIR"
    elif [ -d "$path" ]; then
        warn "  $dir ya existe (sin git). Omitiendo."
    else
        info "  Clonando $dir..."
        git clone "$url" "$path"
        cd "$path" && python -m pip install -r requirements.txt 2>/dev/null || true
        cd "$COMFY_DIR"
    fi
}

info "Instalando Custom Nodes esenciales..."
cat <<'NODES' | while read -r url dir; do
    install_node "$url" "$dir"
done <<EOF
https://github.com/ljmkomik/academiasd.git academiasd
https://github.com/chris-guo/everywhere.git cg-use-everywhere
https://github.com/Fannovel16/controlnet_aux.git comfyui_controlnet_aux
https://github.com/AlekPet/comfyui_custom_nodes_alekpet.git comfyui_custom_nodes_alekpet
https://github.com/dobbinn/comfyui-custom-scripts.git comfyui-custom-scripts
https://github.com/chrisism/ComfyUI-DeGrid.git ComfyUI-DeGrid-main
https://github.com/Fannovel16/comfyui-easy-use.git comfyui-easy-use
https://github.com/Gourhass/comfyui_essentials.git comfyui_essentials
https://github.com/Fannovel16/comfyui-frame-interpolation.git comfyui-frame-interpolation
https://github.com/city96/ComfyUI-GGUF.git ComfyUI-GGUF
https://github.com/city96/comfyui-gguf-loader.git comfyui-gguf-loader
https://github.com/ltdrdata/ComfyUI-Manager.git ComfyUI-Manager
https://github.com/Fannovel16/comfyui-impact-pack.git comfyui-impact-pack
https://github.com/ltdrdata/comfyui-impact-subpack.git comfyui-impact-subpack
https://github.com/Jrop/ComfyUI-iTools.git ComfyUI-iTools
https://github.com/kijai/ComfyUI-KJNodes.git ComfyUI-KJNodes
https://github.com/Gourhass/comfyui_layerstyle.git comfyui_layerstyle
https://github.com/Fantacus-MC/comfyui-logic.git comfyui-logic
https://github.com/Lightricks/ComfyUI-LTXVideo.git ComfyUI-LTXVideo
https://github.com/Gourhass/ComfyUI-MediaMixer.git ComfyUI-MediaMixer
https://github.com/chrisgoringe/comfyui_memory_cleanup.git comfyui_memory_cleanup
https://github.com/Fannovel16/comfyui-minimax-h3-turbo.git comfyui-minimax-h3-turbo
https://github.com/lldoahh/ComfyUI_ModelLoaderSwitch.git ComfyUI_ModelLoaderSwitch
https://github.com/Nkhn/comfyui-nkd-basic-tools.git comfyui-nkd-basic-tools
https://github.com/Nkhn/comfyui-nkd-klein-tools.git comfyui-nkd-klein-tools
https://github.com/Nkhn/comfyui-nkd-preview-tools.git comfyui-nkd-preview-tools
https://github.com/Nkhn/comfyui-nkd-radial-menu.git comfyui-nkd-radial-menu
https://github.com/Nkhn/comfyui-nkd-reroutes.git comfyui-nkd-reroutes
https://github.com/Nkhn/comfyui-nkd-vfx-tools.git comfyui-nkd-vfx-tools
https://github.com/chrisgoringe/comfyui_nvidia_rtx_nodes.git comfyui_nvidia_rtx_nodes
https://github.com/Gourhass/ComfyUI-Pixaroma.git ComfyUI-Pixaroma
https://github.com/Fannovel16/ComfyUI-Qwen-Image-2.1-Prompt-Enhancer.git ComfyUI-Qwen-Image-2.1-Prompt-Enhancer-main
https://github.com/Fannovel16/comfyui_ryanonyheinside.git comfyui_ryanonyheinside
https://github.com/Fannovel16/comfyui-spectrum-minimax-h3.git comfyui-spectrum-minimax-h3
https://github.com/Fannovel16/Comfyui-Spectrum-Qwen2.1.git Comfyui-Spectrum-Qwen2.1-main
https://github.com/Gourhass/comfyui-ultralytics-studio.git comfyui-ultralytics-studio
https://github.com/Nuked88/ComfyUI-VFI-main.git ComfyUI-VFI-main
https://github.com/MrForExample/comfyui-videohelpersuite.git comfyui-videohelpersuite
https://github.com/Fannovel16/controlaltai-nodes.git controlaltai-nodes
https://github.com/Fannovel16/foreach.git foreach
https://github.com/city96/gguf.git gguf
https://github.com/Gourhass/h3_direct_latent_head.git h3_direct_latent_head
https://github.com/Gourhass/ltx25_smart_controls.git ltx25_smart_controls
https://github.com/Gourhass/minimax-h3-audio-t8.git minimax-h3-audio-t8
https://github.com/Gourhass/MiniMax-H3-LongVideos.git MiniMax-H3-LongVideos
https://github.com/Fannovel16/nkd-sigmas-curve.git nkd-sigmas-curve
https://github.com/lldoahh/RES4LYF.git RES4LYF
https://github.com/Gourhass/rescalecfgadvanced.git rescalecfgadvanced
https://github.com/rgthree/rgthree-comfy.git rgthree-comfy
https://github.com/Gourhass/SaveImageWithMetaDataUniversal.git SaveImageWithMetaDataUniversal
https://github.com/Gourhass/seedvr2_videoupscaler.git seedvr2_videoupscaler
https://github.com/Gourhass/was-node-suite-comfyui.git was-node-suite-comfyui
https://github.com/Gourhass/zhihui_nodes_comfyui.git zhihui_nodes_comfyui
EOF

# ── Configurar directorio de modelos ─────────────────────
if [ ! -d "$COMFY_MODELS" ]; then
    mkdir -p "$COMFY_MODELS"
fi

# Verificar /mnt/DataGame
if [ -d "/mnt/DataGame/ComfyUI-Models" ]; then
    # Verificar enlace simbólico
    if [ ! -L "$COMFY_DIR/models" ] || [ "$(readlink -f "$COMFY_DIR/models")" != "/mnt/DataGame/ComfyUI-Models" ]; then
        info "Creando enlace simbólico: models → /mnt/DataGame/ComfyUI-Models"
        mv -f "$COMFY_DIR/models" "$COMFY_DIR/models.bak" 2>/dev/null || true
        ln -sf "/mnt/DataGame/ComfyUI-Models" "$COMFY_DIR/models"
    fi
else
    warn "/mnt/DataGame/ComfyUI-Models no encontrado. Usando $COMFY_MODELS"
    ln -sf "$COMFY_MODELS" "$COMFY_DIR/models"
fi

# Crear estructura de modelos
info "Creando estructura de directorios de modelos..."
mkdir -p "$COMFY_DIR/models/checkpoints"
mkdir -p "$COMFY_DIR/models/loras"
mkdir -p "$COMFY_DIR/models/vae"
mkdir -p "$COMFY_DIR/models/embeddings"
mkdir -p "$COMFY_DIR/models/unet"
mkdir -p "$COMFY_DIR/models/safety_models"

# ── Configurar extra_model_paths ─────────────────────────
info "Configurando extra_model_paths.yaml..."
cat > "$COMFY_DIR/user/extra_model_paths.yaml" <<YAML
comfyui:
  base_path: /mnt/DataGame/ComfyUI-Models
  # is_speculative: true  # Descomentar para modelos de entrenamiento
  # checkpoints: models/checkpoints
  # loras: models/loras
  # vae: models/vae
  # embeddings: models/embeddings
  # controlnet: models/controlnet
  # clip: models/clip
  # unet: models/unet
  # clip_vision: models/clip_vision
  # hypernetworks: models/hypernetworks
  # photomaker: models/photomaker
  # instance_embedding: models/instance_embedding
  # class_embedding: models/class_embedding
  # upscale_models: models/upscale_models
  # gaussian_diffusion: models/gaussian_diffusion
  # adain: models/adain
  # attr_embedding: models/attr_embedding
  # motion_module: models/motion_module
  # resblock: models/resblock
  # attention_modules: models/attention_modules
  # textual_inversion: models/textual_inversion
  # lora_prefix_patterns:
  #   kohya: kyiv
YAML

# ── Crear configuración de usuario ───────────────────────
mkdir -p "$COMFY_DIR/user/default"

# ── Configurar servicio systemd ─────────────────────────
info "Configurando servicio systemd..."
CONFIG_DIR="$HOME/.config/com.github.johnfactist_minimaltoml.conf"
mkdir -p "$CONFIG_DIR"

cat > "$CONFIG_DIR/comfyui.service" <<SERVICE
[Unit]
Description=ComfyUI Stable Diffusion Web Interface
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$COMFY_DIR
ExecStart=$COMFY_DIR/venv/bin/python main.py \\
    --listen 0.0.0.0 \\
    --port 8188 \\
    --gpu-only \\
    --highvram
Restart=on-failure
RestartSec=5
Environment=PATH=$COMFY_DIR/venv/bin:/usr/bin:/bin
Environment=VIRTUAL_ENV=$COMFY_DIR/venv
Environment=LANG=es_ES.UTF-8
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
SERVICE

# ── Resumen ──────────────────────────────────────────────
echo ""
echo -e "${GREEN}═════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✓ ComfyUI instalado exitosamente!${NC}"
echo -e "${GREEN}═════════════════════════════════════════════════════════${NC}"
echo ""
echo "  Instalación:  $COMFY_DIR"
echo "  Modelo data:  /mnt/DataGame/ComfyUI-Models/"
echo "  Virtualenv:   $COMFY_DIR/venv/bin/activate"
echo "  Acceso web:   http://localhost:8188"
echo ""
echo -e "${CYAN}  Para activar y ejecutar:${NC}"
echo "    source $COMFY_DIR/venv/bin/activate"
echo "    cd $COMFY_DIR && python main.py --listen 0.0.0.0 --port 8188 --gpu-only --highvram"
echo ""
echo -e "${CYAN}  Para servicio automático:${NC}"
echo "    sudo ln -sf $CONFIG_DIR/comfyui.service /etc/systemd/system/"
echo "    sudo systemctl daemon-reload"
echo "    sudo systemctl enable --now comfyui.service"
echo ""
echo "  # Instalar modelos: descargue .safetensors en:"
echo "  #   $COMFY_DIR/models/checkpoints/   (modelos principales)"
echo "  #   $COMFY_DIR/models/loras/         (LoRAs)"
echo "  #   $COMFY_DIR/models/vae/           (VAEs)"
echo ""
