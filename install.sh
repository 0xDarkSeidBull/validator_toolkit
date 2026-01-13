#!/usr/bin/env bash
set -e

echo "🚀 Validator Toolkit Installer"

if [ "$EUID" -ne 0 ]; then
  echo "❌ Run with sudo"
  exit 1
fi

bash <(curl -sSL https://raw.githubusercontent.com/0xDarkSeidBull/validator_toolkit/main/scripts/deps.sh)
bash <(curl -sSL https://raw.githubusercontent.com/0xDarkSeidBull/validator_toolkit/main/scripts/build-tempo.sh)
bash <(curl -sSL https://raw.githubusercontent.com/0xDarkSeidBull/validator_toolkit/main/scripts/keys.sh)

echo "✅ Installation complete"
