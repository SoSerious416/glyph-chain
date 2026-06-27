#!/bin/bash
set -e

# 🚀 THE FIX: This recursively follows symlinks to get the REAL project folder path
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" &> /dev/null && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$SCRIPT_DIR/$SOURCE"
done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" &> /dev/null && pwd )"

# Instantly change your terminal context to the actual project folder
cd "$SCRIPT_DIR"

COMMAND=$1

if [ "$COMMAND" == "up" ]; then
    echo "Starting Glyph Chain network..."
    docker compose up -d
    
elif [ "$COMMAND" == "down" ]; then
    echo "Stopping containers..."
    docker compose down
    
elif [ "$COMMAND" == "clean" ]; then
    echo "Obliterating old network state and database volumes..."
    docker compose down --volumes --remove-orphans
    docker volume prune -f
    
    echo "Re-baking fresh genesis block..."
    export FABRIC_CFG_PATH="$SCRIPT_DIR"
    ~/go/src/github.com/hyperledger/fabric-samples/bin/configtxgen -profile TwoOrgsChannel \
      -outputBlock "./components/orderer0/genesis.block" \
      -channelID glyphchannel
      
    echo "⚡ Booting clean containers..."
    docker compose up -d
    sleep 5
    
    echo "🔗 Creating and joining channel via admin CLI..."
    # Join the Orderer via host osnadmin
    ~/go/src/github.com/hyperledger/fabric-samples/bin/osnadmin channel join \
      --channelID glyphchannel \
      --config-block "./components/orderer0/genesis.block" \
      -o orderer0.glyphchain.local:9443 \
      --ca-file "./components/orderer0/msp/cacerts/intermediate-chain.crt" \
      --client-cert "./components/admin/admin.crt" \
      --client-key "./components/admin/admin.key.pem"

    # Join Peer0 inside the new CLI container natively
    docker exec -it cli peer channel join \
      -b ./components/orderer0/genesis.block \
      --cafile ./components/orderer0/msp/cacerts/intermediate-chain.crt
      
    echo "✅ Glyph Chain is fully initialized and ready!"
else
    echo "Usage: network [up | down | clean]"
fi