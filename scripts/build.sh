#!/usr/bin/env bash
set -e

echo "📂 Cloning validator code"
rm -rf /opt/validator
git clone https://github.com/0xDarkSeidBull/validator_toolkit.git /opt/validator

echo "⚙️ Building …"
source /root/.cargo/env
cd /opt/validator
cargo build --release
