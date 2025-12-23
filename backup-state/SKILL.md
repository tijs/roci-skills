---
name: backup-state
description: Create a timestamped backup of the Roci state directory. Use when asked to backup memory, before making changes, or for regular state snapshots.
---

# Backup State Directory

Run the backup script to create a compressed archive of the state directory:

```bash
bash /home/tijs/roci/skills/backup-state/scripts/backup.sh
```

The script:
1. Creates ~/roci/backups/ if needed
2. Creates a timestamped tarball of the state directory
3. Lists recent backups

Report the backup filename and size when complete.
