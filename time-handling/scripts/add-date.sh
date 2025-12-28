#!/bin/bash

# add-date.sh - Add or subtract days/weeks/months from a date
# Usage: add-date.sh DATE AMOUNT UNIT [--format=iso|human]

set -euo pipefail

TZ=Europe/Amsterdam

# Use gdate on macOS (from coreutils), date on Linux
if command -v gdate >/dev/null 2>&1; then
    DATE_CMD="gdate"
else
    DATE_CMD="date"
fi

# Check arguments
if [ $# -lt 3 ]; then
    echo "Usage: add-date.sh DATE AMOUNT UNIT [--format=iso|human]" >&2
    echo "  DATE: YYYY-MM-DD" >&2
    echo "  AMOUNT: integer (can be negative)" >&2
    echo "  UNIT: days, weeks, or months" >&2
    exit 1
fi

DATE="$1"
AMOUNT="$2"
UNIT="$3"
FORMAT="iso"

# Parse optional format flag
if [ $# -eq 4 ]; then
    if [[ "$4" =~ ^--format=(iso|human)$ ]]; then
        FORMAT="${BASH_REMATCH[1]}"
    else
        echo "Invalid format. Use --format=iso or --format=human" >&2
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

# Validate amount is an integer
if ! [[ "$AMOUNT" =~ ^-?[0-9]+$ ]]; then
    echo "Amount must be an integer" >&2
    exit 1
fi

# Validate unit
if [[ ! "$UNIT" =~ ^(days?|weeks?|months?)$ ]]; then
    echo "Invalid unit. Use days, weeks, or months" >&2
    exit 1
fi

# Normalize unit to singular for date command
case "$UNIT" in
    days|day)
        UNIT="days"
        ;;
    weeks|week)
        UNIT="weeks"
        ;;
    months|month)
        UNIT="months"
        ;;
esac

# Calculate new date
if [ "$AMOUNT" -ge 0 ]; then
    NEW_DATE=$(TZ="$TZ" $DATE_CMD -d "$DATE +$AMOUNT $UNIT" +%Y-%m-%d 2>&1) || {
        echo "Failed to calculate new date" >&2
        exit 1
    }
else
    # For negative amounts, remove the minus sign and use "ago"
    POSITIVE_AMOUNT=$((AMOUNT * -1))
    NEW_DATE=$(TZ="$TZ" $DATE_CMD -d "$DATE -$POSITIVE_AMOUNT $UNIT" +%Y-%m-%d 2>&1) || {
        echo "Failed to calculate new date" >&2
        exit 1
    }
fi

# Output in requested format
if [ "$FORMAT" = "iso" ]; then
    echo "$NEW_DATE"
else
    # Human format: "Day of week, Month DD, YYYY"
    TZ="$TZ" $DATE_CMD -d "$NEW_DATE" +"%A, %B %d, %Y"
fi
