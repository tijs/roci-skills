#!/bin/bash
# Roci service status check script

echo "=== Roci Memory Service ==="
sudo systemctl status roci-memory --no-pager -l | head -20

echo ""
echo "=== Roci Agent Service ==="
sudo systemctl status roci-agent --no-pager -l | head -20

echo ""
echo "=== Roci Matrix Service ==="
sudo systemctl status roci-matrix --no-pager -l | head -20
