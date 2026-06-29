#!/bin/bash
set -e

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" &> /dev/null && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$SCRIPT_DIR/$SOURCE"
done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" &> /dev/null && pwd )"

# Calculate the actual root project directory (one level up from scripts/)
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Instantly change your terminal context to the actual root project folder
cd "$PROJECT_DIR"

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
    # Configtxgen needs to look at the project directory where configtx.yaml lives
    export FABRIC_CFG_PATH="$PROJECT_DIR"
    
    ~/go/src/github.com/hyperledger/fabric-samples/bin/configtxgen -profile TwoOrgsChannel \
      -outputBlock "./components/orderer0/genesis.block" \
      -channelID glyphchannel
      
    echo "Booting clean containers..."
    docker compose up -d
    sleep 5
    
    echo "Creating and joining channel via admin CLI..."
    # Join the Orderer via host osnadmin
    docker exec cli osnadmin channel join \
      --channelID glyphchannel \
      --config-block /opt/gopath/src/github.com/hyperledger/fabric/peer/components/orderer0/genesis.block \
      -o orderer0.glyphchain.local:9443 \
      --ca-file /opt/gopath/src/github.com/hyperledger/fabric/peer/components/orderer0/msp/cacerts/intermediate-chain.crt \
      --client-cert /opt/gopath/src/github.com/hyperledger/fabric/peer/components/admin/admin.crt \
      --client-key /opt/gopath/src/github.com/hyperledger/fabric/peer/components/admin/admin.key.pem

    # Join Peer0 using the internal container relative paths
    docker exec cli peer channel join \
      -b ./components/orderer0/genesis.block \
      --tls \
      --cafile ./components/peer0/msp/cacerts/intermediate-chain.crt
      
    echo "Glyph Chain is fully initialized and ready!"
else
    echo "Usage: network [up | down | clean]"
fi