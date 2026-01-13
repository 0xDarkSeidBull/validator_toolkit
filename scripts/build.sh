#!/usr/bin/env bash
set -e

echo "📂 Cloning Tempo (actual Rust project)"

rm -rf /opt/tempo
git clone https://github.com/tempoxyz/tempo.git /opt/tempo

cd /opt/tempo

echo "⚙️ Building Tempo binary"
. /root/.cargo/env
cargo build --release --bin tempo
