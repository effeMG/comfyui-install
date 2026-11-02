# CHANGELOG

## [Unreleased]

### Added
- `install-comfyui.sh` — Instalación completa de ComfyUI en Linux
- `install-llama-cpp.sh` — Compilación de llama.cpp con CUDA en Linux
- `install-comfyui.ps1` — Instalación de ComfyUI en Windows (PowerShell)
- `install-llama-cpp.ps1` — Compilación de llama.cpp con CUDA en Windows (PowerShell)
- `setup-services.sh` — Configurar servicios systemd (Linux)
- `windows/install-comfyui.ps1` — Script de instalación ComfyUI Windows
- `windows/install-llama-cpp.ps1` — Script de instalación llama.cpp Windows
- `INFORME-DETALLADO.md` — Informe técnico completo de las instalaciones
- `README.md` — Documentación principal del repositorio

### Features
- Detección automática de GPU NVIDIA para elegir PyTorch CUDA
- Instalación de 50+ custom nodes de ComfyUI
- Custom nodes deshabilitados listados para referencia
- Configuración de directorios de modelos con enlace simbólico
- Scripts de inicio para ambos entornos
- Archivos de servicio systemd para Linux
- Scripts `.bat` de inicio para Windows
- Soporte multi-plataforma (Linux/Windows)
