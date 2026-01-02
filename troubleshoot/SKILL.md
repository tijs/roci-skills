---
name: troubleshoot
description: Debug Roci system issues - services, timers, IPC, logs. Use when services won't start, watch ticks missing, errors in logs, IPC timeouts, or "Roci seems broken". Guides systematic diagnosis from symptoms to root cause.
---

# Troubleshoot Roci System

Comprehensive diagnostic workflow for Roci's multi-service architecture.

## Quick Health Check

Start here if unsure what's wrong:

1. **Check service status** - Are all services running?
   ```bash
   bash /home/tijs/roci/scripts/status.sh
   ```

2. **Test IPC connectivity** - Can services communicate?
   ```bash
   bash /home/tijs/roci/skills/troubleshoot/scripts/test-ipc.sh
   ```

3. **Check recent logs** - Any errors in the last 50 lines?
   ```bash
   ssh roci 'sudo journalctl -u roci-memory -u roci-rag -u roci-agent -u roci-matrix -n 50 --no-pager'
   ```

4. **Verify timer schedules** - When do watch/reflect fire next?
   ```bash
   bash /home/tijs/roci/skills/troubleshoot/scripts/check-timers.sh
   ```

If issues found, proceed to the relevant diagnostic path below.

## Diagnostic Paths by Symptom

### 1. Services Not Running

**Symptoms:** `status.sh` shows "inactive (dead)" or "failed"

**Diagnosis steps:**

1. Check which service(s) are down:
   ```bash
   ssh roci 'sudo systemctl status roci-memory roci-rag roci-agent roci-matrix --no-pager'
   ```

2. View logs for crash reasons:
   ```bash
   ssh roci 'sudo journalctl -u roci-SERVICE -n 100 --no-pager'
   ```

3. Verify service dependencies (memory must start before agent/rag, agent before
   matrix):
   - If memory is down, start it first
   - If agent is down but memory is up, check memory socket exists
   - If matrix is down but agent is up, check agent socket exists

4. Check .env configuration exists:
   ```bash
   ssh roci 'ls -la ~/roci/roci-SERVICE/.env'
   ```

5. Verify secrets file exists and has correct permissions:
   ```bash
   ssh roci 'sudo ls -la /etc/roci/secrets.conf'
   ```
   (Should show `-rw-------` permissions, owned by root)

**Common fixes:**

- Restart services in dependency order:
  ```bash
  bash /home/tijs/roci/scripts/restart.sh all
  ```

- If memory service won't start, check STATE_DIR environment variable and verify
  `/home/tijs/roci/state/` exists
- If agent service won't start, check LLM_SERVICE_URL points to correct endpoint
- If systemd files were modified, reload daemon:
  ```bash
  ssh roci 'sudo systemctl daemon-reload'
  ```

### 2. Watch Ticks Not Firing

**Symptoms:** No watch messages at 2-hour intervals, state not updating
automatically

**Diagnosis steps:**

1. Check timer status and next fire time:
   ```bash
   bash /home/tijs/roci/skills/troubleshoot/scripts/check-timers.sh
   ```

2. Verify roci-watch.timer and roci-watch.service are loaded:
   ```bash
   ssh roci 'systemctl list-unit-files | grep roci-watch'
   ```

3. Check watch-tick script exists and is executable:
   ```bash
   ssh roci 'ls -la ~/roci/scripts/watch-tick.sh'
   ```

4. Test manual watch tick trigger:
   ```bash
   bash /home/tijs/roci/scripts/watch-tick.sh
   ```

5. Check watch service logs for failures:
   ```bash
   ssh roci 'sudo journalctl -u roci-watch.service -n 20 --no-pager'
   ```

6. Verify agent IPC server is running and accepting connections:
   ```bash
   ssh roci 'test -S /var/run/roci/agent.sock && echo "Socket exists" || echo "Socket missing"'
   ```

**Common fixes:**

- If timer not enabled, enable it:
  ```bash
  ssh roci 'sudo systemctl enable roci-watch.timer && sudo systemctl start roci-watch.timer'
  ```

- If script has permissions issues, fix:
  ```bash
  ssh roci 'chmod +x ~/roci/scripts/watch-tick.sh'
  ```

