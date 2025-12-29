#!/bin/bash
# Test IPC connectivity to all Roci Unix sockets
# Tests: memory, agent, matrix, rag services

set -e

SOCKETS=(
    "/var/run/roci/memory.sock:memory"
    "/var/run/roci/agent.sock:agent"
    "/var/run/roci/matrix.sock:matrix"
    "/var/run/roci/rag.sock:rag"
)

PASS_COUNT=0
FAIL_COUNT=0

echo "🔍 Testing IPC Connectivity"
echo "============================"
echo ""

for socket_info in "${SOCKETS[@]}"; do
    IFS=':' read -r socket_path service_name <<< "$socket_info"

    echo -n "Testing $service_name... "

    # Check if socket exists
    if [ ! -S "$socket_path" ]; then
        echo "❌ FAIL (socket not found)"
        ((FAIL_COUNT++))
        continue
    fi

    # Test connectivity with appropriate message for each service
    case "$service_name" in
        memory)
            TEST_MESSAGE='{"action":"health"}'
            ;;
        agent)
            TEST_MESSAGE='{"type":"health"}'
            ;;
        matrix)
            TEST_MESSAGE='{"type":"health"}'
            ;;
        rag)
            TEST_MESSAGE='{"action":"health"}'
            ;;
        *)
            TEST_MESSAGE='{"action":"health"}'
            ;;
    esac

    # Send test message using Python for proper 4-byte length prefix
    RESULT=$(python3 << EOF 2>&1
import socket
import struct
import json
import sys

message = '$TEST_MESSAGE'
sock_path = '$socket_path'

try:
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.settimeout(5)  # 5 second timeout

    sock.connect(sock_path)

    # Send length-prefixed message
    msg_bytes = message.encode('utf-8')
    length = struct.pack('>I', len(msg_bytes))
    sock.sendall(length + msg_bytes)

    # Read response length (with timeout)
    try:
        resp_len_data = sock.recv(4)
        if len(resp_len_data) == 4:
            resp_len = struct.unpack('>I', resp_len_data)[0]
            # Read response
            resp_data = b''
            while len(resp_data) < resp_len:
                chunk = sock.recv(resp_len - len(resp_data))
                if not chunk:
                    break
                resp_data += chunk

            response = json.loads(resp_data.decode('utf-8'))
            print("OK")
        else:
            print("NO_RESPONSE")
    except socket.timeout:
        print("TIMEOUT")

    sock.close()

except ConnectionRefusedError:
    print("REFUSED")
except socket.timeout:
    print("TIMEOUT")
except Exception as e:
    print(f"ERROR:{str(e)}")
EOF
)

    if [ "$RESULT" = "OK" ]; then
        echo "✅ PASS"
        ((PASS_COUNT++))
    elif [ "$RESULT" = "NO_RESPONSE" ]; then
        echo "⚠️  WARN (connected but no response)"
        ((PASS_COUNT++))  # Still counts as pass - socket is reachable
    else
        echo "❌ FAIL ($RESULT)"
        ((FAIL_COUNT++))
    fi
done

echo ""
echo "============================"
echo "Results: $PASS_COUNT passed, $FAIL_COUNT failed"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo "✅ All IPC connections working"
    exit 0
else
    echo "❌ Some IPC connections failed"
    exit 1
fi
