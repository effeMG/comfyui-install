#!/usr/bin/env python3

import json
import subprocess
import sys


LLM_SCRIPT = "/home/redark2/IA/scripts/llm.fish"


def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0

    if payload.get("hook_event_name") != "pre_command":
        return 0

    # Hermes 0.21.2 coloca command/args_raw dentro de "extra".
    extra = payload.get("extra", {})

    command = str(
        extra.get("command", payload.get("command", ""))
    ).strip().lower()

    args = str(
        extra.get("args_raw", payload.get("args_raw", ""))
    ).strip().lower()

    if command != "model":
        return 0

    first_arg = args.split()[0] if args else ""

    if first_arg in {"qwen", "custom:qwen"}:
        model = "qwen"

    elif first_arg in {"gemma", "custom:gemma"}:
        model = "gemma"

    elif "qwen3.6-35b-a3b" in args:
        model = "qwen"

    elif "gemma-4-e4b" in args:
        model = "gemma"

    else:
        return 0

    print(
        f"🔄 Cambiando backend llama.cpp → {model}",
        file=sys.stderr,
    )

    result = subprocess.run(
        ["fish", LLM_SCRIPT, model],
        stdout=sys.stderr,
        stderr=sys.stderr,
        check=False,
    )

    return result.returncode


if __name__ == "__main__":
    raise SystemExit(main())
