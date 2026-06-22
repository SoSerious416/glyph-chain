```markdown
# 🚀 GLYPH CHAIN: Distributed Ledger Orchestrator

Welcome to **GLYPH CHAIN**! This repository houses a high-performance full-stack architecture featuring a multi-threaded **Go backend**, real-time **gRPC communication protocols**, and a responsive **React JS frontend dashboard** built with Vite. 

This guide serves as a comprehensive roadmap to take you from **Zero to Hero**—guiding you through machine configuration, protocol compilation, and booting the entire orchestration system from scratch.

---

```
## 🛠️ System Architecture Overview

GLYPH CHAIN acts as a high-throughput hub where real-time streaming data, edge messages, and distributed ledger states smoothly synchronize:

```
[ React JS Frontend ]  <--- (HTTP/JSON Streams via gRPC-Web) ---> [ Go Backend Server ]
(UI View)                                                       (Core Engine Hub)
│
▼
[ SQLite Data Store ]
```

* **Frontend:** Built with React JS and Vite for lightning-fast hot-reloading and highly responsive components.
* **Backend:** A robust Go orchestration server handling multi-threaded routines, low-latency gRPC streams, and data transformations.
* **Storage:** Local relational state persistence managed via an embedded SQLite database instance.

---

## 📋 Prerequisites

Ensure your local machine has these core system dependencies installed before running the project.

### 1. Linux / Ubuntu Environment Setup
Update your package index and ensure core compilation utilities are ready:
```bash
sudo apt update && sudo apt install -y build-essential sqlite3 libsqlite3-dev git

```

### 2. Go Language Compiler (v1.20+)

Install Go cleanly via Snap to ensure all environment paths align correctly:

```bash
sudo snap install go --classic

```

### 3. Protocol Buffers Compiler (`protoc`)

Used to compile structural `.proto` definition schemas into language-native source code:

```bash
sudo snap install protobuf --classic

```

### 4. Node.js & NPM (v20+)

Required to compile, watch, and run your React development server:

```bash
curl -fsSL [https://deb.nodesource.com/setup_20.x](https://deb.nodesource.com/setup_20.x) | sudo -E bash -
sudo apt-get install -y nodejs

```

---

## ⚙️ Step-by-Step Installation & Setup

### Step 1: Clone and Environment Variable Configuration

Clone the repository directly into your local workspace directory:

```bash
git clone <your-github-repo-ssh-link> glyph-chain
cd glyph-chain

```

Configure your local shell paths so your system can locate global Go binaries and compiled gRPC plugins. Run these commands or append them to your `~/.bashrc`:

```bash
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:/snap/bin
source ~/.bashrc

```

### Step 2: Install Go gRPC Plugins

Download the specialized compilation plugins that allow `protoc` to auto-generate structural Go code from your protocol buffers:

```bash
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

```

---

## 🚀 Running the Application

### 1. Compile the Protocol Buffers (gRPC)

Whenever you modify your API definitions in the `.proto` schemes, you must re-compile them. Navigate to your proto directory and run:

```bash
protoc --go_out=. --go-grpc_out=. ./proto/service.proto

```

*(Adjust the file path above to match where your custom `.proto` file is saved).*

### 2. Launch the Go Backend Server

Navigate to your backend directory, pull the module dependencies, and start the engine:

```bash
cd backend
go mod tidy
go run main.go

```

> 🔹 **Note:** The backend will spin up its gRPC framework and automatically initialize your local SQLite database file instance securely.

### 3. Launch the React JS Frontend

Open a separate terminal window or split-pane, navigate to your frontend project folder, and run the development compiler:

```bash
cd frontend
npm install
npm run dev

```

### 4. Access the Dashboard

Once Vite boots, it will output a local network address (e.g., `http://localhost:5173`). Open your web browser, paste the address into the URL bar, and watch the GLYPH CHAIN orchestrator come alive!

---

## 🔒 Security & Best Practices

* **Database Updates:** The embedded database updates in real-time. Do not delete or modify the generated `.db` file manually while the Go server is active to prevent transactional lockups.
* **Git Exclusions:** This project includes a strict `.gitignore`. Local test database binaries, active private cryptographic keys (`.pem`, `.key`), and compiled cache records will automatically be blocked from tracking to keep deployment repositories secure.