- If agent socket missing, restart agent service:
  ```bash
  bash /home/tijs/roci/scripts/restart.sh agent
  ```

### 3. IPC Communication Failures

**Symptoms:** "socket timeout", "connection refused", "ENOENT" errors

**Diagnosis steps:**

1. Test IPC connectivity to all services:
   ```bash
   bash /home/tijs/roci/skills/troubleshoot/scripts/test-ipc.sh
   ```

2. Verify socket files exist with correct permissions:
   ```bash
   ssh roci 'ls -la /var/run/roci/'
   ```
   (Should show srwxr-xr-x permissions, owned by tijs)

3. Check if services are actually running:
   ```bash
   ssh roci 'sudo systemctl status roci-memory roci-agent roci-matrix roci-rag --no-pager'
   ```

4. Verify service dependencies are satisfied:
   - Memory must be running before agent/rag can connect
   - Agent must be running before matrix can connect

5. Check for orphaned socket files (services crashed without cleanup):
   ```bash
   ssh roci 'lsof /var/run/roci/*.sock 2>/dev/null || echo "No processes listening"'
   ```

**Common fixes:**

- If sockets exist but no process listening, clean up and restart:
  ```bash
  bash /home/tijs/roci/scripts/restart.sh all
  bash /home/tijs/roci/skills/troubleshoot/scripts/cleanup-sockets.sh
  bash /home/tijs/roci/scripts/restart.sh all
  ```

- If /var/run/roci/ directory doesn't exist, memory service needs to create it
  on startup (check memory service status)

- If permission denied, check socket file permissions and service user

### 4. LLM Service Issues

**Symptoms:** "Model not found", timeout errors, API errors

**Diagnosis steps:**

1. Check LLM service status:
   ```bash
   ssh roci 'sudo systemctl status roci-llm roci-litellm --no-pager'
   ```

2. Test HTTP endpoints:
   ```bash
   bash /home/tijs/roci/skills/troubleshoot/scripts/test-llm.sh
   ```

3. Verify services are listening on correct ports:
   ```bash
   ssh roci 'sudo ss -tulnp | grep -E "3000|8000"'
   ```

4. Check API keys in secrets file:
   ```bash
   ssh roci 'sudo grep ANTHROPIC_API_KEY /etc/roci/secrets.conf | wc -l'
   ```
   (Should show "1" if key exists)

5. Check LiteLLM logs for provider errors:
   ```bash
   ssh roci 'sudo journalctl -u roci-litellm -n 50 --no-pager'
   ```

6. Verify roci-llm can reach roci-litellm backend:
   ```bash
   ssh roci 'curl -s http://localhost:8000/health || echo "Backend unreachable"'
   ```

**Common fixes:**

- If roci-litellm is down, restart it first (roci-llm depends on it):
  ```bash
  ssh roci 'sudo systemctl restart roci-litellm'
  ssh roci 'sudo systemctl restart roci-llm'
  ```

- If API key missing or invalid, update /etc/roci/secrets.conf (requires root):
  ```bash
  ssh roci 'sudo nano /etc/roci/secrets.conf'
  # Then restart services to pick up new key
  ```

- If port conflict, check what's using the ports:
  ```bash
  ssh roci 'sudo lsof -i :3000 && sudo lsof -i :8000'
  ```

### 5. Memory/State File Issues

**Symptoms:** "STATE_DIR not found", wrong paths, ~/.roci/ directory appearing

**Diagnosis steps:**

1. Verify STATE_DIR environment variable is set correctly:
   ```bash
   ssh roci 'grep STATE_DIR ~/roci/roci-memory/.env'
   ssh roci 'grep STATE_DIR ~/roci/roci-agent/.env'
   ```
   (Should show `/home/tijs/roci/state`)

2. Check if state directory exists:
   ```bash
   ssh roci 'ls -la /home/tijs/roci/state/'
   ```

3. **CRITICAL:** Check for legacy ~/.roci/ directory (BUG if exists):
   ```bash
   ssh roci 'test -d ~/.roci && echo "BUG: Legacy directory exists" || echo "OK: No legacy directory"'
   ```

4. Check Letta memory blocks for hardcoded paths:
   - Review persona, human, and patterns blocks in Letta Cloud UI
   - Look for references to `/home/tijs/.roci/` (wrong)
   - Should reference `/home/tijs/roci/state/` (correct)

