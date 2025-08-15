# 🔧 Resolução do Problema: Sentry MCP no Claude Code

## 📋 Problema Identificado

O Sentry MCP estava aparecendo como **"✘ failed"** no Claude Code, mesmo após várias tentativas de configuração. O erro ocorria porque:

1. **Variáveis de ambiente não eram carregadas corretamente** - O Claude Code não processava o arquivo `config.env` como esperado
2. **Script wrapper original tinha problemas de execução** - O método `source` para carregar variáveis não funcionava adequadamente no contexto do MCP
3. **Flags de variáveis de ambiente (-e) não eram persistidas** - Ao usar `-e` no comando `claude mcp add`, as variáveis não eram salvas corretamente

## ✅ Solução Implementada

### 1. Criação de Script Simplificado

Criamos um novo script `/start-claude.sh` com as variáveis hardcoded:

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

### 2. Configuração Global do MCP

```bash
# Remover configurações anteriores conflitantes
claude mcp remove sentry -s user
claude mcp remove sentry -s local

# Adicionar com script simplificado no escopo global
claude mcp add -s user sentry /Users/agents/Desktop/game-collection/.conductor/curitiba/sentry-mcp-cursor/start-claude.sh
```

### 3. Verificação de Funcionamento

```bash
claude mcp list
# Resultado: sentry - ✓ Connected
```

## 🎯 Por Que Funcionou

### ❌ Abordagem Anterior (Falhou)
- Tentava carregar variáveis de um arquivo externo com `source`
- Dependia de caminhos relativos que podiam mudar
- O contexto de execução do MCP não preservava as variáveis carregadas

### ✅ Abordagem Final (Sucesso)
- **Variáveis hardcoded no script** - Elimina problemas de carregamento
- **Caminhos absolutos** - Garante que o MCP encontre o arquivo correto
- **Uso de `exec`** - Substitui o processo do shell pelo Node.js diretamente
- **Escopo global (`-s user`)** - Disponível em todos os projetos

## 📊 Diferenças Técnicas

| Aspecto | Solução Anterior | Solução Final |
|---------|------------------|---------------|
| Carregamento de vars | `source config.env` | Hardcoded no script |
| Caminho do node | Relativo (`node dist/index.js`) | Absoluto (`/Users/.../dist/index.js`) |
| Escopo | Local/misto | Global (`-s user`) |
| Execução | Shell wrapper complexo | Script simples com `exec` |

## 🔍 Lições Aprendidas

1. **Simplicidade é chave** - Scripts complexos podem falhar em contextos específicos do MCP
2. **Variáveis inline são mais confiáveis** - Para MCPs, é melhor ter as variáveis diretamente no script
3. **Caminhos absolutos previnem erros** - Sempre use caminhos completos para evitar problemas de resolução
4. **`exec` é importante** - Garante que sinais sejam propagados corretamente para o processo Node.js

## 🚀 Resultado Final

- ✅ Sentry MCP funcionando globalmente no Claude Code
- ✅ Disponível em todos os projetos
- ✅ Conexão estável e persistente
- ✅ Acesso completo às ferramentas do Sentry via MCP

## 📝 Arquivos Criados/Modificados

1. `/start-claude.sh` - Novo script simplificado para o Claude Code
2. `/Users/agents/.claude.json` - Configuração global do MCP atualizada

## 🔄 Como Replicar em Outros Projetos

Se você precisar configurar outro MCP com problemas similares:

1. Crie um script bash simples com variáveis hardcoded
2. Use caminhos absolutos para todos os arquivos
3. Configure globalmente com `-s user`
4. Use `exec` para executar o processo principal
5. Teste com `claude mcp list`

Esta solução é robusta e pode ser aplicada a outros MCPs que dependem de variáveis de ambiente.