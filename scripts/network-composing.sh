#!/bin/bash
set -e

# Define absolute paths to prevent any directory context issues
PROJECT_DIR="/home/administrator/GLYPH Chain Orchestrator/network/certificates"
COMPOSE_FILE="$PROJECT_DIR/docker-compose.yaml"

COMMAND=$1

if [ "$COMMAND" == "up" ]; then
    echo "Starting Glyph Chain network..."
    docker compose -f "$COMPOSE_FILE" up -d
    
elif [ "$COMMAND" == "down" ]; then
    echo "Stopping containers..."
    docker compose -f "$COMPOSE_FILE" down
    
elif [ "$COMMAND" == "clean" ]; then
    echo "Obliterating old network state and database volumes..."
    docker compose -f "$COMPOSE_FILE" down --volumes --remove-orphans
    docker volume prune -f
    
    echo "Re-baking fresh genesis block..."
    export FABRIC_CFG_PATH="$PROJECT_DIR"
    
    ~/go/src/github.com/hyperledger/fabric-samples/bin/configtxgen -profile TwoOrgsChannel \
      -outputBlock "$PROJECT_DIR/components/orderer0/genesis.block" \
      -channelID glyphchannel
      
    echo "Booting clean containers..."
    docker compose -f "$COMPOSE_FILE" up -d
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