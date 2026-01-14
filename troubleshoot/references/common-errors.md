# Common Roci Error Patterns

Quick reference for diagnosing and fixing common Roci system errors.

## IPC Errors

### "ENOENT: no such file or directory, connect '/var/run/roci/memory.sock'"

**Cause:** Memory service not running or socket file not created

**Diagnosis:**

```bash
# Check memory service status
ssh roci 'sudo systemctl status roci-memory'

# Verify socket exists
ssh roci 'ls -la /var/run/roci/memory.sock'
```

**Fix:**

```bash
# Start memory service
ssh roci 'sudo systemctl start roci-memory'

# Verify socket created
ssh roci 'test -S /var/run/roci/memory.sock && echo "OK"'
```

---

### "Connection timeout after 10000ms"

**Cause:** Service running but not responding (hung, deadlock, infinite loop)

**Diagnosis:**

```bash
# Check if process is consuming CPU (hung in loop)
ssh roci 'top -b -n 1 | grep -E "roci-(memory|agent|matrix)"'

# Check recent logs for errors
ssh roci 'sudo journalctl -u roci-SERVICE -n 50 --no-pager'
```

**Fix:**

```bash
# Restart the hung service
bash /home/tijs/roci/scripts/restart.sh SERVICE

# If persistent, check for deadlocks in code
```

---

### "Connection refused"

**Cause:** Service not running or socket permissions incorrect

**Diagnosis:**

```bash
# Check service status
bash /home/tijs/roci/scripts/status.sh

# Test IPC connectivity
bash /home/tijs/roci/skills/troubleshoot/scripts/test-ipc.sh

# Check socket permissions
ssh roci 'ls -la /var/run/roci/'
```

**Fix:**

```bash
# Restart all services in correct order
bash /home/tijs/roci/scripts/restart.sh all
```

---

## State File Errors

### "STATE_DIR not found" or "Cannot read property 'STATE_DIR'"

**Cause:** STATE_DIR environment variable not set or incorrect

**Diagnosis:**

```bash
# Check .env files
ssh roci 'grep STATE_DIR ~/roci/roci-memory/.env'
ssh roci 'grep STATE_DIR ~/roci/roci-agent/.env'

# Verify state directory exists
ssh roci 'ls -la /home/tijs/roci/state/'
```

**Fix:**

```bash
# Add STATE_DIR to .env files
ssh roci 'echo "STATE_DIR=/home/tijs/roci/state" >> ~/roci/roci-memory/.env'
ssh roci 'echo "STATE_DIR=/home/tijs/roci/state" >> ~/roci/roci-agent/.env'

# Restart services
bash /home/tijs/roci/scripts/restart.sh all
```

---

### "~/.roci/ directory exists" (BUG)

**Cause:** Legacy path in Letta memory blocks or fallback code

**Diagnosis:**

```bash
# Check if legacy directory exists
ssh roci 'test -d ~/.roci && echo "BUG: Legacy dir exists" || echo "OK"'

# Check which files are in it
ssh roci 'ls -la ~/.roci/'
```

**Fix:**

```bash
# 1. Remove legacy directory
ssh roci 'rm -rf ~/.roci'

# 2. Check Letta memory blocks in Letta Cloud UI
# Look for hardcoded paths: /home/tijs/.roci/ (WRONG)
# Should be: /home/tijs/roci/state/ (CORRECT)

# 3. Update memory blocks to use correct paths

# 4. Restart memory and agent services
bash /home/tijs/roci/scripts/restart.sh memory
bash /home/tijs/roci/scripts/restart.sh agent
```

---

## LLM Service Errors

### "Model not found" or "Invalid model"

**Cause:** LiteLLM backend not running or model not configured

**Diagnosis:**

```bash
# Check LLM services
ssh roci 'sudo systemctl status roci-llm roci-litellm --no-pager'

# Test endpoints
bash /home/tijs/roci/skills/troubleshoot/scripts/test-llm.sh

# Check LiteLLM config
ssh roci 'cat ~/roci/roci-llm/litellm_config.yaml'
```

