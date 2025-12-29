#!/bin/bash
# Check status of Roci systemd timers

VPS="roci"

echo "⏰ Roci Timer Status"
echo "===================="
echo ""

echo "📅 Watch Timer (2-hour intervals):"
echo "-----------------------------------"
ssh ${VPS} 'systemctl list-timers roci-watch.timer --no-pager'
echo ""

echo "📊 Watch Timer Details:"
ssh ${VPS} 'systemctl status roci-watch.timer --no-pager | head -20'
echo ""

echo "📅 Daily Reflection Timer (23:00 daily):"
echo "-----------------------------------------"
ssh ${VPS} 'systemctl list-timers roci-reflect-daily.timer --no-pager'
echo ""

echo "📊 Reflection Timer Details:"
ssh ${VPS} 'systemctl status roci-reflect-daily.timer --no-pager | head -20'
echo ""

echo "📋 Timer Configuration:"
echo "----------------------"
echo "Watch: OnCalendar=*-*-* 00/2:00:00 (every 2 hours)"
echo "Reflect: OnCalendar=*-*-* 23:00:00 (daily at 11 PM)"
echo "Both: Persistent=true (catch up if missed)"
echo ""

echo "🔍 Recent Timer Executions:"
echo "---------------------------"
echo "Watch service (last 5 runs):"
ssh ${VPS} 'sudo journalctl -u roci-watch.service -n 5 --no-pager --output=short-iso'
echo ""
echo "Reflection service (last 3 runs):"
ssh ${VPS} 'sudo journalctl -u roci-reflect-daily.service -n 3 --no-pager --output=short-iso'
