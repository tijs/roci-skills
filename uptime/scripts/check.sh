#!/bin/bash
# Uptime and resource check script

echo "=== Uptime ==="
uptime

echo ""
echo "=== Memory Usage ==="
free -h

echo ""
echo "=== Disk Usage ==="
df -h /