**Fix:**

```bash
# Restart LLM services (litellm first)
ssh roci 'sudo systemctl restart roci-litellm'
ssh roci 'sudo systemctl restart roci-llm'

# Verify with test
bash /home/tijs/roci/skills/troubleshoot/scripts/test-llm.sh
```

---

### "API key not found" or "Authentication failed"

**Cause:** Missing or invalid API key in secrets file

**Diagnosis:**

```bash
# Check secrets file exists
ssh roci 'sudo ls -la /etc/roci/secrets.conf'

# Verify key is set (don't print the actual key)
ssh roci 'sudo grep ANTHROPIC_API_KEY /etc/roci/secrets.conf | wc -l'
```

**Fix:**

```bash
# Edit secrets file (requires root)
ssh roci 'sudo nano /etc/roci/secrets.conf'

# Add or update:
# ANTHROPIC_API_KEY=sk-ant-...

# Restart services to pick up new key
bash /home/tijs/roci/scripts/restart.sh all
```

---

## Timer Errors

### "Watch tick not firing"

**Cause:** Timer not enabled, agent service down, or script permissions

**Diagnosis:**

```bash
# Check timer status
bash /home/tijs/roci/skills/troubleshoot/scripts/check-timers.sh

# Check if timer is enabled
ssh roci 'systemctl is-enabled roci-watch.timer'

# Check watch service logs
ssh roci 'sudo journalctl -u roci-watch.service -n 20 --no-pager'

# Verify script is executable
ssh roci 'ls -la ~/roci/scripts/watch-tick.sh'
```

**Fix:**

```bash
# Enable and start timer
ssh roci 'sudo systemctl enable roci-watch.timer'
ssh roci 'sudo systemctl start roci-watch.timer'

# Make script executable
ssh roci 'chmod +x ~/roci/scripts/watch-tick.sh'

# Test manual trigger
bash /home/tijs/roci/scripts/watch-tick.sh
```

---

### "Timer fired but no message received"

**Cause:** Agent service not running or script failing silently

**Diagnosis:**

```bash
# Check agent service
ssh roci 'sudo systemctl status roci-agent'

# Check timer service logs for errors
ssh roci 'sudo journalctl -u roci-watch.service -n 10 --no-pager'

# Test manual trigger with verbose output
ssh roci '/home/tijs/roci/scripts/watch-tick.sh'
```

**Fix:**

```bash
# Restart agent service
bash /home/tijs/roci/scripts/restart.sh agent

# Verify agent socket exists
ssh roci 'test -S /var/run/roci/agent.sock && echo "OK"'

# Test manual trigger again
bash /home/tijs/roci/scripts/watch-tick.sh
```

---

## Matrix Service Errors

### "Failed to decrypt message" or "Crypto error"

**Cause:** E2E encryption keys not synced or device not verified

**Diagnosis:**

```bash
# Check matrix service logs
ssh roci 'sudo journalctl -u roci-matrix -n 50 --no-pager'

# Look for crypto errors or key sync issues
```

**Fix:**

```bash
# Restart matrix service (may trigger key sync)
bash /home/tijs/roci/scripts/restart.sh matrix

# If persistent, may need to verify device manually in Matrix client
# or reset E2E encryption (nuclear option, requires re-verification)
```

---

### "Matrix connection failed" or "Homeserver unreachable"

**Cause:** Network issues or Matrix server down

**Diagnosis:**

```bash
# Check if hamster.farm is reachable
ssh roci 'curl -s https://hamster.farm/_matrix/client/versions | head -5'

# Check matrix service logs
ssh roci 'sudo journalctl -u roci-matrix -n 50 --no-pager'

# Verify MATRIX_PASSWORD in secrets
ssh roci 'sudo grep MATRIX_PASSWORD /etc/roci/secrets.conf | wc -l'
```

**Fix:**

```bash
# Restart matrix service
bash /home/tijs/roci/scripts/restart.sh matrix

# If password changed, update secrets file
ssh roci 'sudo nano /etc/roci/secrets.conf'
```

