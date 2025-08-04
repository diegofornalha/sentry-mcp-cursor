# 🚀 MCP Sentry para Cursor - Model Context Protocol Server

Um servidor MCP completo para integração com Sentry no Cursor, oferecendo 27 ferramentas para monitoramento de erros, performance e saúde de aplicações.

<a href="https://glama.ai/mcp/servers/@diegofornalha/sentry-mcp-cursor">
  <img width="380" height="200" src="https://glama.ai/mcp/servers/@diegofornalha/sentry-mcp-cursor/badge" alt="Sentry para Cursor MCP server" />
</a>

## ✨ Características

- **27 Ferramentas Completas**: 12 SDK + 15 API
- **Release Health**: Monitoramento completo de sessões
- **Performance Monitoring**: Transações e spans
- **Alertas Customizados**: Regras de alerta automatizadas
- **Busca Avançada**: Por arquivo, short ID, queries complexas
- **Setup Automático**: Configuração de projetos com um comando
- **Monitor em Tempo Real**: Script de monitoramento incluído

## 🛠️ Instalação Rápida

### 1. Clone e Configure
```bash
cd /Users/agents/Desktop/context-engineering-intro/sentry-mcp-cursor
npm install
npm run build
```

### 2. Configure as Credenciais
```bash
# Edite config.env com suas credenciais (já configurado)
nano config.env
```

### 3. Adicione ao Cursor
```bash
./add-to-cursor.sh
```

## 📚 Scripts Disponíveis

### 🚀 Inicialização
- `./start-cursor.sh` - Script otimizado para Cursor
- `./start-standalone.sh` - Inicia com validações e status detalhado
- `./start.sh` - Script padrão
- `./start-mcp.sh` - Script com configurações hardcoded

### 🧪 Testes e Monitoramento
- `./test-standalone.sh` - Executa suite completa de testes
- `./monitor.sh` - **NOVO!** Monitor em tempo real com estatísticas

### 🔧 Gerenciamento
- `./add-to-cursor.sh` - **NOVO!** Adiciona ao Cursor automaticamente
- `./add-to-claude-code.sh` - Adiciona ao Claude Code
- `./remove-from-claude-code.sh` - Remove do Claude Code

## 🎯 Ferramentas Disponíveis

### SDK Tools (12)
1. `mcp__sentry__sentry_capture_exception` - Captura exceções
2. `mcp__sentry__sentry_capture_message` - Captura mensagens
3. `mcp__sentry__sentry_add_breadcrumb` - Adiciona breadcrumbs
4. `mcp__sentry__sentry_set_user` - Define usuário
5. `mcp__sentry__sentry_set_tag` - Define tags
6. `mcp__sentry__sentry_set_context` - Define contexto
7. `mcp__sentry__sentry_start_transaction` - Inicia transação
8. `mcp__sentry__sentry_finish_transaction` - Finaliza transação
9. `mcp__sentry__sentry_start_session` - Inicia sessão
10. `mcp__sentry__sentry_end_session` - Finaliza sessão
11. `mcp__sentry__sentry_set_release` - Define release
12. `mcp__sentry__sentry_capture_session` - Captura sessão

### API Tools (15)
1. `mcp__sentry__sentry_list_projects` - Lista projetos
2. `mcp__sentry__sentry_list_issues` - Lista issues
3. `mcp__sentry__sentry_create_release` - Cria release
4. `mcp__sentry__sentry_list_releases` - Lista releases
5. `mcp__sentry__sentry_get_organization_stats` - Estatísticas
6. `mcp__sentry__sentry_create_alert_rule` - Cria alertas
7. `mcp__sentry__sentry_resolve_short_id` - Resolve IDs curtos
8. `mcp__sentry__sentry_get_event` - Obtém evento
9. `mcp__sentry__sentry_list_error_events_in_project` - Lista erros
10. `mcp__sentry__sentry_create_project` - Cria projeto
11. `mcp__sentry__sentry_list_issue_events` - Lista eventos de issue
12. `mcp__sentry__sentry_get_issue` - Obtém issue
13. `mcp__sentry__sentry_list_organization_replays` - Lista replays
14. `mcp__sentry__sentry_setup_project` - Setup de projeto
15. `mcp__sentry__sentry_search_errors_in_file` - Busca erros em arquivo

## 💡 Uso no Cursor

No Cursor, as ferramentas ficam disponíveis com o prefixo `mcp__sentry__`:

```javascript
// Capturar exceção
await mcp__sentry__sentry_capture_exception({
  error: "Database connection failed",
  level: "error",
  tags: {
    component: "database"
  }
});

// Listar projetos
await mcp__sentry__sentry_list_projects();

// Criar release
await mcp__sentry__sentry_create_release({
  version: "app@1.0.0",
  projects: ["coflow"]
});
```

## 📊 Monitor em Tempo Real

Execute o monitor para acompanhar estatísticas:
```bash
./monitor.sh
```

O monitor exibe:
- Status do servidor MCP
- Configuração no Cursor
- Estatísticas das últimas 24h
- Issues não resolvidas
- Última release
- Total de ferramentas disponíveis
- Atualização automática a cada 30s

## 🧪 Testes

Execute a suite completa de testes:
```bash
./test-standalone.sh
```

## 🔍 Troubleshooting

### Servidor não aparece no Cursor
```bash
# Verificar configuração
cat ../.cursor/mcp.json

# Reinstalar
./add-to-cursor.sh

# Reiniciar Cursor
```

### Monitor não encontra servidor
```bash
# Verificar se o servidor está rodando
ps aux | grep "node dist/index.js"

# Reiniciar servidor no Cursor
```

## 📝 Configuração

### config.env
```bash
SENTRY_DSN=https://782bbb46ddaa4e64a9a705e64f513985@o927801.ingest.us.sentry.io/5877334
SENTRY_AUTH_TOKEN=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
SENTRY_ORG=coflow
SENTRY_API_URL=https://sentry.io/api/0/
SENTRY_RELEASE=mcp-sentry-cursor@1.0.0
SENTRY_ENVIRONMENT=production
```

## 🎯 Melhorias Implementadas

### Do MCP Claude Code:
- ✅ Script `monitor.sh` para monitoramento em tempo real
- ✅ Script `add-to-cursor.sh` para instalação automatizada
- ✅ Melhor suporte para `config.env` no `start-cursor.sh`
- ✅ Documentação atualizada com prefixos do Cursor

## 🔗 Links Úteis

- [Documentação Sentry](https://docs.sentry.io)
- [MCP SDK](https://github.com/modelcontextprotocol/sdk)
- [Dashboard Sentry](https://coflow.sentry.io)

## 📄 Licença

MIT

---

Desenvolvido com ❤️ para Cursor