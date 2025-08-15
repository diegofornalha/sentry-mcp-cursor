# 🚨 Guia Completo: Integração Claude Flow + MCP Sentry

## 📋 Índice
1. [Visão Geral](#visão-geral)
2. [Arquitetura da Integração](#arquitetura-da-integração)
3. [Instalação e Configuração](#instalação-e-configuração)
4. [Fluxos de Trabalho Práticos](#fluxos-de-trabalho-práticos)
5. [Exemplos de Código](#exemplos-de-código)
6. [Padrões e Melhores Práticas](#padrões-e-melhores-práticas)
7. [Casos de Uso Avançados](#casos-de-uso-avançados)
8. [Troubleshooting](#troubleshooting)
9. [Referência de API](#referência-de-api)

## 🎯 Visão Geral

A integração Claude Flow + MCP Sentry cria um sistema robusto de monitoramento e observabilidade, combinando:

- **Claude Flow**: Orquestração de agentes IA com execução paralela
- **MCP Sentry**: Monitoramento de erros, performance e saúde da aplicação
- **Claude Code**: Executor de todas as operações reais

### Benefícios Principais

| Recurso | Sem Integração | Com Integração |
|---------|----------------|----------------|
| **Monitoramento** | Logs locais dispersos | Observabilidade centralizada |
| **Debug** | Difícil rastreamento | Stack traces completos |
| **Performance** | Métricas manuais | APM automático |
| **Alertas** | Descoberta tardia | Notificações em tempo real |
| **Análise** | Reativa | Proativa com IA |

## 🏗️ Arquitetura da Integração

### Componentes do Sistema

```mermaid
graph TB
    CC[Claude Code] --> CF[Claude Flow]
    CF --> MCP[MCP Sentry]
    MCP --> API[Sentry API]
    MCP --> SDK[Sentry SDK]
    
    CF --> AG1[Agent 1]
    CF --> AG2[Agent 2]
    CF --> AG3[Agent N]
    
    AG1 --> ERR[Error Capture]
    AG2 --> PERF[Performance]
    AG3 --> REL[Release Health]
    
    ERR --> DASH[Sentry Dashboard]
    PERF --> DASH
    REL --> DASH
```

### Fluxo de Dados

1. **Captura**: Claude Code captura erros e eventos
2. **Enriquecimento**: Claude Flow adiciona contexto de agentes
3. **Transmissão**: MCP Sentry envia para a plataforma
4. **Análise**: Dashboard Sentry processa e visualiza
5. **Feedback**: Insights retornam para melhorias

## 📦 Instalação e Configuração

### 1. Pré-requisitos

```bash
# Verificar versões necessárias
node --version  # >= 18.0.0
npm --version   # >= 8.0.0

# Instalar Claude Code (se ainda não instalado)
npm install -g claude-code
```

### 2. Instalar MCP Sentry

```bash
# Clonar repositório
cd ~/Desktop/game-collection/.conductor/curitiba
git clone https://github.com/zereight/sentry-mcp sentry-mcp-cursor
cd sentry-mcp-cursor

# Instalar dependências
npm install
npm run build
```

### 3. Configurar Credenciais

```bash
# Criar arquivo de configuração
cat > config.env << EOF
# Configurações do Sentry
SENTRY_DSN=https://e12b9f457709c8e451398bb1b7d88924@o4509787137638400.ingest.us.sentry.io/4509845941911552
SENTRY_AUTH_TOKEN=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
SENTRY_ORG=game-bx
SENTRY_API_URL=https://sentry.io/api/0
SENTRY_PROJECT=javascript-vue
SENTRY_ENVIRONMENT=development
SENTRY_RELEASE=mahjong-solitaire@2.0.0
EOF
```

### 4. Integrar no Cursor

```bash
# Adicionar ao Cursor
./add-to-cursor.sh

# Verificar instalação
echo '{"jsonrpc": "2.0", "id": 1, "method": "tools/call", "params": {"name": "sentry_list_projects", "arguments": {}}}' | ./start-cursor.sh
```

### 5. Integrar no Claude Code

```bash
# Criar wrapper para Claude Code
cat > start-mcp-claude.sh << 'EOF'
#!/bin/bash
source "$(dirname "$0")/config.env"
export SENTRY_DSN="$SENTRY_DSN"
export SENTRY_AUTH_TOKEN="$SENTRY_AUTH_TOKEN"
export SENTRY_ORG="$SENTRY_ORG"
export SENTRY_API_URL="$SENTRY_API_URL"
cd "$(dirname "$0")"
exec node dist/index.js
EOF

chmod +x start-mcp-claude.sh

# Adicionar ao Claude Code
claude mcp add sentry-game ./start-mcp-claude.sh
```

### 6. Verificar Instalação

```bash
# Testar no Cursor
./test-standalone.sh

# Verificar no Claude Code
claude mcp list
```

## 🔄 Fluxos de Trabalho Práticos

### Workflow 1: Monitoramento de Desenvolvimento com Swarm

```javascript
// 1. Inicializar swarm com monitoramento
mcp__claude-flow__swarm_init({
  topology: "mesh",
  maxAgents: 6,
  monitoring: {
    provider: "sentry",
    captureExceptions: true,
    tracePerformance: true
  }
})

// 2. Configurar contexto de monitoramento
mcp__sentry-game__sentry_set_context({
  context: "development_session",
  data: {
    project: "mahjong-game",
    session: new Date().toISOString(),
    swarm_id: "swarm_001"
  }
})

// 3. Spawn agentes com rastreamento
mcp__claude-flow__agent_spawn({
  type: "coder",
  task: "Implementar novo feature",
  monitoring: {
    trackPerformance: true,
    captureErrors: true
  }
})

// 4. Executar com captura automática
try {
  Task("Implementar sistema de pontuação com validação")
} catch (error) {
  mcp__sentry-game__sentry_capture_exception({
    error: error.message,
    level: "error",
    tags: {
      agent: "coder",
      task: "scoring_system"
    }
  })
}

// 5. Finalizar com métricas
mcp__sentry-game__sentry_finish_transaction({
  transactionId: "dev_session_001",
  status: "ok"
})
```

### Workflow 2: Debug Inteligente com Contexto

```javascript
// debug-with-context.js

// 1. Capturar erro com contexto completo
function captureEnhancedError(error, context) {
  // Adicionar breadcrumbs de navegação
  mcp__sentry-game__sentry_add_breadcrumb({
    message: `Error in ${context.component}`,
    category: "navigation",
    level: "error",
    data: {
      component: context.component,
      action: context.action,
      timestamp: Date.now()
    }
  });

  // Definir usuário/sessão
  mcp__sentry-game__sentry_set_user({
    id: context.userId || "anonymous",
    username: context.username,
    email: context.email,
    ip_address: "{{auto}}"
  });

  // Adicionar tags para filtros
  mcp__sentry-game__sentry_set_tag({
    key: "component",
    value: context.component
  });

  mcp__sentry-game__sentry_set_tag({
    key: "environment",
    value: process.env.NODE_ENV
  });

  // Capturar exceção com todo contexto
  mcp__sentry-game__sentry_capture_exception({
    error: error.toString(),
    level: "error",
    fingerprint: [context.component, error.name],
    extra: {
      stackTrace: error.stack,
      context: JSON.stringify(context),
      timestamp: new Date().toISOString()
    }
  });

  // Criar issue no Sentry se crítico
  if (context.severity === "critical") {
    mcp__sentry-game__sentry_create_issue({
      title: `Critical Error: ${error.message}`,
      culprit: context.component,
      level: "error",
      platform: "javascript"
    });
  }
}

// Uso
try {
  // Código que pode falhar
  processGameMove(move);
} catch (error) {
  captureEnhancedError(error, {
    component: "GameEngine",
    action: "processMove",
    userId: currentUser.id,
    username: currentUser.name,
    severity: "critical"
  });
}
```

### Workflow 3: Performance Monitoring com APM

```javascript
// performance-monitoring.js

class PerformanceMonitor {
  constructor() {
    this.transactions = new Map();
  }

  // Iniciar transação
  async startOperation(name, operation) {
    const transactionId = `${name}_${Date.now()}`;
    
    // Iniciar transação no Sentry
    await mcp__sentry-game__sentry_start_transaction({
      name: name,
      op: operation,
      description: `Performance monitoring for ${name}`,
      tags: {
        component: "game",
        monitoring: "active"
      }
    });

    this.transactions.set(transactionId, {
      name,
      startTime: Date.now()
    });

    return transactionId;
  }

  // Adicionar span à transação
  async addSpan(transactionId, spanName, operation) {
    const transaction = this.transactions.get(transactionId);
    
    if (transaction) {
      // Implementação do span
      const spanStart = Date.now();
      
      try {
        const result = await operation();
        
        // Log success
        console.log(`✅ Span ${spanName} completed in ${Date.now() - spanStart}ms`);
        
        return result;
      } catch (error) {
        // Capturar erro no span
        mcp__sentry-game__sentry_capture_exception({
          error: error.message,
          level: "error",
          tags: {
            transaction: transaction.name,
            span: spanName
          }
        });
        
        throw error;
      }
    }
  }

  // Finalizar transação
  async endOperation(transactionId, status = "ok") {
    const transaction = this.transactions.get(transactionId);
    
    if (transaction) {
      const duration = Date.now() - transaction.startTime;
      
      // Finalizar no Sentry
      await mcp__sentry-game__sentry_finish_transaction({
        transactionId: transactionId,
        status: status
      });

      // Log métricas
      console.log(`📊 Transaction ${transaction.name} completed in ${duration}ms`);
      
      // Limpar
      this.transactions.delete(transactionId);
      
      // Enviar métrica customizada
      if (duration > 1000) {
        mcp__sentry-game__sentry_capture_message({
          message: `Slow transaction: ${transaction.name} took ${duration}ms`,
          level: "warning"
        });
      }
    }
  }
}

// Uso
const monitor = new PerformanceMonitor();

async function processGameLoop() {
  const txId = await monitor.startOperation("game_loop", "game.process");
  
  try {
    // Span 1: Input processing
    await monitor.addSpan(txId, "input_processing", async () => {
      // Process user input
      await processUserInput();
    });

    // Span 2: Game logic
    await monitor.addSpan(txId, "game_logic", async () => {
      // Update game state
      await updateGameState();
    });

    // Span 3: Rendering
    await monitor.addSpan(txId, "rendering", async () => {
      // Render frame
      await renderFrame();
    });

    await monitor.endOperation(txId, "ok");
  } catch (error) {
    await monitor.endOperation(txId, "error");
    throw error;
  }
}
```

## 💻 Exemplos de Código

### Exemplo 1: Hook de Monitoramento Automático

```javascript
// .claude/hooks/sentry-monitoring-hook.js

const { exec } = require('child_process');
const { promisify } = require('util');
const execAsync = promisify(exec);

module.exports = {
  // Antes de qualquer operação
  preOperation: async (context) => {
    // Adicionar breadcrumb para rastreamento
    const breadcrumb = {
      message: `Starting operation: ${context.operation}`,
      category: "claude-code",
      level: "info",
      data: {
        file: context.file,
        operation: context.operation,
        timestamp: new Date().toISOString()
      }
    };
    
    await execAsync(`curl -X POST http://localhost:3000/mcp/sentry/breadcrumb -d '${JSON.stringify(breadcrumb)}'`);
  },

  // Capturar erros automaticamente
  onError: async (error, context) => {
    const errorData = {
      error: error.message,
      stack: error.stack,
      context: {
        file: context.file,
        line: context.line,
        operation: context.operation
      },
      level: "error",
      tags: {
        source: "claude-code-hook",
        auto_captured: "true"
      }
    };
    
    await execAsync(`curl -X POST http://localhost:3000/mcp/sentry/capture-error -d '${JSON.stringify(errorData)}'`);
    
    console.error('🚨 Error captured and sent to Sentry');
  },

  // Após edição bem-sucedida
  postEdit: async (context) => {
    // Enviar evento de sucesso
    if (context.success) {
      const event = {
        message: `File edited successfully: ${context.file}`,
        level: "info",
        tags: {
          operation: "edit",
          file_type: context.file.split('.').pop()
        }
      };
      
      await execAsync(`curl -X POST http://localhost:3000/mcp/sentry/message -d '${JSON.stringify(event)}'`);
    }
  },

  // Monitorar performance de operações longas
  performanceWrapper: async (operation, context) => {
    const startTime = Date.now();
    const transactionId = `op_${context.operation}_${startTime}`;
    
    // Iniciar transação
    await execAsync(`curl -X POST http://localhost:3000/mcp/sentry/transaction/start -d '{"id": "${transactionId}", "name": "${context.operation}"}'`);
    
    try {
      const result = await operation();
      
      // Finalizar com sucesso
      const duration = Date.now() - startTime;
      await execAsync(`curl -X POST http://localhost:3000/mcp/sentry/transaction/finish -d '{"id": "${transactionId}", "status": "ok", "duration": ${duration}}'`);
      
      // Alertar se muito lento
      if (duration > 5000) {
        console.warn(`⚠️ Slow operation: ${context.operation} took ${duration}ms`);
      }
      
      return result;
    } catch (error) {
      // Finalizar com erro
      await execAsync(`curl -X POST http://localhost:3000/mcp/sentry/transaction/finish -d '{"id": "${transactionId}", "status": "error"}'`);
      throw error;
    }
  }
};
```

### Exemplo 2: Agente de Monitoramento Especializado

```yaml
---
name: sentry-monitor
type: observability-specialist
description: Especialista em monitoramento e observabilidade com Sentry
capabilities:
  - error_tracking
  - performance_monitoring
  - release_health
  - alert_configuration
  - dashboard_creation
tools: mcp-sentry, Read, Write
priority: high
---

# Sentry Monitor Agent

Você é o especialista em monitoramento e observabilidade usando Sentry.

## Responsabilidades Principais

1. **Configurar Monitoramento** completo para projetos
2. **Rastrear Erros** e exceções automaticamente
3. **Monitorar Performance** e identificar gargalos
4. **Gerenciar Releases** e saúde das versões
5. **Criar Alertas** inteligentes e acionáveis

## Workflow de Monitoramento

### 1. Setup Inicial
```javascript
// Configurar projeto no Sentry
async function setupSentryProject(projectName) {
  // Verificar se projeto existe
  const projects = await mcp__sentry-game__sentry_list_projects();
  
  if (!projects.includes(projectName)) {
    // Criar novo projeto
    await mcp__sentry-game__sentry_setup_project({
      platform: "javascript",
      name: projectName
    });
  }
  
  // Configurar integrações
  await configureIntegrations(projectName);
  
  // Criar alertas padrão
  await setupDefaultAlerts(projectName);
  
  return `Project ${projectName} configured`;
}
```

### 2. Monitoramento Contínuo
```javascript
// Monitorar saúde da aplicação
async function monitorApplicationHealth() {
  // Buscar issues recentes
  const issues = await mcp__sentry-game__sentry_list_issues({
    projectSlug: "javascript-vue",
    query: "is:unresolved level:error",
    limit: 10
  });
  
  // Analisar padrões
  const patterns = analyzeErrorPatterns(issues);
  
  // Gerar recomendações
  const recommendations = generateRecommendations(patterns);
  
  return {
    criticalIssues: issues.filter(i => i.level === 'error'),
    patterns: patterns,
    recommendations: recommendations
  };
}
```

### 3. Gestão de Releases
```javascript
// Gerenciar releases
async function manageRelease(version) {
  // Criar release
  await mcp__sentry-game__sentry_create_release({
    version: version,
    projects: ["javascript-vue"],
    refs: [{
      repository: "game-bx/mahjong",
      commit: process.env.GIT_COMMIT
    }]
  });
  
  // Fazer deploy
  await mcp__sentry-game__sentry_create_deploy({
    environment: "production",
    release: version
  });
  
  // Monitorar saúde do release
  await monitorReleaseHealth(version);
}
```

## Hooks de Integração
- **Pre-Deploy**: Verificar issues críticas
- **Post-Deploy**: Monitorar métricas de adoção
- **On-Error**: Captura e análise automática
- **On-Performance-Issue**: Alertas e otimizações
```

### Exemplo 3: Sistema de Alertas Inteligentes

```python
#!/usr/bin/env python3
# intelligent-alerts.py

import json
import subprocess
from datetime import datetime, timedelta
from typing import List, Dict, Any

class IntelligentAlertSystem:
    def __init__(self):
        self.alert_rules = []
        self.notification_channels = []
        
    def setup_critical_alerts(self, project_slug: str):
        """Configura alertas críticos para o projeto"""
        
        critical_alerts = [
            {
                "name": "High Error Rate",
                "conditions": [
                    {
                        "id": "event_frequency",
                        "value": 100,
                        "interval": "1h"
                    }
                ],
                "filters": [
                    {
                        "level": ["error", "fatal"]
                    }
                ],
                "actions": [
                    {
                        "type": "email",
                        "targetType": "team"
                    },
                    {
                        "type": "slack",
                        "channel": "#alerts"
                    }
                ]
            },
            {
                "name": "Performance Degradation",
                "conditions": [
                    {
                        "id": "p95_transaction_duration",
                        "value": 3000,  # 3 seconds
                        "interval": "5m"
                    }
                ],
                "actions": [
                    {
                        "type": "create_issue",
                        "assignee": "performance-team"
                    }
                ]
            },
            {
                "name": "Crash Free Rate Drop",
                "conditions": [
                    {
                        "id": "crash_free_rate",
                        "value": 0.95,  # Below 95%
                        "comparison": "below"
                    }
                ],
                "actions": [
                    {
                        "type": "page",
                        "urgency": "high"
                    }
                ]
            }
        ]
        
        for alert in critical_alerts:
            self.create_alert_rule(project_slug, alert)
    
    def create_alert_rule(self, project_slug: str, rule: Dict[str, Any]):
        """Cria regra de alerta no Sentry"""
        
        cmd = f"""
        curl -X POST https://sentry.io/api/0/projects/{project_slug}/rules/ \\
          -H 'Authorization: Bearer $SENTRY_AUTH_TOKEN' \\
          -H 'Content-Type: application/json' \\
          -d '{json.dumps(rule)}'
        """
        
        result = subprocess.run(cmd, shell=True, capture_output=True)
        
        if result.returncode == 0:
            print(f"✅ Alert rule '{rule['name']}' created")
            self.alert_rules.append(rule)
        else:
            print(f"❌ Failed to create alert rule: {result.stderr}")
    
    def analyze_alert_patterns(self, timeframe_hours: int = 24):
        """Analisa padrões de alertas para otimização"""
        
        # Buscar alertas disparados
        end_time = datetime.now()
        start_time = end_time - timedelta(hours=timeframe_hours)
        
        cmd = f"""
        echo '{{"jsonrpc": "2.0", "method": "tools/call", "params": {{"name": "sentry_list_issues", "arguments": {{"query": "firstSeen:>{start_time.isoformat()}", "limit": 100}}}}}}' | ./start.sh
        """
        
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        issues = json.loads(result.stdout)
        
        # Analisar padrões
        patterns = {
            "most_frequent_errors": {},
            "time_distribution": {},
            "affected_users": set(),
            "critical_components": []
        }
        
        for issue in issues.get("results", []):
            # Contabilizar frequência
            error_type = issue.get("type", "unknown")
            patterns["most_frequent_errors"][error_type] = \
                patterns["most_frequent_errors"].get(error_type, 0) + 1
            
            # Distribuição temporal
            hour = datetime.fromisoformat(issue["firstSeen"]).hour
            patterns["time_distribution"][hour] = \
                patterns["time_distribution"].get(hour, 0) + 1
            
            # Usuários afetados
            if issue.get("userCount"):
                patterns["affected_users"].add(issue["userCount"])
        
        return self.generate_insights(patterns)
    
    def generate_insights(self, patterns: Dict[str, Any]) -> List[str]:
        """Gera insights baseados nos padrões"""
        
        insights = []
        
        # Insight 1: Horários críticos
        if patterns["time_distribution"]:
            peak_hour = max(patterns["time_distribution"], 
                          key=patterns["time_distribution"].get)
            insights.append(f"📊 Peak error hour: {peak_hour}:00")
        
        # Insight 2: Erros mais frequentes
        if patterns["most_frequent_errors"]:
            top_error = max(patterns["most_frequent_errors"], 
                          key=patterns["most_frequent_errors"].get)
            count = patterns["most_frequent_errors"][top_error]
            insights.append(f"🔴 Most frequent error: {top_error} ({count} times)")
        
        # Insight 3: Impacto em usuários
        if patterns["affected_users"]:
            total_affected = len(patterns["affected_users"])
            insights.append(f"👥 Total affected users: {total_affected}")
        
        return insights
    
    def auto_tune_alerts(self, insights: List[str]):
        """Ajusta alertas automaticamente baseado em insights"""
        
        for insight in insights:
            if "Peak error hour" in insight:
                # Ajustar sensibilidade durante horário de pico
                hour = int(insight.split(":")[1])
                self.adjust_peak_hour_alerts(hour)
            
            elif "Most frequent error" in insight:
                # Criar alerta específico para erro frequente
                error_type = insight.split(":")[1].split("(")[0].strip()
                self.create_specific_error_alert(error_type)
    
    def create_dashboard(self, project_slug: str):
        """Cria dashboard customizado de monitoramento"""
        
        dashboard_config = {
            "title": "Game Monitoring Dashboard",
            "widgets": [
                {
                    "type": "line-chart",
                    "title": "Error Rate",
                    "query": "event.type:error",
                    "interval": "5m"
                },
                {
                    "type": "bar-chart",
                    "title": "Top Errors",
                    "query": "count() by error.type",
                    "limit": 5
                },
                {
                    "type": "number",
                    "title": "Crash Free Rate",
                    "query": "crash_free_rate()",
                    "comparison": "previous_period"
                },
                {
                    "type": "table",
                    "title": "Recent Issues",
                    "query": "is:unresolved",
                    "columns": ["title", "count", "users", "last_seen"]
                }
            ]
        }
        
        # Criar dashboard via API
        self.create_sentry_dashboard(project_slug, dashboard_config)
        
        return dashboard_config

# Uso do sistema
if __name__ == "__main__":
    alert_system = IntelligentAlertSystem()
    
    # Configurar alertas críticos
    alert_system.setup_critical_alerts("javascript-vue")
    
    # Analisar padrões
    patterns = alert_system.analyze_alert_patterns(24)
    
    # Gerar insights
    insights = alert_system.generate_insights(patterns)
    print("\n📊 Insights:")
    for insight in insights:
        print(f"  {insight}")
    
    # Auto-ajustar alertas
    alert_system.auto_tune_alerts(insights)
    
    # Criar dashboard
    alert_system.create_dashboard("javascript-vue")
    
    print("\n✅ Alert system configured and optimized!")
```

## 📋 Padrões e Melhores Práticas

### 1. Captura de Erros

✅ **FAÇA:**
```javascript
// Sempre adicionar contexto relevante
mcp__sentry-game__sentry_capture_exception({
  error: error.message,
  level: "error",
  fingerprint: [component, error.type],  // Agrupamento inteligente
  tags: {
    component: "GameEngine",
    version: "2.0.0",
    user_action: "tile_click"
  },
  extra: {
    game_state: getCurrentGameState(),
    user_score: getUserScore()
  }
})
```

❌ **NÃO FAÇA:**
```javascript
// Evitar captura sem contexto
mcp__sentry-game__sentry_capture_exception({
  error: "Something went wrong"  // Muito genérico
})
```

### 2. Performance Monitoring

✅ **PADRÃO CORRETO:**
```javascript
// Usar transações para operações complexas
const txId = await mcp__sentry-game__sentry_start_transaction({
  name: "game.initialization",
  op: "initialization",
  description: "Complete game initialization process"
});

// Adicionar spans para sub-operações
await loadAssets();    // Span automático
await setupGame();     // Span automático  
await connectServer(); // Span automático

await mcp__sentry-game__sentry_finish_transaction({
  transactionId: txId,
  status: "ok"
});
```

### 3. Breadcrumbs Efetivos

✅ **SEMPRE ADICIONAR:**
- Ações do usuário
- Mudanças de estado
- Chamadas de API
- Navegação

```javascript
// Breadcrumb informativo
mcp__sentry-game__sentry_add_breadcrumb({
  message: "User clicked start game",
  category: "user-action",
  level: "info",
  data: {
    game_mode: "classic",
    difficulty: "medium",
    timestamp: Date.now()
  }
})
```

### 4. Release Management

✅ **WORKFLOW DE RELEASE:**
```javascript
// 1. Criar release antes do deploy
await mcp__sentry-game__sentry_create_release({
  version: "game-v2.1.0",
  projects: ["javascript-vue"],
  commits: await getGitCommits()
});

// 2. Deploy com associação
await deployApplication();

// 3. Marcar deploy no Sentry
await mcp__sentry-game__sentry_create_deploy({
  environment: "production",
  release: "game-v2.1.0"
});

// 4. Monitorar saúde
await monitorReleaseHealth("game-v2.1.0");
```

### 5. Alertas Inteligentes

✅ **CONFIGURAR ALERTAS PARA:**
- Taxa de erro > threshold
- Performance degradada
- Novos tipos de erro
- Crash rate elevado
- Usuários afetados > limite

## 🚀 Casos de Uso Avançados

### 1. Análise Preditiva de Erros

```javascript
// predictive-error-analysis.js

class PredictiveErrorAnalyzer {
  constructor() {
    this.errorPatterns = new Map();
    this.predictions = [];
  }

  async analyzeHistoricalData(days = 30) {
    // Buscar dados históricos
    const issues = await mcp__sentry-game__sentry_list_issues({
      projectSlug: "javascript-vue",
      query: `firstSeen:>-${days}d`,
      limit: 1000
    });

    // Identificar padrões
    this.identifyPatterns(issues);
    
    // Gerar predições
    this.generatePredictions();
    
    // Criar alertas preventivos
    await this.createPreventiveAlerts();
  }

  identifyPatterns(issues) {
    issues.forEach(issue => {
      // Analisar contexto do erro
      const context = {
        hour: new Date(issue.firstSeen).getHours(),
        dayOfWeek: new Date(issue.firstSeen).getDay(),
        errorType: issue.type,
        component: issue.culprit,
        frequency: issue.count
      };
      
      // Armazenar padrão
      const key = `${context.errorType}_${context.component}`;
      if (!this.errorPatterns.has(key)) {
        this.errorPatterns.set(key, []);
      }
      this.errorPatterns.get(key).push(context);
    });
  }

  generatePredictions() {
    this.errorPatterns.forEach((patterns, key) => {
      // Calcular probabilidades
      const hourlyDistribution = this.calculateDistribution(patterns, 'hour');
      const dailyDistribution = this.calculateDistribution(patterns, 'dayOfWeek');
      
      // Identificar picos
      const peakHour = this.findPeak(hourlyDistribution);
      const peakDay = this.findPeak(dailyDistribution);
      
      // Criar predição
      if (peakHour.probability > 0.3) {
        this.predictions.push({
          type: key,
          prediction: `High probability of ${key} errors at ${peakHour.value}:00`,
          probability: peakHour.probability,
          recommendation: `Schedule maintenance or increase monitoring at ${peakHour.value}:00`
        });
      }
    });
  }

  async createPreventiveAlerts() {
    for (const prediction of this.predictions) {
      if (prediction.probability > 0.5) {
        // Criar alerta preventivo
        await mcp__sentry-game__sentry_create_alert_rule({
          name: `Predictive Alert: ${prediction.type}`,
          conditions: [{
            id: "event_frequency",
            value: 10,
            interval: "1h"
          }],
          filters: [{
            query: prediction.type
          }],
          actions: [{
            type: "notification",
            message: prediction.recommendation
          }]
        });
      }
    }
  }
}
```

### 2. Auto-Healing com Sentry Feedback

```python
#!/usr/bin/env python3
# auto-healing-system.py

import asyncio
import json
from typing import Dict, List, Any

class AutoHealingSystem:
    def __init__(self):
        self.healing_strategies = {
            "memory_leak": self.heal_memory_leak,
            "connection_timeout": self.heal_connection,
            "rate_limit": self.heal_rate_limit,
            "cache_miss": self.heal_cache
        }
        
    async def monitor_and_heal(self):
        """Monitor contínuo com auto-healing"""
        
        while True:
            # Buscar issues recentes
            issues = await self.get_recent_issues()
            
            for issue in issues:
                # Identificar tipo de problema
                issue_type = self.identify_issue_type(issue)
                
                if issue_type in self.healing_strategies:
                    # Tentar auto-healing
                    success = await self.healing_strategies[issue_type](issue)
                    
                    if success:
                        # Marcar como resolvido
                        await self.resolve_issue(issue['id'])
                        
                        # Adicionar nota de auto-healing
                        await self.add_issue_note(
                            issue['id'],
                            f"Auto-healed: {issue_type}"
                        )
                    else:
                        # Escalar para humano
                        await self.escalate_issue(issue)
            
            # Aguardar próximo ciclo
            await asyncio.sleep(60)  # Check every minute
    
    def identify_issue_type(self, issue: Dict[str, Any]) -> str:
        """Identifica tipo de issue para auto-healing"""
        
        error_message = issue.get('title', '').lower()
        
        if 'memory' in error_message or 'heap' in error_message:
            return "memory_leak"
        elif 'timeout' in error_message or 'connection' in error_message:
            return "connection_timeout"
        elif 'rate limit' in error_message:
            return "rate_limit"
        elif 'cache' in error_message:
            return "cache_miss"
        
        return "unknown"
    
    async def heal_memory_leak(self, issue: Dict[str, Any]) -> bool:
        """Tenta resolver memory leak"""
        
        try:
            # Forçar garbage collection
            import gc
            gc.collect()
            
            # Reiniciar workers se necessário
            await self.restart_workers()
            
            # Verificar se resolveu
            return await self.verify_healing("memory")
            
        except Exception as e:
            print(f"Failed to heal memory leak: {e}")
            return False
    
    async def heal_connection(self, issue: Dict[str, Any]) -> bool:
        """Tenta resolver problemas de conexão"""
        
        try:
            # Reiniciar pool de conexões
            await self.restart_connection_pool()
            
            # Ajustar timeouts
            await self.adjust_timeouts()
            
            return await self.verify_healing("connection")
            
        except Exception:
            return False
    
    async def heal_rate_limit(self, issue: Dict[str, Any]) -> bool:
        """Tenta resolver rate limiting"""
        
        try:
            # Implementar backoff
            await self.implement_backoff()
            
            # Distribuir carga
            await self.distribute_load()
            
            return True
            
        except Exception:
            return False
    
    async def heal_cache(self, issue: Dict[str, Any]) -> bool:
        """Tenta resolver problemas de cache"""
        
        try:
            # Limpar cache corrompido
            await self.clear_cache()
            
            # Pré-aquecer cache
            await self.warm_cache()
            
            return await self.verify_healing("cache")
            
        except Exception:
            return False
```

### 3. Dashboard Inteligente com IA

```javascript
// ai-powered-dashboard.js

class AIDashboard {
  constructor() {
    this.insights = [];
    this.recommendations = [];
  }

  async generateAIInsights() {
    // Coletar dados do Sentry
    const data = await this.collectSentryData();
    
    // Analisar com IA (Claude Flow)
    const analysis = await mcp__claude-flow__agent_spawn({
      type: "analyst",
      task: "Analyze Sentry data and generate insights",
      context: data
    });

    // Processar insights
    this.processInsights(analysis);
    
    // Gerar recomendações
    await this.generateRecommendations();
    
    // Criar dashboard
    return this.createDashboard();
  }

  async collectSentryData() {
    const [issues, performance, releases] = await Promise.all([
      mcp__sentry-game__sentry_list_issues({
        projectSlug: "javascript-vue",
        query: "is:unresolved",
        limit: 100
      }),
      this.getPerformanceMetrics(),
      this.getReleaseHealth()
    ]);

    return {
      issues,
      performance,
      releases,
      timestamp: new Date().toISOString()
    };
  }

  processInsights(analysis) {
    // Extrair insights chave
    this.insights = [
      {
        type: "error_trend",
        title: "Error Trend Analysis",
        description: analysis.errorTrend,
        severity: this.calculateSeverity(analysis.errorTrend)
      },
      {
        type: "performance",
        title: "Performance Insights",
        description: analysis.performanceInsights,
        metrics: analysis.performanceMetrics
      },
      {
        type: "user_impact",
        title: "User Impact Assessment",
        description: analysis.userImpact,
        affected: analysis.affectedUsers
      }
    ];
  }

  async generateRecommendations() {
    for (const insight of this.insights) {
      if (insight.severity === "high") {
        const recommendation = await this.createRecommendation(insight);
        this.recommendations.push(recommendation);
      }
    }
  }

  createDashboard() {
    return {
      title: "AI-Powered Monitoring Dashboard",
      sections: [
        {
          title: "Critical Insights",
          widgets: this.insights.filter(i => i.severity === "high").map(i => ({
            type: "alert",
            content: i.description,
            action: this.getActionForInsight(i)
          }))
        },
        {
          title: "Performance Metrics",
          widgets: [
            {
              type: "chart",
              data: this.insights.find(i => i.type === "performance").metrics
            }
          ]
        },
        {
          title: "Recommendations",
          widgets: this.recommendations.map(r => ({
            type: "recommendation",
            title: r.title,
            description: r.description,
            priority: r.priority,
            action: r.action
          }))
        }
      ],
      lastUpdated: new Date().toISOString()
    };
  }
}

// Uso
const dashboard = new AIDashboard();
const aiDashboard = await dashboard.generateAIInsights();
console.log("📊 AI Dashboard generated:", aiDashboard);
```

## 🔧 Troubleshooting

### Problema 1: MCP não conecta

**Sintomas:**
- Erro "MCP server not connected"
- Timeout na conexão

**Soluções:**

```bash
# 1. Verificar processo
ps aux | grep sentry-mcp

# 2. Reiniciar MCP
claude mcp remove sentry-game -s local
claude mcp add sentry-game ./start-mcp-claude.sh

# 3. Verificar logs
tail -f ~/.claude/logs/mcp.log

# 4. Testar manualmente
./test-standalone.sh
```

### Problema 2: Erros não aparecem no Sentry

**Sintomas:**
- Captura sem erros mas nada no dashboard
- Status 200 mas sem dados

**Soluções:**

```javascript
// 1. Verificar DSN
console.log(Sentry.getClient()?.getDsn());

// 2. Verificar se está enviando
Sentry.captureMessage("Test message", "info");

// 3. Verificar network
// DevTools > Network > Filtrar por "sentry"

// 4. Debug mode
Sentry.init({
  debug: true,
  beforeSend(event) {
    console.log('Sending event:', event);
    return event;
  }
});
```

### Problema 3: Performance ruim

**Sintomas:**
- Aplicação lenta após adicionar Sentry
- Alto uso de memória

**Soluções:**

```javascript
// 1. Ajustar sample rates
Sentry.init({
  tracesSampleRate: 0.1,  // 10% ao invés de 100%
  replaysSessionSampleRate: 0.01  // 1% ao invés de 10%
});

// 2. Filtrar eventos desnecessários
Sentry.init({
  beforeSend(event) {
    // Ignorar eventos de desenvolvimento
    if (event.environment === 'development') {
      return null;
    }
    return event;
  }
});

// 3. Usar lazy loading
const Sentry = await import('@sentry/vue');
```

## 📚 Referência de API

### MCP Sentry Tools (27 ferramentas)

#### SDK Tools (12)
| Tool | Descrição | Parâmetros |
|------|-----------|------------|
| `sentry_capture_exception` | Captura exceção | error, level, tags, extra |
| `sentry_capture_message` | Envia mensagem | message, level, tags |
| `sentry_add_breadcrumb` | Adiciona breadcrumb | message, category, level, data |
| `sentry_set_user` | Define usuário | id, username, email, ip_address |
| `sentry_set_tag` | Define tag | key, value |
| `sentry_set_context` | Define contexto | context, data |
| `sentry_start_transaction` | Inicia transação | name, op, description |
| `sentry_finish_transaction` | Finaliza transação | transactionId, status |
| `sentry_start_session` | Inicia sessão | distinctId, release |
| `sentry_end_session` | Finaliza sessão | status |
| `sentry_set_release` | Define release | release, dist |
| `sentry_clear_scope` | Limpa escopo | - |

#### API Tools (15)
| Tool | Descrição | Parâmetros |
|------|-----------|------------|
| `sentry_list_projects` | Lista projetos | - |
| `sentry_list_issues` | Lista issues | projectSlug, query, limit |
| `sentry_get_issue` | Busca issue | issueId |
| `sentry_update_issue` | Atualiza issue | issueId, status |
| `sentry_create_release` | Cria release | version, projects |
| `sentry_list_releases` | Lista releases | projectSlug |
| `sentry_create_deploy` | Cria deploy | environment, release |
| `sentry_setup_project` | Configura projeto | platform, name |
| `sentry_create_alert_rule` | Cria alerta | name, conditions, actions |
| `sentry_list_teams` | Lista times | - |
| `sentry_create_team` | Cria time | name, slug |
| `sentry_resolve_short_id` | Resolve short ID | shortId, projectSlug |
| `sentry_list_issue_events` | Lista eventos | issueId, limit |
| `sentry_get_project_stats` | Estatísticas | projectSlug, stat |
| `sentry_search_issues` | Busca issues | query, projects |

### Hooks Disponíveis

| Hook | Trigger | Uso |
|------|---------|-----|
| `pre-capture` | Antes de capturar | Enriquecer contexto |
| `post-capture` | Após capturar | Log/notificação |
| `before-send` | Antes de enviar | Filtrar/modificar |
| `on-error` | Em erro | Fallback/retry |
| `session-start` | Início sessão | Setup contexto |
| `session-end` | Fim sessão | Cleanup/métricas |

## 🎯 Conclusão

A integração Claude Flow + MCP Sentry transforma o monitoramento ao:

- **Capturar erros** automaticamente com contexto rico
- **Monitorar performance** em tempo real
- **Alertar proativamente** sobre problemas
- **Analisar padrões** com IA
- **Auto-corrigir** problemas conhecidos
- **Evoluir** com aprendizado contínuo

### Próximos Passos Recomendados

1. **Implementar** os exemplos fornecidos
2. **Customizar** alertas para seu projeto
3. **Automatizar** workflows de monitoramento
4. **Integrar** com CI/CD
5. **Compartilhar** insights com a equipe

### Recursos Adicionais

- [Documentação Sentry](https://docs.sentry.io)
- [MCP Sentry GitHub](https://github.com/zereight/sentry-mcp)
- [Claude Flow Docs](https://github.com/ruvnet/claude-flow)
- [Exemplos de Integração](https://github.com/game-bx/mahjong)

---

**Versão**: 1.0.0  
**Última Atualização**: 15 de Janeiro de 2025  
**Autor**: Sistema SPARC com Claude-Flow  
**Projeto**: Mahjong Game - game-bx