---

## Resource Exhaustion

### "Out of memory" or service killed by OOM

**Cause:** Service exceeding memory limits or system memory exhausted

**Diagnosis:**

```bash
# Check system memory
ssh roci 'free -h'

# Check service memory usage
ssh roci 'sudo systemctl status roci-SERVICE | grep Memory'

# Check for OOM kills in logs
ssh roci 'sudo journalctl -k | grep -i "killed process"'
```

**Fix:**

```bash
# Restart service to free memory
bash /home/tijs/roci/scripts/restart.sh SERVICE

# If recurring, increase memory limit in systemd service file
ssh roci 'sudo nano /etc/systemd/system/roci-SERVICE.service'
# MemoryMax=1G → MemoryMax=2G

# Reload and restart
ssh roci 'sudo systemctl daemon-reload'
bash /home/tijs/roci/scripts/restart.sh SERVICE
```

---

### "CPU quota exceeded" or service throttled

**Cause:** Service consuming too much CPU

**Diagnosis:**

```bash
# Check CPU usage
ssh roci 'top -b -n 1 | grep -E "roci-(memory|agent|matrix)"'

# Check systemd CPU accounting
ssh roci 'sudo systemctl status roci-SERVICE | grep CPU'
```

**Fix:**

```bash
# Restart service
bash /home/tijs/roci/scripts/restart.sh SERVICE

# If legitimate high CPU usage, increase quota
ssh roci 'sudo nano /etc/systemd/system/roci-SERVICE.service'
# CPUQuota=50% → CPUQuota=100%

# Reload and restart
ssh roci 'sudo systemctl daemon-reload'
bash /home/tijs/roci/scripts/restart.sh SERVICE
```

---

## Deployment Errors

### "Permission denied" during rsync

**Cause:** SSH key not loaded or VPS permissions wrong

**Diagnosis:**

```bash
# Test SSH connection
ssh roci 'echo "Connected"'

# Check target directory permissions
ssh roci 'ls -la ~/roci/'
```

**Fix:**

```bash
# Ensure SSH key is loaded
ssh-add -l

# Add key if needed
ssh-add ~/.ssh/id_ed25519

# Fix permissions on VPS
ssh roci 'chmod -R u+w ~/roci/'
```

---

### "Quality check failed" during deploy

**Cause:** Code has linting, type, or test errors

**Diagnosis:**

```bash
# Run checks locally
cd roci-SERVICE
deno fmt
deno lint
deno check src/**/*.ts
deno test --allow-all
```

**Fix:**

```bash
# Fix linting issues
deno fmt

# Fix type errors (manual)
# Fix test failures (manual)

# Re-run deploy
bash /home/tijs/roci/scripts/deploy.sh SERVICE
```

---

## Emergency Recovery

### "Everything is broken"

**Nuclear option:** Restart all services and clear sockets

```bash
# 1. Stop all services
ssh roci 'sudo systemctl stop roci-matrix roci-agent roci-rag roci-memory roci-llm roci-litellm'

# 2. Clean up sockets
bash /home/tijs/roci/skills/troubleshoot/scripts/cleanup-sockets.sh

# 3. Restart all services
bash /home/tijs/roci/scripts/restart.sh all

# 4. Check status
bash /home/tijs/roci/scripts/status.sh

# 5. Test IPC
bash /home/tijs/roci/skills/troubleshoot/scripts/test-ipc.sh
```

---

## Prevention

**Regular health checks:**

```bash
# Daily quick check
bash /home/tijs/roci/scripts/status.sh

# Weekly comprehensive check
bash /home/tijs/roci/skills/troubleshoot/scripts/test-ipc.sh
bash /home/tijs/roci/skills/troubleshoot/scripts/check-timers.sh
bash /home/tijs/roci/skills/troubleshoot/scripts/test-llm.sh
```

**Weekly backups:**

```bash
bash /home/tijs/roci/scripts/backup.sh
```
