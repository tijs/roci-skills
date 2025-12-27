---
name: uptime
description: Check server uptime, load averages, and resource usage. Use when asked about server health, memory usage, disk space, or how long the server has been running.
---

# Server Uptime Check

Run the check script to gather uptime and resource information:

```bash
bash /home/tijs/roci/skills/uptime/scripts/check.sh
```

The script outputs:

- Server uptime and load averages
- Memory usage
- Disk usage on root partition

Report any concerns if resources are running low.
