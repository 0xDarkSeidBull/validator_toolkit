#!/usr/bin/env bash
set -e

mkdir -p /root/tempo-node

/opt/tempo/target/release/tempo consensus generate-private-key \
  --output /root/tempo-node/validator-key

/opt/tempo/target/release/tempo consensus calculate-public-key \
  --private-key /root/tempo-node/validator-key

cat /root/tempo-node/validator-key
chmod 600 /root/tempo-node/validator-key
