#!/bin/bash
# Send daily_reflection message to roci-agent via Unix socket IPC
# For manual testing of daily reflection functionality

set -e

SOCKET_PATH="/var/run/roci/agent.sock"

# Check if socket exists
if [ ! -S "$SOCKET_PATH" ]; then
    echo "Error: Agent socket not found at $SOCKET_PATH"
    exit 1
fi

# Build JSON message with timestamp
TIMESTAMP=$(date -Iseconds)
MESSAGE='{"type":"daily_reflection","timestamp":"'"$TIMESTAMP"'"}'

# Calculate message length (4-byte big-endian prefix)
MSG_LEN=${#MESSAGE}

# Send length-prefixed message using Python for binary handling
python3 << EOF
import socket
import struct
import json

message = '$MESSAGE'
sock_path = '$SOCKET_PATH'

sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
sock.settimeout(600)  # 10 minute timeout for agent processing

try:
    sock.connect(sock_path)

    # Send length-prefixed message
    msg_bytes = message.encode('utf-8')
    length = struct.pack('>I', len(msg_bytes))
    sock.sendall(length + msg_bytes)

    # Read response length
    resp_len_data = sock.recv(4)
    if len(resp_len_data) < 4:
        print("Error: No response from agent")
        exit(1)

    resp_len = struct.unpack('>I', resp_len_data)[0]

    # Read response
    resp_data = b''
    while len(resp_data) < resp_len:
        chunk = sock.recv(resp_len - len(resp_data))
        if not chunk:
            break
        resp_data += chunk

    response = json.loads(resp_data.decode('utf-8'))
    print(f"Daily reflection response: {response.get('type', 'unknown')}")

    if response.get('type') == 'error':
        print(f"Error: {response.get('error')}")
        exit(1)

except socket.timeout:
    print("Error: Agent request timed out")
    exit(1)
except ConnectionRefusedError:
    print("Error: Could not connect to agent service")
    exit(1)
finally:
    sock.close()
EOF

echo "Daily reflection sent successfully at $TIMESTAMP"
