#!/bin/bash

# next-day.sh - Calculate next occurrence of a specific day of week
# Usage: next-day.sh DAY [--from=YYYY-MM-DD] [--format=iso|human]

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
    echo "Usage: next-day.sh DAY [--from=YYYY-MM-DD] [--format=iso|human]" >&2
    echo "  DAY: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday (case-insensitive)" >&2
    echo "  --from: Optional start date (default: today)" >&2
    echo "  --format: iso (YYYY-MM-DD) or human (full date string)" >&2
    exit 1
fi

TARGET_DAY="$1"
FROM_DATE=""
FORMAT="iso"

# Parse optional flags
shift
while [ $# -gt 0 ]; do
    case "$1" in
        --from=*)
            FROM_DATE="${1#--from=}"
            ;;
        --format=*)
            FORMAT="${1#--format=}"
            if [[ ! "$FORMAT" =~ ^(iso|human)$ ]]; then
                echo "Invalid format. Use --format=iso or --format=human" >&2
                exit 1
            fi
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
    shift
done

# Default to today if no from date specified
if [ -z "$FROM_DATE" ]; then
    FROM_DATE=$(TZ="$TZ" $DATE_CMD +%Y-%m-%d)
fi

# Validate from date format
if ! [[ "$FROM_DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Invalid date format. Use YYYY-MM-DD" >&2
    exit 1
fi

# Validate from date is valid
if ! TZ="$TZ" $DATE_CMD -d "$FROM_DATE" >/dev/null 2>&1; then
    echo "Invalid date: $FROM_DATE" >&2
    exit 1
fi

# Normalize target day to lowercase for comparison
TARGET_DAY_LOWER=$(echo "$TARGET_DAY" | tr '[:upper:]' '[:lower:]')

# Map day names to numbers (1=Monday, 7=Sunday, per ISO 8601)
case "$TARGET_DAY_LOWER" in
    monday|mon)
        TARGET_DAY_NUM=1
        TARGET_DAY_NAME="Monday"
        ;;
    tuesday|tue)
        TARGET_DAY_NUM=2
        TARGET_DAY_NAME="Tuesday"
        ;;
    wednesday|wed)
        TARGET_DAY_NUM=3
        TARGET_DAY_NAME="Wednesday"
        ;;
    thursday|thu)
        TARGET_DAY_NUM=4
        TARGET_DAY_NAME="Thursday"
        ;;
    friday|fri)
        TARGET_DAY_NUM=5
        TARGET_DAY_NAME="Friday"
        ;;
    saturday|sat)
        TARGET_DAY_NUM=6
        TARGET_DAY_NAME="Saturday"
        ;;
    sunday|sun)
        TARGET_DAY_NUM=7
        TARGET_DAY_NAME="Sunday"
        ;;
    *)
        echo "Invalid day. Use Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, or Sunday" >&2
        exit 1
        ;;
esac

# Get current day of week number (1=Monday, 7=Sunday)
CURRENT_DAY_NUM=$(TZ="$TZ" $DATE_CMD -d "$FROM_DATE" +%u)

# Calculate days until next occurrence
if [ "$CURRENT_DAY_NUM" -eq "$TARGET_DAY_NUM" ]; then
    # Same day - return next week
    DAYS_UNTIL=7
else
    # Different day - calculate difference
    DAYS_UNTIL=$(( (TARGET_DAY_NUM - CURRENT_DAY_NUM + 7) % 7 ))
    if [ "$DAYS_UNTIL" -eq 0 ]; then
        DAYS_UNTIL=7
    fi
fi

# Calculate the next occurrence
NEXT_DATE=$(TZ="$TZ" $DATE_CMD -d "$FROM_DATE +$DAYS_UNTIL days" +%Y-%m-%d)

# Output in requested format
if [ "$FORMAT" = "iso" ]; then
    echo "$NEXT_DATE"
else
    # Human format: "Day of week, Month DD, YYYY"
    TZ="$TZ" $DATE_CMD -d "$NEXT_DATE" +"%A, %B %d, %Y"
fi
