#!/usr/bin/env bash
set -e

echo "🚀 validator_toolkit Installer"

if [ "$EUID" -ne 0 ]; then
  echo "❌ Run with sudo"
  exit 1
fi

mkdir -p /opt/tempo
cd /opt/tempo

bash <(curl -sSL https://raw.githubusercontent.com/0xDarkSeidBull/validator_toolkit/main/scripts/deps.sh)
bash <(curl -sSL https://raw.githubusercontent.com/0xDarkSeidBull/validator_toolkit/main/scripts/build.sh)
bash <(curl -sSL https://raw.githubusercontent.com/0xDarkSeidBull/validator_toolkit/main/scripts/keys.sh)

echo "✅ Done"
