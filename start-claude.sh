#!/bin/bash

# Definir variáveis de ambiente diretamente
export SENTRY_DSN="https://e12b9f457709c8e451398bb1b7d88924@o4509787137638400.ingest.us.sentry.io/4509845941911552"
export SENTRY_AUTH_TOKEN="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"
export SENTRY_ORG="game-bx"
export SENTRY_API_URL="https://sentry.io/api/0"
export SENTRY_RELEASE="mahjong-solitaire@2.0.0"
export SENTRY_ENVIRONMENT="development"

# Executar o servidor MCP
exec node /Users/agents/Desktop/game-collection/.conductor/curitiba/sentry-mcp-cursor/dist/index.js