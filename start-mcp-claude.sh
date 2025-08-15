#!/bin/bash
# Script wrapper para MCP Sentry no Claude Code
# Baseado na solução que funcionou para o Turso

echo "🚀 Iniciando MCP Sentry para Claude Code..."

# Carregar variáveis do arquivo config.env
source "$(dirname "$0")/config.env"

# Exportar variáveis de ambiente necessárias
export SENTRY_DSN="$SENTRY_DSN"
export SENTRY_AUTH_TOKEN="$SENTRY_AUTH_TOKEN"
export SENTRY_ORG="$SENTRY_ORG"
export SENTRY_API_URL="$SENTRY_API_URL"
export SENTRY_RELEASE="$SENTRY_RELEASE"
export SENTRY_ENVIRONMENT="$SENTRY_ENVIRONMENT"

echo "📊 Configuração carregada:"
echo "  DSN: ${SENTRY_DSN:0:30}..."
echo "  Token: ${SENTRY_AUTH_TOKEN:0:20}..."
echo "  Org: $SENTRY_ORG"
echo "  API: $SENTRY_API_URL"

# Mudar para o diretório correto
cd "$(dirname "$0")"

# Verificar se o dist existe
if [ ! -f "dist/index.js" ]; then
    echo "⚠️  Arquivo dist/index.js não encontrado. Compilando..."
    npm run build
fi

# Iniciar o MCP diretamente com exec para propagar sinais
echo "🔧 Iniciando servidor MCP..."
exec node dist/index.js