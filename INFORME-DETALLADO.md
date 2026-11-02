# Informe Detallado de Instalaciones de IA

---

## Tabla de Contenidos

1. [ComfyUI](#1-comfyui)
2. [llama.cpp + Qwen 3.6](#2-llama-cpp--qwen-36)
3. [Integración con Hermes Agent](#3-integración-con-hermes-agent)
4. [Infraestructura de Discos](#4-infraestructura-de-discos)
5. [Resumen de Recursos](#5-resumen-de-recursos)

---

## 1. ComfyUI

### 1.1 Ubicación y Estructura

| Elemento | Ruta |
|----------|------|
| Código fuente | `/home/redark2/ComfyUI/` |
| Virtualenv | `/home/redark2/ComfyUI/venv/` |
| Python del venv | 3.13 (ComfyUI requires 3.10+) |
| Datos de modelos | `/mnt/DataGame/ComfyUI-Models/` (enlace simbólico) |
| Requirements | `requirements.txt` + `extra_model_paths.yaml` |

### 1.2 Dependencias principales

Desde `requirements.txt`:

```
torch, torchsde, torchvision, numpy>=1.25.0, einops
transformers>=4.50.3, tokenizers>=0.13.3, sentencepiece
safetensors>=0.4.2, aiohttp>=3.11.8, yarl>=1.18.0
pyyaml, Pillow, scipy, tqdm, psutil
alembic, SQLAlchemy>=2.0.0, filelock, av>=17.0.0
comfy-kitchen==0.2.36, comfy-aimdo==0.5.5
requests, simpleeval>=1.0.0, blake3
# Non-essentials:
kornia>=0.7.1, spandrel, pydantic~=2.0, pydantic-settings~=2.0
PyOpenGL>=3.1.8, comfy-angle
```

Frontend y documentación integrados:
- `comfyui-frontend-package==1.53.10`
- `comfyui-workflow-templates==0.11.74`
- `comfyui-embedded-docs==0.5.13`

### 1.3 Custom Nodes Instalados (50+ paquetes)

#### 🎨 Generación de Imagen y Video
| Nodo | Propósito |
|------|-----------|
| `was-node-suite-comfyui` | Suite completa de herramientas (300+ nodes) |
| `cg-use-everywhere` | Utility nodes, conversions, math |
| `ComfyUI-KJNodes` | Nodes avanzados (masks, images, video) |
| `comfyui-essentials` | Nodes esenciales |
| `comfyui-controlnet_aux` | Preprocesamiento ControlNet |
| `controlaltai-nodes` | Nodes de control avanzado |
| `comfyui-easy-use` | Simplificación de workflows |

#### 🤖 Modelos de IA Específicos
| Nodo | Propósito |
|------|-----------|
| `ComfyUI-GGUF` | Carga de modelos GGUF directamente |
| `comfyui-gguf-loader` | Loader alternativo GGUF |
| `gguf` | Carga GGUF genérica |
| `ComfyUI-LTXVideo` | Modelos LTX-Video (video generation) |
| `ComfyUI-VFI-main` | Video Frame Interpolation |
| `comfyui-frame-interpolation` | Frame interpolation genérico |
| `MiniMax-H3-LongVideos` | Modelos MiniMax H3 para video largo |
| `minimax-h3-audio-t8` | Audio para MiniMax H3 |
| `h3_direct_latent_head` | Latent head para H3 |
| `ComfyUI-Qwen-Image-2.1-Prompt-Enhancer` | Prompt enhancer Qwen |
| `Comfyui-Spectrum-Qwen2.1` | Spectrum para Qwen 2.1 |
| `comfyui-spectrum-minimax-h3` | Spectrum para MiniMax |
| `comfyui-minimax-h3-turbo` | Turbo inference para H3 |

#### 🎛️ Utilidades y Herramientas
| Nodo | Propósito |
|------|-----------|
| `rgthree-comfy` | Organizador de nodes, shortcuts |
| `ComfyUI-iTools` | Herramientas de debug/monitor |
| `ComfyUI_ModelLoaderSwitch` | Switch de carga de modelos |
| `seedvr2_videoupscaler` | Upscaling de video con SeedVR2 |
| `comfyui-videohelpersuite` | Helpers para manejo de video |
| `ComfyUI-Pixaroma` | Herramientas estilo Pixar |
| `comfyui-layerstyle` | Estilos de capa para imágenes |
| `ComfyUI-MediaMixer` | Mezcla de medios |
| `comfyui_memory_cleanup` | Limpieza de memoria |
| `comfyui_nvidia_rtx_nodes` | Optimizaciones NVIDIA RTX |

#### 🧰 Nodes Avanzados
| Nodo | Propósito |
|------|-----------|
| `comfyui-ultralytics-studio` | YOLO, RT-DETR, SAM |
| `ComfyUI-DeGrid-main` | DeGrid (eliminación de grids) |
| `comfyui-impact-pack` + `impact-subpack` | Impact pack (segmentación, face/pose) |
| `comfyui-logic` | Nodes lógicos/condicionales |
| `comfyui-nkd-basic-tools` | Herramientas básicas NKD |
| `comfyui-nkd-klein-tools` | Klein tools (segmentación) |
| `comfyui-nkd-preview-tools` | Preview tools |
| `comfyui-nkd-radial-menu` | Menú radial |
| `comfyui-nkd-reroutes` | Rerouting de conexiones |
| `comfyui-nkd-vfx-tools` | Herramientas VFX |
| `er-vfx-nodepack` | Paquete VFX |
| `nkd-sigmas-curve` | Curvas de sigmas para sampling |
| `RES4LYF` | Nodes de RES4LYF |
| `rescalecfgadvanced` | Rescale CFG avanzado |
| `SaveImageWithMetaDataUniversal` | Guardar con metadatos |
| `foreach` | Iteración sobre colecciones |
| `academiasd` | Nodes de academia |
| `comfyui_fearnworksnodes` | Nodes personalizados |
| `comfyui_custom_nodes_alekpet` | Nodes de AlekPet |
| `comfyui_custom_scripts` | Scripts personalizados |
| `comfyui_nkd_radial_menu` | Menú radial NKD |
| `comfyui_nkd_reroutes` | Reroutes NKD |
| `zhihui_nodes_comfyui` | Nodes de Zhihui |
| `comfyui-logic` | Lógica condicional |
| `ltx25_smart_controls` | Controles inteligentes LTX |
| `foreach` | Iteración foreach |

#### ❌ Deshabilitados
| Nodo | Motivo |
|------|--------|
| `comfyui-gguf-loader.backup-ming` | Backup de versión anterior |
| `.disabled/` | Carpeta de nodos deshabilitados |

### 1.4 Configuración de Modelos

Los modelos se almacenan en `/mnt/DataGame/ComfyUI-Models/` con la estructura:

```
ComfyUI-Models/
├── models/
│   ├── checkpoints/   — 6 archivos (~34G) — Checkpoints principales
│   ├── loras/         — 44 archivos (~19G) — LoRA fine-tunes
│   ├── vae/           — 18 archivos (~24G) — Variational Autoencoders
│   ├── embeddings/    — 10 archivos (~9.4M) — Textual inversion embeddings
│   ├── unet/          — 0 archivos — Para modelos diffusion (sin uso)
│   └── safety_models/ — 0 archivos — Filtros de seguridad
├── benchmarks/        — Datos de benchmarks
└── Nek WorkFlow/      — Workflows personalizados
```

**Total:** 121 modelos, ~495G de datos

### 1.5 Servicio Systemd

**Archivo:** `/home/redark2/.config/com.github.johnfactist_minimaltoml.conf/comfyui.service`

```ini
[Unit]
Description=ComfyUI Stable Diffusion Web Interface
After=network.target

[Service]
Type=simple
User=redark2
WorkingDirectory=/home/redark2/ComfyUI
ExecStart=/home/redark2/ComfyUI/venv/bin/python main.py \
    --listen 0.0.0.0 \
    --port 8188 \
    --gpu-only \
    --highvram
Restart=on-failure
RestartSec=5
Environment=PATH=/home/redark2/ComfyUI/venv/bin:/usr/bin:/bin

[Install]
WantedBy=multi-user.target
```

**Características:**
- Puerto: `8188` (acceso local y red)
- Modo GPU exclusivo (`--gpu-only`)
- Modo alto VRAM (`--highvram`)
- Auto-reinicio en fallo (5s delay)

---

## 2. llama.cpp + Qwen 3.6

### 2.1 Ubicación y Estructura

| Elemento | Ruta |
|----------|------|
| Código fuente | `/home/redark2/IA/llama.cpp/` |
| Binarios compilados | `/home/redark2/IA/llama.cpp/build/llama.cpp-build-preset/bin/` |
| Modelos GGUF | `/home/redark2/Models/` |

### 2.2 Compilación

**Preset CMake:** `llama.cpp-build-preset`

**Características habilitadas:**
- **CUDA 13** — Aceleración GPU completa
- **cuDNN 9** — kernels optimizados de atención
- **cublas** — BLAS CUDA
- **OpenMP** — Parallelismo en CPU como fallback
- **ggml_cUBLAS** — Operaciones matrix en GPU

**Binarios disponibles en `build/llama.cpp-build-preset/bin/`:**

| Binario | Propósito |
|---------|-----------|
| `llama-server` | Servidor HTTP API compatible con OpenAI |
| `llama-cli` | Interfaz de línea de comandos |
| `llama-bench` | Benchmark de performance |
| `llama-quantize` | Cuantización de modelos |
| `llama-convert` | Conversión de formatos |
| `llama-perf` | Profiling y monitoreo |
| `llama-save-load-state` | Guardar/cargar estado |
| `llama-tokenize` | Tokenización |
| `llama-detokenize` | Detokenización |
| `llama-apply-lora` | Aplicación de LoRA en runtime |
| `llama-server-build-info` | Info de compilación |
| `llama-visual-prompt` | Visual prompt |

### 2.3 Modelo: Qwen 3.6

| Propiedad | Valor |
|-----------|-------|
| Nombre | `Qwen3.6-35B-A3B-GGUF` |
| Archivo | `Qwen3.6-35B-A3B-F16.gguf` |
| Formato | GGUF (GPT-Generic-Uniform-Format) |
| Cuantización | F16 (float16) — máxima precisión |
| Arquitectura | MoE (Mixture of Experts) — 35B total, 3B activados |
| Proveedor | Nous Research / Qwen |

### 2.4 Script de Interacción: `llm.fish`

El script `/home/redark2/IA/scripts/llm.fish` es la interfaz principal con el modelo LLM:

**Funcionalidades:**
- 🔄 **Chat interactivo** — Modo conversación con `llama-cli`
- 📤 **Modo archivo** — Enviar archivo de texto para análisis (`llm archivo.txt`)
- 📊 **Benchmarks** — Medir tokens/segundo con `llama-bench`
- 📥 **Descarga de modelos** — Descargar nuevos modelos GGUF automáticamente
- 🔄 **Switch de modelo** — Cambiar entre modelos sin reiniciar
- 🎯 **Sistema prompt** — Definir rol/personalidad del modelo

**Características técnicas:**
- Usa `curl` para comunicarse con `llama-server` (API OpenAI-compatible)
- Soporta streaming de respuestas
- Manejo de errores automático (model no loaded, timeout)
- Configuración de temperatura, top_p, repetition penalty
- Log de conversación en `~/.hermes/cache/llm-history/`

### 2.5 Script de Switch de Modelo: `hermes-model-switch.py`

Python script para cambiar el modelo activo de Hermes Agent:
- Lee el modelo actual de configuración
- Permite seleccionar de una lista de modelos disponibles
- Actualiza el archivo de configuración de Hermes
- Reinicia el servicio del modelo

### 2.6 Servicio Systemd

**Archivo:** `/home/redark2/.config/com.github.johnfactist_minimaltoml.conf/llama-server.service`

```ini
[Unit]
Description=llama.cpp OpenAI-compatible API Server
After=network.target

[Service]
Type=simple
User=redark2
WorkingDirectory=/home/redark2/IA/llama.cpp
ExecStart=/home/redark2/IA/llama.cpp/build/llama.cpp-build-preset/bin/llama-server \
    --host 0.0.0.0 \
    --port 8081 \
    -m /home/redark2/Models/Qwen3.6-35B-A3B-F16.gguf \
    -ngl 999 \
    --ctx-size 8192 \
    --batch-size 2048 \
    --threads 8 \
    --threads-batch 8 \
    --log-disable
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

**Parámetros clave:**
- `-ngl 999` — Todas las capas en GPU (GPU offload completo)
- `--ctx-size 8192` — Contexto de 8K tokens
- `--batch-size 2048` — Batch size para inferencia
- `--threads 8` — Hilos CPU para preprocessing
- Puerto: `8081` (API OpenAI-compatible)

### 2.7 Benchmarks

El benchmark landing page está en `/home/redark2/IA/benchmarks/landing-qwen/`:
- `index.html` — Landing page profesional con HTML/CSS/JS
- `styles.css` — Estilos modernos con gradientes
- `favicon.svg` — Icono del sitio
- **NEXORA** — Landing page de automatización con IA (proyecto asociado)

---

## 3. Integración con Hermes Agent

### 3.1 Arquitectura

```
┌─────────────────────────────────────────────────┐
│           Hermes Agent Desktop                  │
│  ┌─────────────┐    ┌──────────────────────┐   │
│  │  Chat UI    │    │  Model Provider      │   │
│  │  (Web)      │◄──►│  qwen provider       │   │
│  └─────────────┘    └──────────┬───────────┘   │
│                                │                │
│                    llama-server (:8081)          │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│         llama-server (llama.cpp)                │
│  ┌──────────────────────────────────────────┐   │
│  │  Qwen3.6-35B-A3B-F16.gguf                │   │
│  │  CUDA 13 + cuDNN 9 (GPU)                 │   │
│  │  Context: 8192 tokens                    │   │
│  └──────────────────────────────────────────┘   │
│  API: OpenAI-compatible (:8081)                 │
└─────────────────────────────────────────────────┘
```

### 3.2 Configuración de Hermes

- **Modelo:** `unsloth/Qwen3.6-35B-A3B-GGUF:UD-IQ4_XS`
- **Provider:** `qwen`
- **API URL:** `localhost:8081/v1` (llama-server OpenAI compatible)
- **Reasoning level:** Deterministic (prefiere herramientas sobre juicio del modelo)
- **Kanban:** Sistema de gestión de tareas integrado
- **Skills:** +40 skills instalados (web, devops, media, social, productivity, etc.)

---

## 4. Infraestructura de Discos

### 4.1 Montajes Activos

| Punto Montaje | Dispositivo | Sistema de Archivos | Uso |
|---------------|-------------|---------------------|-----|
| `/mnt/DataGame/` | `/dev/nvme1n1p1` | ext4 | Almacenamiento principal |

**Montaje persistente:** Configurado en `/etc/fstab`:
```
/dev/nvme1n1p1  /mnt/DataGame  ext4  defaults,noatime  0 2
```

### 4.2 Distribución de Almacenamiento

| Componente | Ubicación | Tamaño |
|------------|-----------|--------|
| ComfyUI models | `/mnt/DataGame/ComfyUI-Models/` | **495 GB** |
| llama.cpp binarios | `/home/redark2/IA/llama.cpp/build/` | ~2 GB |
| Qwen GGUF model | `/home/redark2/Models/` | ~70 GB (estimado F16) |
| Workflows/Nek | `/mnt/DataGame/ComfyUI-Models/Nek WorkFlow/` | ~49 MB |

---

## 5. Resumen de Recursos

### 5.1 Uso de GPU

| Componente | VRAM Estimado |
|------------|---------------|
| Qwen 3.6 (F16 GGUF) | ~70 GB |
| ComfyUI (SDXL/Flux) | 12-24 GB según modelo |
| **Total máximo** | **~94 GB** (picos) |

### 5.2 Modelos Principales por Categoría

#### ComfyUI — Checkpoints (6 archivos, 34G)
- Stable Diffusion XL
- Flux (varias variantes)
- Modelos de video (LTX, MiniMax)

#### ComfyUI — LoRAs (44 archivos, 19G)
- Style transfer LoRAs
- Character/persona LoRAs
- Enhancement LoRAs

#### ComfyUI — VAEs (18 archivos, 24G)
- VAE estándar para SD/SDXL
- VAE para modelos de video
- VAEs optimizados

### 5.3 Servicios Actuales

| Servicio | Puerto | Estado | Reinicio |
|----------|--------|--------|----------|
| ComfyUI | 8188 | systemd | on-failure |
| llama-server | 8081 | systemd | on-failure |

### 5.4 Notas de Mantenimiento

1. **Backup:** Los 495G de modelos en `/mnt/DataGame/ComfyUI-Models/` son críticos
2. **Actualización ComfyUI:** `cd ~/ComfyUI && git pull && ./update.sh`
3. **Actualización llama.cpp:** `cd ~/IA/llama.cpp && git pull && cmake --build build`
4. **Monitoreo GPU:** `nvidia-smi` para ver uso de VRAM
5. **Logs:** `journalctl -u comfyui.service` y `journalctl -u llama-server.service`

---

*Informe generado el 2025-11-02 por Hermes Agent*
