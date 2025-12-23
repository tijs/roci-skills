---
name: check-logs
description: View recent logs from Roci services
tools_required: [Bash]
---

# Check Service Logs

View recent logs from Roci services:

1. Ask user which service(s) to check logs for (memory, agent, matrix, or all)
2. Use journalctl to view logs:
   - For a specific service: `sudo journalctl -u roci-SERVICE -n 50 --no-pager`
   - For all services: `sudo journalctl -u roci-memory -u roci-agent -u roci-matrix -n 50 --no-pager`
   - For errors only: add `--priority=err`
   - For a time range: add `--since "1 hour ago"`

Report any errors or notable events from the logs.
