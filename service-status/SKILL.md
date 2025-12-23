---
name: service-status
description: Check status of all Roci services (memory, agent, matrix). Use when asked if services are running, to diagnose issues, or check service health.
---

# Roci Service Status Check

Run the status script to check all three Roci services:

```bash
bash /home/tijs/roci/skills/service-status/scripts/status.sh
```

The script checks:
- roci-memory service
- roci-agent service
- roci-matrix service

Report which services are running, any errors, and resource usage.