5. Verify core state files exist:
   ```bash
   ssh roci 'ls -la ~/roci/state/{inbox,today,commitments,patterns}.md'
   ```

**Common fixes:**

- If STATE_DIR not set, add to .env file:
  ```bash
  ssh roci 'echo "STATE_DIR=/home/tijs/roci/state" >> ~/roci/roci-memory/.env'
  ssh roci 'echo "STATE_DIR=/home/tijs/roci/state" >> ~/roci/roci-agent/.env'
  bash /home/tijs/roci/scripts/restart.sh all
  ```

- If ~/.roci/ exists (BUG), remove it and fix Letta blocks:
  ```bash
  ssh roci 'rm -rf ~/.roci'
  ```
  Then update Letta memory blocks to use correct paths.

- If state files missing, restore from backup:
  ```bash
  # Check latest backup
  ls -lt ~/projects/roci/backups/
  # Extract and restore to VPS
  ```

## Common Fixes

### Restart Services

Always restart in dependency order:

```bash
# Restart all services
bash /home/tijs/roci/scripts/restart.sh all

# Restart specific service
bash /home/tijs/roci/scripts/restart.sh memory
bash /home/tijs/roci/scripts/restart.sh agent
bash /home/tijs/roci/scripts/restart.sh matrix
```

### Clear Stale Sockets

**CAUTION:** Only run when services are stopped!

```bash
# Stop all services first
ssh roci 'sudo systemctl stop roci-matrix roci-agent roci-rag roci-memory'

# Clean up sockets
bash /home/tijs/roci/skills/troubleshoot/scripts/cleanup-sockets.sh

# Start services in dependency order
bash /home/tijs/roci/scripts/restart.sh all
```

### Reload Systemd

If systemd service files were modified:

```bash
# Install updated service files
bash /home/tijs/roci/scripts/install-services.sh

# Reload daemon
ssh roci 'sudo systemctl daemon-reload'

# Restart affected services
bash /home/tijs/roci/scripts/restart.sh all
```

### Reset State

**CAUTION:** Only if state is corrupted!

```bash
# 1. Backup current state first
bash /home/tijs/roci/scripts/backup.sh

# 2. Review backup and restore known good state
# (Manual process - check backups/ directory)
```

## Test Procedures

### Manual Watch Tick

Trigger a watch rotation manually (useful for testing):

```bash
bash /home/tijs/roci/scripts/watch-tick.sh
```

Expected output: "Watch tick sent successfully at [timestamp]"

### Manual Daily Reflection

Trigger daily reflection manually:

```bash
bash /home/tijs/roci/skills/troubleshoot/scripts/trigger-reflect.sh
```

Expected output: "Daily reflection sent successfully at [timestamp]"

### Test Memory IPC

Test all IPC connections:

```bash
bash /home/tijs/roci/skills/troubleshoot/scripts/test-ipc.sh
```

Expected output: Pass/fail status for memory, agent, matrix, and rag services

### Test LLM Gateway

Test HTTP endpoints:

```bash
bash /home/tijs/roci/skills/troubleshoot/scripts/test-llm.sh
```

Expected output: Status of roci-llm (port 3000) and roci-litellm (port 8000)

## Reference

**Service dependencies:**

- memory → (rag, agent) → matrix
- litellm → llm

**Socket paths:**

- `/var/run/roci/memory.sock` - Memory service server
- `/var/run/roci/agent.sock` - Agent service server
- `/var/run/roci/matrix.sock` - Matrix service server
- `/var/run/roci/rag.sock` - RAG service server

**HTTP endpoints:**

- `http://localhost:3000` - roci-llm (Deno proxy)
- `http://localhost:8000` - roci-litellm (Python backend)

**Timer schedules:**

- `roci-watch.timer` - Every 2 hours (00:00, 02:00, 04:00, etc.)
- `roci-reflect-daily.timer` - Daily at 23:00 (11 PM)

**State directory:**

- `/home/tijs/roci/state/` - Canonical state file location

**For detailed architecture, see:**

- `references/service-architecture.md` - Dependency graph and startup order
- `references/common-errors.md` - Known error patterns and solutions
- `references/ipc-protocol.md` - Manual IPC testing examples
