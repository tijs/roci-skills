---
name: check-logs
description: View recent logs from Roci services. Use when debugging issues, checking for errors, or monitoring service activity.
---

# Check Service Logs

## Steps

1. Ask the user which service(s) to check:
   - memory
   - agent
   - matrix
   - all

2. View logs using journalctl:

   **For a specific service (last 50 lines):**
   ```bash
   sudo journalctl -u roci-SERVICE -n 50 --no-pager
   ```

   **For all services:**
   ```bash
   sudo journalctl -u roci-memory -u roci-agent -u roci-matrix -n 50 --no-pager
   ```

   **For errors only:**
   ```bash
   sudo journalctl -u roci-SERVICE -n 50 --no-pager --priority=err
   ```

   **For a time range:**
   ```bash
   sudo journalctl -u roci-SERVICE --since "1 hour ago" --no-pager
   ```

3. Report any errors or notable events from the logs.
