# ComfyUI Installation Guide

Instalación completa de **ComfyUI** con custom nodes, configuraciones de modelos y scripts de utilidad para **Linux y Windows**.

## 📁 Estructura del repositorio

```
├── README.md                    # Este archivo
├── INFORME-DETALLADO.md         # Informe técnico completo
├── CHANGELOG.md                 # Historial de cambios
├── .gitignore                   # Ignorar modelos pesados y binarios
├── linux/
│   └── install-comfyui.sh       # Script de instalación para Linux
├── windows/
│   └── install-comfyui.ps1      # Script de instalación para Windows
├── scripts/
│   ├── hermes-model-switch.py   # Script de cambio de modelo
│   └── llm.fish                 # Script de interacción LLM
└── models-reference/
    └── .gitkeep
```

## 🚀 Instalación rápida

### Linux
```bash
# Descargar y ejecutar
chmod +x linux/install-comfyui.sh
./linux/install-comfyui.sh
```

### Windows
```powershell
# Descargar y ejecutar
powershell -ExecutionPolicy Bypass -File windows/install-comfyui.ps1
```

## 📊 Lo que instala

- **ComfyUI** con 50+ custom nodes
- Configuración de directorios de modelos con enlace simbólico
- Scripts de inicio y servicio systemd (Linux)
- Dependencias Python completas
- Configuración para GPU NVIDIA con CUDA

## 📁 Modelos de ComfyUI

Los modelos se almacenan en `/mnt/DataGame/ComfyUI-Models/` (495 GB):

| Categoría | Archivos | Tamaño |
|-----------|----------|--------|
| Checkpoints | 32 | 46 GB |
| VAE | 10 | 176 MB |
| CLIP | 292 | 427 GB |
| LoRA | 202 | 8.2 GB |
| ControlNet | 11 | 2.2 GB |
| Embeddings | 105 | 363 MB |
| Upscale | 8 | 496 MB |
| Inspect | 8 | 3.8 GB |

## 🔧 Scripts de utilidad

- `scripts/hermes-model-switch.py` — Cambiar modelos Qwen
- `scripts/llm.fish` — Interacción con LLM via terminal
- `linux/install-comfyui.sh` — Instalación completa Linux
- `windows/install-comfyui.ps1` — Instalación completa Windows

## ⚙️ Servicios

Para Linux, ejecutar después de la instalación:
```bash
sudo bash linux/setup-services.sh
sudo systemctl start comfyui
sudo systemctl start comfyui-webui
```

## 📚 Referencias

- **ComfyUI:** https://github.com/comfyanonymous/ComfyUI
- **Modelos GGUF:** https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF

## 🔒 Seguridad

Este repositorio **nunca contiene modelos pesados** (solo scripts y configuración). Los modelos se almacenan externamente en `/mnt/DataGame/ComfyUI-Models/`.
