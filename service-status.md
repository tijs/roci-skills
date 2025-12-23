---
name: service-status
description: Check status of all Roci services
tools_required: [Bash]
---

# Roci Service Status Check

Check the status of all three Roci services:

1. Run `sudo systemctl status roci-memory --no-pager` to check memory service
2. Run `sudo systemctl status roci-agent --no-pager` to check agent service
3. Run `sudo systemctl status roci-matrix --no-pager` to check Matrix service

Report which services are running, any errors, and memory/CPU usage if shown.
