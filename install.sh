#!/usr/bin/env bash
set -e

MODEL="${1:-'llama3.2:1b'}"

echo "Installing Opfel..."

if ! command -v ollama >/dev/null 2>&1; then
  echo "Error: Ollama is not installed."
  echo "Install it first: https://ollama.com"
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "Error: python3 is not installed."
  exit 1
fi

if [ ! -f "opfel.py" ]; then
  echo "Error: opfel.py not found."
  echo "Run this script from the Opfel repo folder."
  exit 1
fi

python3 -m pip install ollama

chmod +x opfel.py

mkdir -p "$HOME/.local/bin"

# ln -sf "$(pwd)/opfel.py" "$HOME/.local/bin/opfel"
cp opfel.py "$HOME/.local/bin/opfel"

if ! echo "$PATH" | grep -q '$HOME/.local/bin'; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

if ! grep -q "APFELLER_APFEL_BIN" "$HOME/.zshrc" 2>/dev/null; then
  echo 'export APFELLER_APFEL_BIN=opfel' >> "$HOME/.zshrc"
  echo "export OPFEL_MODEL=$MODEL" >> "$HOME/.zshrc"
fi

if ! pgrep -x "ollama" >/dev/null 2>&1; then
  echo "Starting Ollama..."
  ollama serve >/tmp/ollama.log 2>&1 &
  sleep 2
fi

echo "Pulling model: $MODEL"
ollama pull "$MODEL"

echo "Done."
echo "Run: source ~/.zshrc"