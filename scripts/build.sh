#!/usr/bin/env bash
set -e

echo "📂 Cloning Tempo repo"

rm -rf /opt/tempo
git clone https://github.com/0xDarkSeidBull/tempo.git /opt/tempo

cd /opt/tempo

echo "⚙️ Building Tempo binary"
source /root/.cargo/env
cargo build --release --bin tempo
