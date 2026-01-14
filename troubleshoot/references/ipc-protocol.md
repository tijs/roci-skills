# Roci IPC Protocol Reference

Reference documentation for Roci's Unix socket IPC protocol and manual testing.

## Protocol Overview

All Roci services use Unix domain sockets with a **4-byte big-endian length
prefix** protocol:

```
[4 bytes: message length][N bytes: JSON message]
```

- **Length prefix:** 4 bytes, big-endian unsigned integer
- **Message:** UTF-8 encoded JSON
- **Socket type:** `SOCK_STREAM` (connection-oriented)

## Socket Locations

| Service | Socket Path                 | Role                                |
| ------- | --------------------------- | ----------------------------------- |
| Memory  | `/var/run/roci/memory.sock` | Server                              |
| Agent   | `/var/run/roci/agent.sock`  | Server + Client (to memory, matrix) |
| Matrix  | `/var/run/roci/matrix.sock` | Server                              |
| RAG     | `/var/run/roci/rag.sock`    | Server                              |

## Manual Testing

**⚠️ Important:** Standard `nc` (netcat) doesn't handle the 4-byte length prefix
correctly. Use the provided test scripts or Python for manual testing.

### Using test-ipc.sh (Recommended)

```bash
# Test all IPC connections
bash /home/tijs/roci/skills/troubleshoot/scripts/test-ipc.sh
```

### Using Python (Advanced)

```python
import socket
import struct
import json

# Connect to socket
sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
sock.connect('/var/run/roci/memory.sock')

# Build message
message = json.dumps({"action": "getMemory"})
msg_bytes = message.encode('utf-8')

# Send with length prefix
length = struct.pack('>I', len(msg_bytes))  # Big-endian 4-byte length
sock.sendall(length + msg_bytes)

# Read response length
resp_len_data = sock.recv(4)
resp_len = struct.unpack('>I', resp_len_data)[0]

# Read response
resp_data = b''
while len(resp_data) < resp_len:
    chunk = sock.recv(resp_len - len(resp_data))
    if not chunk:
        break
    resp_data += chunk

response = json.loads(resp_data.decode('utf-8'))
print(json.dumps(response, indent=2))

sock.close()
```

## Memory Service IPC

**Socket:** `/var/run/roci/memory.sock`

### getMemory

Retrieve complete memory context (Letta blocks + state files + journal).

**Request:**

```json
{
  "action": "getMemory"
}
```

**Response:**

```json
{
  "letta": {
    "persona": "...",
    "human": "...",
    "patterns": "..."
  },
  "state": {
    "inbox": "...",
    "today": "...",
    "commitments": "...",
    "patterns": "..."
  },
  "journal": "last 40 entries..."
}
```

---

### updateBlock

Update a specific Letta memory block.

**Request:**

```json
{
  "action": "updateBlock",
  "block": "patterns",
  "content": "Updated patterns content..."
}
```

**Response:**

```json
{
  "success": true
}
```

**Block names:** `persona`, `human`, `patterns`

---

### logJournal

Log an entry to journal.jsonl.

**Request:**

```json
{
  "action": "logJournal",
  "topics": ["calendar", "deadline"],
  "user_stated": "User mentioned needing to finish report by Friday",
  "my_intent": "Added deadline to commitments.md, scheduled reminder for Thursday"
}
```

**Response:**

```json
{
  "success": true,
  "entry": {
    "t": "2025-12-29T14:30:00Z",
    "topics": ["calendar", "deadline"],
    "user_stated": "...",
    "my_intent": "..."
  }
}
```

**Journal format:** 4-field JSONL (t, topics, user_stated, my_intent)

---

### syncATProtoRecords

Sync ATProto records to cache (for calendar integration).

**Request:**

```json
{
  "action": "syncATProtoRecords",
  "lexicon": "pub.leaflet.document"
}
```

**Response:**

```json
{
  "synced": 42,
  "errors": []
}
```

---

## RAG Service IPC

**Socket:** `/var/run/roci/rag.sock`

### search

Semantic search across indexed documents.

**Request:**

```json
{
  "action": "search",
  "query": "deployment procedures",
  "limit": 5,
  "project": "work"
}
```

**Response:**

```json
{
  "results": [
    {
      "text": "chunk text...",
      "score": 0.92,
      "sourcePath": "/path/to/document.pdf",
      "metadata": { "page": 1 },
      "project": "work"
    }
  ]
}
```

---

### ingest

Ingest a document for indexing.

