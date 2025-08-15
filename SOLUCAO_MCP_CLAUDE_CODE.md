# Solução para Conexão do Sentry MCP no Claude Code

## 🔴 Problema Identificado

O Sentry MCP estava falhando ao conectar no Claude Code com a mensagem:
```
sentry    ✘ failed · Enter to view details
```

### Causas do Problema

1. **Variáveis de ambiente não propagadas**: O Claude Code não estava recebendo as variáveis de ambiente necessárias para autenticação
2. **Script wrapper inicial não funcionava**: O arquivo `start-mcp-claude.sh` que usava `source config.env` não estava propagando corretamente as variáveis
3. **Comando `-e` do MCP add com problemas**: Tentativa de passar variáveis inline com `-e` não funcionou corretamente

## ✅ Solução Aplicada

### 1. Criação de Script Simplificado

Criado novo arquivo `/start-claude.sh` com variáveis hardcoded:

```bash
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
```

### 2. Configuração no Claude Code

```bash
# Tornar script executável
chmod +x /Users/agents/Desktop/game-collection/.conductor/curitiba/sentry-mcp-cursor/start-claude.sh

# Remover configurações anteriores que falharam
claude mcp remove sentry -s user
claude mcp remove sentry -s local

# Adicionar com novo script no escopo global
claude mcp add -s user sentry /Users/agents/Desktop/game-collection/.conductor/curitiba/sentry-mcp-cursor/start-claude.sh
```

### 3. Verificação de Sucesso

```bash
claude mcp list
```

Resultado:
```
Checking MCP server health...

context7: npx -y @upstash/context7-mcp@latest - ✓ Connected
sentry: /Users/agents/Desktop/game-collection/.conductor/curitiba/sentry-mcp-cursor/start-claude.sh  - ✓ Connected
```

## 📝 Diferenças Entre as Abordagens

### ❌ Abordagem que Falhou

1. **Script com source de arquivo externo**:
   - Usava `source config.env` 
   - Claude Code não propagava corretamente as variáveis

2. **Variáveis inline com -e**:
   - Comando: `claude mcp add -e VAR=value`
   - As variáveis não eram passadas corretamente para o processo Node

### ✅ Abordagem que Funcionou

1. **Variáveis hardcoded no script**:
   - Todas as variáveis definidas diretamente com `export`
   - Garantia de que as variáveis estariam disponíveis

2. **Uso de exec para propagar sinais**:
   - `exec node` garante que o processo Node receba os sinais corretamente
   - Importante para o lifecycle do MCP

3. **Escopo global com -s user**:
   - Disponível em todos os projetos
   - Não precisa reconfigurar por projeto

## 🔧 Estrutura Final

```
sentry-mcp-cursor/
├── start-claude.sh      # Script específico para Claude Code (FUNCIONANDO)
├── start-mcp-claude.sh   # Script anterior que falhou
├── start-cursor.sh       # Script para Cursor IDE (funciona diferente)
├── config.env           # Arquivo de configuração (não usado no Claude Code)
└── dist/
    └── index.js         # Servidor MCP compilado
```

## 💡 Lições Aprendidas

1. **Claude Code tem limitações com variáveis de ambiente**: Diferente do Cursor, o Claude Code não propaga bem variáveis de arquivos externos
2. **Simplicidade é chave**: Script simples com valores hardcoded funcionou melhor que soluções complexas
3. **Exec é importante**: Usar `exec` garante propagação correta de sinais
4. **Caminho absoluto necessário**: Sempre usar caminhos absolutos no Claude Code

## 🚀 Como Usar

Agora o Sentry MCP está disponível globalmente. Você pode usar comandos como:

```bash
# No Claude Code, os comandos MCP do Sentry estarão disponíveis
# Exemplo: listar projetos, buscar issues, etc.
```

## 📌 Nota Importante

Esta solução é específica para o Claude Code. O Cursor IDE usa uma abordagem diferente com o arquivo `start-cursor.sh` que funciona corretamente com `source config.env`.

---

**Status Final**: ✅ Sentry MCP conectado e funcionando no Claude Code