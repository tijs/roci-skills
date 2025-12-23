---
name: deploy
description: Deploy and restart Roci services. Use when asked to deploy updates, restart services, or apply code changes. CAUTION - will briefly interrupt service.
---

# Deploy Roci Services

**CAUTION**: This will restart services and briefly interrupt availability.

## Steps

1. First, confirm with the user which services to deploy:
   - memory (roci-memory)
   - agent (roci-agent)
   - matrix (roci-matrix)
   - all (all three)

2. For each service being deployed, run these commands:
   ```bash
   # Pull latest code (if git repo)
   cd ~/roci/roci-SERVICE && git pull

   # Install dependencies if needed
   npm install  # For Node services
   uv sync      # For Python service (matrix)
   ```

3. Restart services in order (memory first, then agent, then matrix):
   ```bash
   sudo systemctl restart roci-memory
   sudo systemctl restart roci-agent
   sudo systemctl restart roci-matrix
   ```

4. Verify services are running:
   ```bash
   sudo systemctl status roci-memory roci-agent roci-matrix --no-pager
   ```

Report success or any errors encountered.
