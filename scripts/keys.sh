#!/usr/bin/env bash
set -e

echo "🔐 Generating validator keys"
mkdir -p /root/validator-node

/opt/validator/target/release/validator_toolkit \
  consensus generate-private-key \
  --output /root/validator-node/validator-key

/opt/validator/target/release/validator_toolkit \
  consensus calculate-public-key \
  --private-key /root/validator-node/validator-key

echo "📄 Validator private key:"
cat /root/validator-node/validator-key

chmod 600 /root/validator-node/validator-key
