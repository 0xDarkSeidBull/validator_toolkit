#!/usr/bin/env bash
set -e

echo "📦 Cloning Tempo"

rm -rf /opt/tempo
git clone https://github.com/tempoxyz/tempo.git /opt/tempo
cd /opt/tempo

# 🔥 AUTO detect libclang path
export LIBCLANG_PATH=$(dirname $(ldconfig -p | grep libclang.so | head -n1 | awk '{print $NF}'))

echo "⚙️ Building Tempo"
. /root/.cargo/env
cargo build --release --bin tempo
