#!/usr/bin/env bash

cd "$(dirname "$0")" || exit 1
uv run server.py --port 47700
