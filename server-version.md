---
name: server-version
description: Check VPS system information and versions
tools_required: [Bash]
---

# Server Version Check

Run the following commands to gather system information:

1. Run `uname -a` to get kernel and OS information
2. Run `node --version` to check Node.js version
3. Run `python3 --version` to check Python version
4. Run `cat /etc/os-release | head -5` to get OS release info

Summarize the versions in a clear format.
