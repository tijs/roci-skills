# Roci Service Architecture

Reference documentation for understanding Roci's multi-service architecture, dependencies, and communication topology.

## Service Overview

Roci consists of 6 systemd services working together:

| Service | Technology | Purpose | Port/Socket |
|---------|-----------|---------|-------------|
| **roci-litellm** | Python (LiteLLM) | LLM provider backend | HTTP :8000 |
| **roci-llm** | Deno/TypeScript | LLM gateway proxy | HTTP :3000 |
| **roci-memory** | Deno/TypeScript | Memory management, Letta blocks, state files | IPC socket (server) |
| **roci-rag** | Deno/TypeScript | Document indexing, semantic search | IPC socket (server) |
| **roci-agent** | Deno/TypeScript | Agent harness, tool execution | IPC socket (server) |
| **roci-matrix** | Deno/TypeScript | Matrix protocol, E2E encryption | IPC socket (server) |

## Dependency Graph

```
roci-litellm.service (Python LLM backend)
    ↓ (required by)
roci-llm.service (Deno LLM proxy)

roci-memory.service (base IPC service)
    ↓ (required by)
roci-agent.service (requires memory)
roci-rag.service (wants memory)
    ↓ (required by)
roci-matrix.service (requires agent)
```

**Key points:**
- **LLM services:** litellm must start before llm (HTTP dependency)
- **IPC services:** memory must start before agent/rag (socket dependency)
- **Matrix:** Requires agent to be running (IPC dependency)

## Startup Order

When the system boots or services are restarted:

1. **roci-litellm** - Python backend starts first (port 8000)
2. **roci-llm** - Deno proxy starts (port 3000), depends on litellm
3. **roci-memory** - Base IPC service, creates `/var/run/roci/` directory
4. **roci-rag** and **roci-agent** - Start in parallel (both depend on memory)
5. **roci-matrix** - Starts last (depends on agent)

## IPC Communication Topology

```
┌─────────────────┐
│  roci-matrix    │ (receives from Matrix, sends to agent)
│  :matrix.sock   │
└────────┬────────┘
         │ IPC client
         ▼
┌─────────────────┐
│  roci-agent     │ (tool execution, sends to memory)
│  :agent.sock    │
└────┬────────────┘
     │ IPC client (to memory)
     │ IPC client (to matrix for proactive messages)
     ▼
┌─────────────────┐        ┌─────────────────┐
│  roci-memory    │◄───────│  roci-rag       │
│  :memory.sock   │        │  :rag.sock      │
└─────────────────┘        └─────────────────┘
     │ IPC client
     ▼
┌─────────────────┐
│  roci-rag       │ (memory uses rag for document search)
│  :rag.sock      │
└─────────────────┘
```

**Socket paths:**
- `/var/run/roci/memory.sock` - Memory service (server)
- `/var/run/roci/agent.sock` - Agent service (server)
- `/var/run/roci/matrix.sock` - Matrix service (server)
- `/var/run/roci/rag.sock` - RAG service (server)

## HTTP Communication

```
┌─────────────────┐
│  roci-agent     │
└────────┬────────┘
         │ HTTP client
         ▼
┌─────────────────┐
│  roci-llm       │ (Deno proxy, port 3000)
│  localhost:3000 │
└────────┬────────┘
         │ HTTP proxy
         ▼
┌─────────────────┐
│  roci-litellm   │ (Python backend, port 8000)
│  localhost:8000 │
└────────┬────────┘
         │ HTTP to providers
         ▼
    (Claude API, Gemini API, etc.)
```

## Service Restart Order

When restarting services manually, follow dependency order:

### Stop (reverse dependency order):
```bash
sudo systemctl stop roci-matrix
sudo systemctl stop roci-agent
sudo systemctl stop roci-rag
sudo systemctl stop roci-memory
sudo systemctl stop roci-llm
sudo systemctl stop roci-litellm
```

### Start (dependency order):
```bash
sudo systemctl start roci-litellm
sudo systemctl start roci-llm
sudo systemctl start roci-memory
sudo systemctl start roci-rag  # can start in parallel with agent
sudo systemctl start roci-agent
sudo systemctl start roci-matrix
```

**Or use the script:**
```bash
bash /home/tijs/roci/scripts/restart.sh all
```

## Autonomous Triggering

Two systemd timers provide autonomous operation:

### roci-watch.timer
- **Schedule:** Every 2 hours (00:00, 02:00, 04:00, etc.)
- **Persistent:** Yes (catches up if missed)
- **Triggers:** roci-watch.service (oneshot)
- **Script:** `/home/tijs/roci/scripts/watch-tick.sh`
- **Message:** Sends `{"type":"watch_tick","timestamp":"..."}` to agent.sock

### roci-reflect-daily.timer
- **Schedule:** Daily at 23:00 (11 PM CET)
- **Persistent:** Yes (catches up if missed)
- **Triggers:** roci-reflect-daily.service (oneshot)
- **Script:** `/home/tijs/roci/scripts/reflect-tick.sh`
- **Message:** Sends `{"type":"daily_reflection","timestamp":"..."}` to agent.sock

## Resource Limits

All services have systemd resource limits:

- **CPU:** 50% (CPUQuota=50%)
- **Memory:**
  - roci-memory: 512MB
  - roci-agent: 1GB
  - roci-matrix: 512MB
  - roci-rag: 512MB
  - roci-llm: 256MB
  - roci-litellm: 1GB

## Security Configuration

All services run with:
- **User:** tijs (non-root)
- **PrivateTmp:** yes (isolated /tmp)
- **NoNewPrivileges:** yes (cannot escalate privileges)
- **Restart:** always (auto-restart on failure)

## Common Issues

### Service won't start
1. Check dependencies are running first (memory before agent, etc.)
2. Check logs: `sudo journalctl -u roci-SERVICE -n 50`
3. Verify socket files exist in `/var/run/roci/`

### IPC timeouts
1. Verify target service is running
2. Check socket file exists and has correct permissions
3. Test with `bash /home/tijs/roci/skills/troubleshoot/scripts/test-ipc.sh`

### Timer not firing
1. Check timer is enabled: `systemctl list-timers roci-watch.timer`
2. Verify agent socket exists for timer to send messages
3. Check timer service logs: `sudo journalctl -u roci-watch.service`
