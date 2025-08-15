#!/bin/bash

echo "🧪 Testando MCP Sentry no Claude Code"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Teste 1: Listar projetos
echo -e "\n📊 Teste 1: Listando projetos..."
RESULT=$(echo '{"jsonrpc": "2.0", "id": 1, "method": "tools/call", "params": {"name": "sentry_list_projects", "arguments": {}}}' | ./start.sh 2>/dev/null)
if echo "$RESULT" | grep -q "javascript-vue"; then
    echo "✅ Projetos listados com sucesso"
    echo "$RESULT" | jq -r '.result.content[0].text' 2>/dev/null | head -3
else
    echo "❌ Erro ao listar projetos"
fi

# Teste 2: Capturar mensagem
echo -e "\n📤 Teste 2: Enviando mensagem de teste..."
RESULT=$(echo '{"jsonrpc": "2.0", "id": 2, "method": "tools/call", "params": {"name": "sentry_capture_message", "arguments": {"message": "Teste Claude Code MCP", "level": "info"}}}' | ./start.sh 2>/dev/null)
if echo "$RESULT" | grep -q "captured"; then
    echo "✅ Mensagem enviada com sucesso"
else
    echo "❌ Erro ao enviar mensagem"
fi

# Teste 3: Listar issues
echo -e "\n🐛 Teste 3: Listando issues..."
RESULT=$(echo '{"jsonrpc": "2.0", "id": 3, "method": "tools/call", "params": {"name": "sentry_list_issues", "arguments": {"projectSlug": "javascript-vue", "query": "is:unresolved"}}}' | ./start.sh 2>/dev/null)
if echo "$RESULT" | grep -q "Found"; then
    echo "✅ Issues listadas com sucesso"
    echo "$RESULT" | jq -r '.result.content[0].text' 2>/dev/null | head -5
else
    echo "❌ Erro ao listar issues"
fi

echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Teste concluído!"