---
name: deploy
description: Deploy and restart Roci services (use with caution)
tools_required: [Bash]
---

# Deploy Roci Services

**CAUTION**: This will restart services and briefly interrupt availability.

Deployment steps:

1. First, confirm with the user which services to deploy (memory, agent, matrix, or all)
2. For each service being deployed:
   - Navigate to the service directory
   - Run `git pull` to get latest code
   - Run `npm install` if package.json changed (for Node services)
   - Run `uv sync` if pyproject.toml changed (for Python service)
3. Restart services in order (memory first, then agent, then matrix):
   - `sudo systemctl restart roci-memory`
   - `sudo systemctl restart roci-agent`
   - `sudo systemctl restart roci-matrix`
4. Verify services are running with `sudo systemctl status roci-memory roci-agent roci-matrix --no-pager`

Report success or any errors encountered.
