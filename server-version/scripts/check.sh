#!/bin/bash
# Server version check script

echo "=== System Information ==="
echo "Kernel: $(uname -r)"
echo "Node.js: $(node --version 2>/dev/null || echo 'not installed')"
echo "Python: $(python3 --version 2>/dev/null || echo 'not installed')"
echo "OS: $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')"
echo "Hostname: $(hostname)"
echo "Architecture: $(uname -m)"
