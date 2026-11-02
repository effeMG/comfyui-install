#!/usr/bin/env fish

set LLAMA_DIR ~/IA/llama.cpp
set LOG_DIR ~/IA/logs

mkdir -p $LOG_DIR


function stop_llama
    echo "🛑 Deteniendo llama-server..."

    pkill -f 'llama-server' 2>/dev/null

    for i in (seq 1 200)
        if not pgrep -f 'llama-server' >/dev/null
            break
        end
        sleep 0.5
    end

    echo "✅ Llama-server detenido."
end


function wait_for_server
    set PORT $argv[1]
    set NAME $argv[2]

    echo "⏳ Esperando a $NAME..."

    for i in (seq 1 120)
        if curl -sf http://127.0.0.1:$PORT/health >/dev/null
            echo "✅ $NAME listo → http://127.0.0.1:$PORT"
            return 0
        end

        sleep 1
    end

    echo "❌ Timeout esperando a $NAME en el puerto $PORT"
    return 1
end


switch $argv[1]

    case gemma
        echo "🟣 Iniciando Gemma 4 E4B — Performance..."

        stop_llama

        cd $LLAMA_DIR

        ./build/bin/llama-server \
            -hf ggml-org/gemma-4-E4B-it-GGUF:Q4_0 \
            -hfd ggml-org/gemma-4-E4B-it-GGUF:mtp-Q4_0 \
            --spec-type draft-mtp \
            --spec-draft-n-max 5 \
            --backend-sampling \
            --flash-attn on \
            --cache-type-k q8_0 \
            --cache-type-v q8_0 \
            --spec-draft-type-k q8_0 \
            --spec-draft-type-v q8_0 \
            -c 131072 \
            --parallel 1 \
            --reasoning off \
            --media-path /home/redark2 \
            --host 127.0.0.1 \
            --port 8082 \
            > $LOG_DIR/gemma4.log 2>&1 &

        wait_for_server 8082 "Gemma 4 E4B"

        echo "📄 Log: $LOG_DIR/gemma4.log"


    case qwen
        echo "🔵 Iniciando Qwen 3.6..."

        stop_llama

        cd $LLAMA_DIR

        ./build/bin/llama-server \
            -hf unsloth/Qwen3.6-35B-A3B-GGUF:UD-IQ4_XS \
            --no-mmproj \
            --ctx-size 64000 \
            --parallel 1 \
            --n-gpu-layers auto \
            --n-cpu-moe 32 \
            --flash-attn on \
            --cache-type-k q8_0 \
            --cache-type-v q8_0 \
            --jinja \
            --reasoning off \
            --host 127.0.0.1 \
            --port 8080 \
            > $LOG_DIR/qwen36.log 2>&1 &

        wait_for_server 8080 "Qwen 3.6"

        echo "📄 Log: $LOG_DIR/qwen36.log"


    case stop
        stop_llama


    case status
        echo "╔══════════════════════════════╗"
        echo "║         LLM STATUS          ║"
        echo "╚══════════════════════════════╝"

        if curl -sf http://127.0.0.1:8082/health >/dev/null
            echo "🟣 Gemma 4 E4B : ACTIVO (8082)"
        else
            echo "🟣 Gemma 4 E4B : apagado"
        end

        if curl -sf http://127.0.0.1:8080/health >/dev/null
            echo "🔵 Qwen 3.6    : ACTIVO (8080)"
        else
            echo "🔵 Qwen 3.6    : apagado"
        end

        echo
        echo "GPU:"

        nvidia-smi \
            --query-gpu=memory.used,memory.free,memory.total,temperature.gpu \
            --format=csv,noheader


    case '*'
        echo
        echo "Uso:"
        echo
        echo "  llm gemma   → Gemma 4 E4B"
        echo "  llm qwen    → Qwen 3.6"
        echo "  llm status  → Estado y VRAM"
        echo "  llm stop    → Detener llama-server"
        echo
end
