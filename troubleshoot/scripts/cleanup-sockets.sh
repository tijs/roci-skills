#!/bin/bash
# Clean up stale Unix socket files in /var/run/roci/
# CAUTION: Only run when Roci services are stopped!

set -e

VPS="roci"
SOCKET_DIR="/var/run/roci"

echo "🧹 Roci Socket Cleanup"
echo "======================"
echo ""

# Safety check: verify services are stopped
echo "⚠️  SAFETY CHECK: Verifying services are stopped..."
echo ""

SERVICES=(roci-memory roci-agent roci-matrix roci-rag)
RUNNING=()

for service in "${SERVICES[@]}"; do
    if ssh ${VPS} "sudo systemctl is-active $service --quiet 2>/dev/null"; then
        RUNNING+=("$service")
    fi
done

if [ ${#RUNNING[@]} -gt 0 ]; then
    echo "❌ ERROR: The following services are still running:"
    for service in "${RUNNING[@]}"; do
        echo "   - $service"
    done
    echo ""
    echo "Please stop all services first:"
    echo "  ssh $VPS 'sudo systemctl stop roci-matrix roci-agent roci-rag roci-memory'"
    echo ""
    exit 1
fi

echo "✅ All services stopped. Safe to proceed."
echo ""

# List current sockets
echo "📁 Current socket files:"
ssh ${VPS} "ls -la ${SOCKET_DIR}/ 2>/dev/null || echo 'Directory empty or does not exist'"
echo ""

# Check for orphaned sockets (no process listening)
echo "🔍 Checking for orphaned sockets..."
ORPHANED=$(ssh ${VPS} "for sock in ${SOCKET_DIR}/*.sock 2>/dev/null; do
    if [ -S \"\$sock\" ]; then
        if ! lsof \"\$sock\" >/dev/null 2>&1; then
            basename \"\$sock\"
        fi
    fi
done")

if [ -z "$ORPHANED" ]; then
    echo "No orphaned sockets found."
    echo ""
else
    echo "Found orphaned sockets:"
    echo "$ORPHANED" | while read sock; do echo "   - $sock"; done
    echo ""
fi

# Prompt for confirmation
read -p "Remove all .sock files from ${SOCKET_DIR}? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

# Remove socket files
echo "Removing socket files..."
ssh ${VPS} "rm -f ${SOCKET_DIR}/*.sock"

echo ""
echo "✅ Socket cleanup complete"
echo ""

# Verify cleanup
echo "📁 Socket directory after cleanup:"
ssh ${VPS} "ls -la ${SOCKET_DIR}/ 2>/dev/null || echo 'Directory empty'"
echo ""

echo "You can now restart services:"
echo "  bash /home/tijs/roci/scripts/restart.sh all"
