#!/bin/bash

# age.sh - Calculate age from birthdate
# Usage: age.sh YYYY-MM-DD [--format=years|full]

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
    echo "Usage: age.sh YYYY-MM-DD [--format=years|full]" >&2
    exit 1
fi

BIRTHDATE="$1"
FORMAT="years"

# Parse optional format flag
if [ $# -eq 2 ]; then
    if [[ "$2" =~ ^--format=(years|full)$ ]]; then
        FORMAT="${BASH_REMATCH[1]}"
    else
        echo "Invalid format. Use --format=years or --format=full" >&2
        exit 1
    fi
fi

# Validate date format
if ! [[ "$BIRTHDATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Invalid date format. Use YYYY-MM-DD" >&2
    exit 1
fi

# Validate date is valid
if ! TZ="$TZ" $DATE_CMD -d "$BIRTHDATE" >/dev/null 2>&1; then
    echo "Invalid date. Use YYYY-MM-DD" >&2
    exit 1
fi

# Check if birthdate is in the future
BIRTH_EPOCH=$(TZ="$TZ" $DATE_CMD -d "$BIRTHDATE" +%s)
NOW_EPOCH=$(TZ="$TZ" $DATE_CMD +%s)

if [ "$BIRTH_EPOCH" -gt "$NOW_EPOCH" ]; then
    echo "Birthdate cannot be in the future" >&2
    exit 1
fi

# Extract birth components
BIRTH_YEAR=$(TZ="$TZ" $DATE_CMD -d "$BIRTHDATE" +%Y)
BIRTH_MONTH=$(TZ="$TZ" $DATE_CMD -d "$BIRTHDATE" +%-m)
BIRTH_DAY=$(TZ="$TZ" $DATE_CMD -d "$BIRTHDATE" +%-d)

# Extract current components
NOW_YEAR=$(TZ="$TZ" $DATE_CMD +%Y)
NOW_MONTH=$(TZ="$TZ" $DATE_CMD +%-m)
NOW_DAY=$(TZ="$TZ" $DATE_CMD +%-d)

# Calculate years
YEARS=$((NOW_YEAR - BIRTH_YEAR))

# Adjust if birthday hasn't occurred yet this year
if [ "$NOW_MONTH" -lt "$BIRTH_MONTH" ] || \
   ([ "$NOW_MONTH" -eq "$BIRTH_MONTH" ] && [ "$NOW_DAY" -lt "$BIRTH_DAY" ]); then
    YEARS=$((YEARS - 1))
fi

if [ "$FORMAT" = "years" ]; then
    echo "$YEARS years old"
else
    # Calculate months and days for full format

    # Adjust months
    MONTHS=$((NOW_MONTH - BIRTH_MONTH))
    if [ "$MONTHS" -lt 0 ]; then
        MONTHS=$((MONTHS + 12))
    fi

    # Adjust days
    DAYS=$((NOW_DAY - BIRTH_DAY))
    if [ "$DAYS" -lt 0 ]; then
        MONTHS=$((MONTHS - 1))
        if [ "$MONTHS" -lt 0 ]; then
            MONTHS=11
            YEARS=$((YEARS - 1))
        fi

        # Days in previous month
        PREV_MONTH=$((NOW_MONTH - 1))
        if [ "$PREV_MONTH" -eq 0 ]; then
            PREV_MONTH=12
        fi
        DAYS_IN_PREV=$(TZ="$TZ" $DATE_CMD -d "${NOW_YEAR}-${PREV_MONTH}-01 +1 month -1 day" +%-d)
        DAYS=$((DAYS + DAYS_IN_PREV))
    fi

    echo "$YEARS years, $MONTHS months, $DAYS days"
fi
