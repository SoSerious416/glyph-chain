# 🚀 GLYPH CHAIN: Decentralized Certification & Ledger Orchestrator

Welcome to **GLYPH CHAIN**! This repository houses a decentralized, high-performance certification system utilizing a secure public key infrastructure (PKI), a secure distributed ledger mechanism via **Hyperledger Fabric**, a multi-threaded **Go backend**, real-time **gRPC communication protocols**, and a responsive **React JS frontend dashboard** built with Vite.

## 🛠️ System Architecture Overview

GLYPH CHAIN coordinates a security-first environment where cryptographic identities, transactional blocks, and edge messages smoothly synchronize across a custom trust network:


```
[ React JS Frontend ]  <--- (HTTP/JSON Streams via gRPC-Web) ---> [ Go Backend Server ]
(UI View)                                                     (Core Engine Hub)
│
▼
[ Windows Server Root CA ]                                     [ Hyperledger Fabric ]
│                                                      ├── Peer Nodes (Org1)
▼                                                      ├── Orderer Node
[ Linux Intermediate CA ] ──(Issues MSP Node Certs)─────────────└── CouchDB State Store

```

* **Custom PKI Infrastructure:** Enterprise-grade dual-tier certificate validation. A Windows Server 2019 Active Directory Root CA securely anchors authority, delegating day-to-day transaction and node identity signing to a Linux Intermediate Subordinate CA.
* **Distributed Ledger Network:** Powered by Hyperledger Fabric with structured Membership Service Providers (MSPs), organizing transaction validation via channel anchoring, Raft orderers, and CouchDB state storage.
* **Frontend:** Built with React JS and Vite for lightning-fast hot-reloading and highly responsive components.
* **Backend:** A robust Go orchestration server handling multi-threaded routines, low-latency gRPC streams, and smart contract ledger interactions.

## 📋 Prerequisites

Ensure your local machine has these core system dependencies installed before running the project.

### 1. Enterprise Hyperledger & Containerization Tools
Since the network runs containerized components, ensure your environment has Docker and Docker Compose ready:
```bash
sudo apt update && sudo apt install -y docker.io docker-compose build-essential sqlite3 git
sudo usermod -aG docker $USER

```

### 2. Cryptographic Validation Tools (OpenSSL)

Required to manage the Intermediate CA keys, CSR files, and node identity generation:

```bash
sudo apt install -y openssl

```

### 3. Go Language Compiler (v1.20+)

Install Go cleanly via Snap to ensure all environment paths align correctly for backend tasks and chaincode execution:

```bash
cd ~
wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz

# 1. Extract it cleanly to /usr/local
sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz
rm go1.22.0.linux-amd64.tar.gz

# 2. Open up your bashrc profile to double-check paths are locked in
nano ~/.bashrc

```

### 4. Protocol Buffers Compiler (`protoc`)

Used to compile structural `.proto` definition schemas into language-native source code:

```bash
sudo snap install protobuf --classic

```

### 5. Node.js & NPM (v20+)

Required to compile, watch, and run your React development server:

```bash
sudo snap install node --classic --channel=20/stable

```

## 📂 Cryptographic Directory Layout

Your custom identity credentials and configurations are strictly isolated within the network layout using **Conventional Commits** standards to trace infrastructure mutations:

```text
glyph-chain/
└── network/
    └── certificates/
        ├── index.txt                 <-- OpenSSL database ledger file
        ├── serial                    <-- Next available certificate serial tracking
        ├── intermediate-ca.cnf       <-- OpenSSL CA configuration blueprint
        ├── intermediate-ca.crt       <-- Signed certificate from Windows Root CA
        ├── intermediate-chain.crt    <-- Combined cryptographic trust bundle
        ├── components/               
        │   ├── peer0/                <-- Org1 Peer identity keys & certificate
        │   ├── orderer/              <-- Orderer network component credentials
        │   └── admin/                <-- Network administrator MSP certificates
        └── private/
            └── intermediate.key.pem  <-- CA Secret Key (🔒 Excluded via .gitignore)

```

## ⚙️ Step-by-Step Installation & Setup

### Step 1: Clone and Environment Variable Configuration

Clone the repository directly into your local workspace directory:

```bash
git clone <your-github-repo-ssh-link> glyph-chain
cd glyph-chain

```

Configure your local shell paths so your system can locate global Go binaries and compiled gRPC plugins. Run these commands or append them to your `~/.bashrc`:

```bash
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOPATH/bin:$PATH
source ~/.bashrc

```

### Step 2: Install Go gRPC Plugins

Download the specialized compilation plugins that allow `protoc` to auto-generate structural Go code from your protocol buffers:

```bash
sudo go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
sudo go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

```

## 🚀 Running the Application

### 1. Compile the Protocol Buffers (gRPC)

Whenever you modify your API definitions in the `.proto` schemes, you must re-compile them:

```bash
protoc --go_out=. --go-grpc_out=. ./proto/service.proto

```

### 2. Boot the Hyperledger Fabric Network Infrastructure

Once node certificates are issued via your Intermediate CA, launch your ledger components:

```bash
cd network
docker-compose up -d

```

### 3. Launch the Go Backend Server

Navigate to your backend directory, pull the module dependencies, and start the engine to bind with the network:

```bash
cd ../backend
go mod tidy
go run main.go

```

### 4. Launch the React JS Frontend

Open a separate terminal window or split-pane, navigate to your frontend project folder, and run the development compiler:

```bash
cd ../frontend
npm install
npm run dev

```

## 🔒 Security & Git Commit Rules

* **Conventional Commits:** This repository strictly enforces human and machine-readable commit rules. Use the structured prefixes outlined in your local reference file (`conventional_commits_sheet.txt`) when staging progress (e.g., `feat(crypto):`, `chore(git):`).
* **Git Exclusions:** Active private cryptographic keys (`.pem`, `.key`) contained within any `private/` subdirectories, system configuration caches, and local test binaries are entirely locked from being tracked to safeguard production secrets. Refer to `.gitignore` before updating components.