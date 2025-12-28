#!/bin/bash

# duration.sh - Calculate duration between two dates
# Usage: duration.sh DATE1 DATE2 [--format=days|weeks|human]

set -euo pipefail

TZ=Europe/Amsterdam

# Use gdate on macOS (from coreutils), date on Linux
if command -v gdate >/dev/null 2>&1; then
    DATE_CMD="gdate"
else
    DATE_CMD="date"
fi

# Check arguments
if [ $# -lt 2 ]; then
    echo "Usage: duration.sh DATE1 DATE2 [--format=days|weeks|human]" >&2
    exit 1
fi

DATE1="$1"
DATE2="$2"
FORMAT="days"

# Parse optional format flag
if [ $# -eq 3 ]; then
    if [[ "$3" =~ ^--format=(days|weeks|human)$ ]]; then
        FORMAT="${BASH_REMATCH[1]}"
    else
        echo "Invalid format. Use --format=days, --format=weeks, or --format=human" >&2
        exit 1
    fi
fi

# Validate date formats
if ! [[ "$DATE1" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Invalid DATE1 format. Use YYYY-MM-DD" >&2
    exit 1
fi

if ! [[ "$DATE2" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Invalid DATE2 format. Use YYYY-MM-DD" >&2
    exit 1
fi

# Validate dates are valid
if ! TZ="$TZ" $DATE_CMD -d "$DATE1" >/dev/null 2>&1; then
    echo "Invalid DATE1. Use YYYY-MM-DD" >&2
    exit 1
fi

if ! TZ="$TZ" $DATE_CMD -d "$DATE2" >/dev/null 2>&1; then
    echo "Invalid DATE2. Use YYYY-MM-DD" >&2
    exit 1
fi

# Convert to epoch seconds
EPOCH1=$(TZ="$TZ" $DATE_CMD -d "$DATE1" +%s)
EPOCH2=$(TZ="$TZ" $DATE_CMD -d "$DATE2" +%s)

# Calculate difference in seconds
DIFF_SECONDS=$((EPOCH2 - EPOCH1))

# Calculate days (can be negative)
DAYS=$((DIFF_SECONDS / 86400))

if [ "$FORMAT" = "days" ]; then
    if [ "$DAYS" -eq 1 ]; then
        echo "1 day"
    elif [ "$DAYS" -eq -1 ]; then
        echo "-1 day"
    else
        echo "$DAYS days"
    fi
elif [ "$FORMAT" = "weeks" ]; then
    WEEKS=$((DAYS / 7))
    if [ "$WEEKS" -eq 1 ]; then
        echo "1 week"
    elif [ "$WEEKS" -eq -1 ]; then
        echo "-1 week"
    else
        echo "$WEEKS weeks"
    fi
else
    # Human format: months and days breakdown
    # Handle negative durations
    SIGN=""
    if [ "$DAYS" -lt 0 ]; then
        SIGN="-"
        DAYS=$((DAYS * -1))
        # Swap dates for calculation
        TEMP="$DATE1"
        DATE1="$DATE2"
        DATE2="$TEMP"
    fi

    # Extract date components
    YEAR1=$(TZ="$TZ" $DATE_CMD -d "$DATE1" +%Y)
    MONTH1=$(TZ="$TZ" $DATE_CMD -d "$DATE1" +%-m)
    DAY1=$(TZ="$TZ" $DATE_CMD -d "$DATE1" +%-d)

    YEAR2=$(TZ="$TZ" $DATE_CMD -d "$DATE2" +%Y)
    MONTH2=$(TZ="$TZ" $DATE_CMD -d "$DATE2" +%-m)
    DAY2=$(TZ="$TZ" $DATE_CMD -d "$DATE2" +%-d)

    # Calculate months
    MONTHS=$(((YEAR2 - YEAR1) * 12 + MONTH2 - MONTH1))

    # Calculate remaining days
    REMAINING_DAYS=$((DAY2 - DAY1))
    if [ "$REMAINING_DAYS" -lt 0 ]; then
        MONTHS=$((MONTHS - 1))
        # Days in previous month
        PREV_MONTH=$((MONTH2 - 1))
        PREV_YEAR=$YEAR2
        if [ "$PREV_MONTH" -eq 0 ]; then
            PREV_MONTH=12
            PREV_YEAR=$((PREV_YEAR - 1))
        fi
        DAYS_IN_PREV=$(TZ="$TZ" $DATE_CMD -d "${PREV_YEAR}-${PREV_MONTH}-01 +1 month -1 day" +%-d)
        REMAINING_DAYS=$((REMAINING_DAYS + DAYS_IN_PREV))
    fi

    # Build output
    OUTPUT=""
    if [ "$MONTHS" -gt 0 ]; then
        if [ "$MONTHS" -eq 1 ]; then
            OUTPUT="1 month"
        else
            OUTPUT="$MONTHS months"
        fi
    fi

    if [ "$REMAINING_DAYS" -gt 0 ]; then
        if [ -n "$OUTPUT" ]; then
            OUTPUT="$OUTPUT, "
        fi
        if [ "$REMAINING_DAYS" -eq 1 ]; then
            OUTPUT="${OUTPUT}1 day"
        else
            OUTPUT="${OUTPUT}${REMAINING_DAYS} days"
        fi
    fi

    if [ -z "$OUTPUT" ]; then
        OUTPUT="0 days"
    fi

    echo "${SIGN}${OUTPUT}"
fi
