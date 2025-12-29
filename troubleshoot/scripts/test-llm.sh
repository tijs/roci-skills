#!/bin/bash
# Test Roci LLM gateway HTTP endpoints

set -e

VPS="roci"

echo "🌐 Testing LLM Gateway"
echo "======================"
echo ""

# Test roci-llm (Deno proxy on port 3000)
echo "Testing roci-llm (Deno proxy, port 3000)..."
LLM_RESULT=$(ssh ${VPS} 'curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/v1/models --max-time 5 2>/dev/null || echo "FAILED"')

if [ "$LLM_RESULT" = "FAILED" ]; then
    echo "❌ roci-llm: Connection failed (service may be down)"
    LLM_STATUS="FAIL"
elif [ "$LLM_RESULT" = "200" ] || [ "$LLM_RESULT" = "401" ]; then
    echo "✅ roci-llm: Responding (HTTP $LLM_RESULT)"
    LLM_STATUS="PASS"
else
    echo "⚠️  roci-llm: Unexpected response (HTTP $LLM_RESULT)"
    LLM_STATUS="WARN"
fi

echo ""

# Test roci-litellm (Python backend on port 8000)
echo "Testing roci-litellm (Python backend, port 8000)..."
LITELLM_RESULT=$(ssh ${VPS} 'curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/health --max-time 5 2>/dev/null || echo "FAILED"')

if [ "$LITELLM_RESULT" = "FAILED" ]; then
    echo "❌ roci-litellm: Connection failed (service may be down)"
    LITELLM_STATUS="FAIL"
elif [ "$LITELLM_RESULT" = "200" ]; then
    echo "✅ roci-litellm: Healthy (HTTP $LITELLM_RESULT)"
    LITELLM_STATUS="PASS"
else
    echo "⚠️  roci-litellm: Unexpected response (HTTP $LITELLM_RESULT)"
    LITELLM_STATUS="WARN"
fi

echo ""

# Check which processes are listening on the ports
echo "🔍 Port listeners:"
echo "------------------"
ssh ${VPS} 'sudo ss -tulnp | grep -E ":3000|:8000" || echo "No processes listening on ports 3000 or 8000"'

echo ""

# Check service status
echo "📊 Service status:"
echo "------------------"
ssh ${VPS} 'sudo systemctl status roci-llm roci-litellm --no-pager | grep -E "Active:|Loaded:" || true'

echo ""
echo "======================"

if [ "$LLM_STATUS" = "PASS" ] && [ "$LITELLM_STATUS" = "PASS" ]; then
    echo "✅ All LLM services working"
    exit 0
elif [ "$LLM_STATUS" = "FAIL" ] || [ "$LITELLM_STATUS" = "FAIL" ]; then
    echo "❌ Some LLM services failed"
    exit 1
else
    echo "⚠️  LLM services responding with warnings"
    exit 0
fi
