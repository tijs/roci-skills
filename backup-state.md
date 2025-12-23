---
name: backup-state
description: Create a timestamped backup of the state directory
tools_required: [Bash]
---

# Backup State Directory

Create a compressed backup of the state directory:

1. Generate timestamp: `date +%Y%m%d-%H%M%S`
2. Create backup directory if needed: `mkdir -p ~/roci/backups`
3. Create tarball: `tar -czf ~/roci/backups/state-TIMESTAMP.tar.gz -C ~/roci state/`
4. List recent backups: `ls -lh ~/roci/backups/ | tail -5`

Report the backup filename and size.
