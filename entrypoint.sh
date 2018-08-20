#!/bin/bash
set -e

if [ "$1" = 'sam-check' ]; then
    exec /app/sam-check
fi

exec "$@"