**Request:**

```json
{
  "action": "ingest",
  "path": "/var/lib/roci/tmp-images/document.pdf",
  "project": "work",
  "force": false
}
```

**Response:**

```json
{
  "chunksCreated": 45,
  "errors": []
}
```

**Supported formats:** PDF, DOCX, Markdown

---

### listProjects

List available project namespaces.

**Request:**

```json
{
  "action": "listProjects"
}
```

**Response:**

```json
{
  "projects": ["work", "personal", "research"]
}
```

---

## Agent Service IPC

**Socket:** `/var/run/roci/agent.sock`

### watch_tick

Trigger autonomous watch rotation (sent by systemd timer).

**Request:**

```json
{
  "type": "watch_tick",
  "timestamp": "2025-12-29T14:00:00Z"
}
```

**Response:**

```json
{
  "type": "agent_response",
  "timestamp": "2025-12-29T14:05:00Z"
}
```

---

### daily_reflection

Trigger daily reflection (sent by systemd timer).

**Request:**

```json
{
  "type": "daily_reflection",
  "timestamp": "2025-12-29T23:00:00Z"
}
```

**Response:**

```json
{
  "type": "agent_response",
  "timestamp": "2025-12-29T23:05:00Z"
}
```

---

### user_message

User message from Matrix (sent by roci-matrix).

**Request:**

```json
{
  "type": "user_message",
  "message_id": "event_id",
  "user_id": "@tijs:hamster.farm",
  "room_id": "!room:hamster.farm",
  "content": "Message text",
  "timestamp": "2025-12-29T14:00:00Z"
}
```

**Response:**

```json
{
  "type": "agent_response",
  "message_id": "event_id",
  "content": "AI response text",
  "actions": [],
  "timestamp": "2025-12-29T14:00:05Z"
}
```

---

## Matrix Service IPC

**Socket:** `/var/run/roci/matrix.sock`

### proactive_message

Proactive message from agent (e.g., watch rotation update).

**Request:**

```json
{
  "type": "proactive_message",
  "user_id": "@tijs:hamster.farm",
  "room_id": "!room:hamster.farm",
  "content": "Proactive message text",
  "trigger": "watch_rotation",
  "timestamp": "2025-12-29T14:30:00Z"
}
```

**Response:**

```json
{
  "type": "success",
  "event_id": "sent_event_id"
}
```

---

## Error Responses

All services may return error responses:

```json
{
  "type": "error",
  "error": "Error description",
  "code": "ERROR_CODE"
}
```

**Common error codes:**

- `INVALID_MESSAGE` - Malformed JSON or missing fields
- `ACTION_NOT_FOUND` - Unknown action type
- `TIMEOUT` - Operation timed out
- `SERVICE_UNAVAILABLE` - Dependent service not reachable

---

## Testing Scripts

### Test all IPC connections

```bash
bash /home/tijs/roci/skills/troubleshoot/scripts/test-ipc.sh
```

### Manually trigger watch tick

```bash
bash /home/tijs/roci/scripts/watch-tick.sh
```

### Manually trigger daily reflection

```bash
bash /home/tijs/roci/skills/troubleshoot/scripts/trigger-reflect.sh
```

---

## Protocol Design Rationale

**Why 4-byte length prefix?**

- Allows variable-length messages without delimiters
- Prevents message framing issues (embedded newlines, etc.)
- Standard practice for length-prefixed protocols

**Why big-endian?**

- Network byte order convention
- Consistent across different architectures

**Why SOCK_STREAM?**

- Reliable, ordered delivery
- Connection-oriented (know when client disconnects)
- Built-in flow control

---

## Debugging Tips

### Check if socket exists

```bash
ssh roci 'test -S /var/run/roci/memory.sock && echo "Exists"'
```

### Check socket permissions

```bash
ssh roci 'ls -la /var/run/roci/memory.sock'
```

Should show `srwxr-xr-x` owned by `tijs`.

### Check which process is listening

```bash
ssh roci 'lsof /var/run/roci/memory.sock'
```

### Monitor socket traffic (requires socat)

```bash
# Proxy socket to see traffic
ssh roci 'socat -v UNIX-LISTEN:/tmp/test.sock,fork UNIX-CONNECT:/var/run/roci/memory.sock'
```

### Test with timeout

```python
sock.settimeout(5)  # 5 second timeout
try:
    sock.connect('/var/run/roci/memory.sock')
except socket.timeout:
    print("Connection timed out")
```
