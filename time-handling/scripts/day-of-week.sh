#!/bin/bash

# day-of-week.sh - Get day of week for a date
# Usage: day-of-week.sh DATE [--format=short|full]

set -euo pipefail

TZ=Europe/Amsterdam

# Use gdate on macOS (from coreutils), date on Linux
if command -v gdate >/dev/null 2>&1; then
    DATE_CMD="gdate"
else
    DATE_CMD="date"
fi

# Check arguments
if [ $# -lt 1 ]; then
    echo "Usage: day-of-week.sh DATE [--format=short|full]" >&2
    exit 1
fi

DATE="$1"
FORMAT="default"

# Parse optional format flag
if [ $# -eq 2 ]; then
    if [[ "$2" =~ ^--format=(short|full)$ ]]; then
        FORMAT="${BASH_REMATCH[1]}"
    else
        echo "Invalid format. Use --format=short or --format=full" >&2
        exit 1
    fi
fi

# Validate date format
if ! [[ "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Invalid date format. Use YYYY-MM-DD" >&2
    exit 1
fi

# Validate date is valid
if ! TZ="$TZ" $DATE_CMD -d "$DATE" >/dev/null 2>&1; then
    echo "Invalid date. Use YYYY-MM-DD" >&2
    exit 1
fi

# Output in requested format
case "$FORMAT" in
    short)
        TZ="$TZ" $DATE_CMD -d "$DATE" +%a
        ;;
    full)
        TZ="$TZ" $DATE_CMD -d "$DATE" +"%A, %B %d, %Y"
        ;;
    *)
        TZ="$TZ" $DATE_CMD -d "$DATE" +%A
        ;;
esac
