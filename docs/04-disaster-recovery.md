# Disaster Recovery

A estratégia de DR propõe para como solução, metas de RTO e RPO por componente, como o failover regional funciona, a estratégia de backup com PITR no Cloud SQL, e o plano de testes trimestrais para garantir que os runbooks funcionam quando acionados.

## RTO e RPO
| Componente | RTO | RPO |
| --- | --- | --- |
| Lançamentos | 30 min | 5 min |
| Consolidado | 1 h | 15 min |
| Cloud SQL | 1 h | 15 min |

## Estratégia de DR
- Primeira região: `southamerica-east1`.
- Região secundária: `us-east1` para replicação geográfica.
- Multi-zona na região primária para redundância de zona.
- Cloud SQL com HA regional e réplica em região secundária.
- Pub/Sub mantém mensagens por até 7 dias e reprocessa após recuperação.

## Runbook de failover

### Fase 1 — Detecção
1. Alerta do Cloud Monitoring dispara para o time (Pub/Sub → alertas críticos).
2. Verificar o Cloud Status Dashboard e métricas da região `southamerica-east1`.
3. Confirmar se a falha é de zona (reparação automática via HA) ou de região (acionar failover).

### Fase 2 — Failover de banco
4. Validar lag de replicação na réplica do Cloud SQL em `us-east1` (deve ser menor RPO de 15 min).
5. Promover uma réplica a instância primária via `gcloud sql instances promote-replica`.
6. Atualizar Secret Manager com o novo endpoint de conexão do banco.

### Fase 3 — Roteamento de tráfego
7. Atualizar regras do Cloud Load Balancer para apontar backends para a região secundária.
8. Ou ajustar Cloud DNS com TTL baixo para redirecionar tráfego.
9. Confirmar que o GKE Autopilot na região secundária está recebendo tráfego normalmente.

### Fase 4 — Validação e comunicação
10. Executar smoke tests nos endpoints de lançamentos e consolidado.
11. Verificar a fila Pub/Sub e as mensagens retidas durante o failover devem ser reprocessadas.
12. Comunicar stakeholders sobre o status e ETA de retorno à região primária.

### Fase 5 — Failback (após recuperação da região primária)
13. Restaurar dados do backup ou sincronizar banco de `us-east1` para `southamerica-east1`.
14. Redirecionar tráfego de volta para a região primária.
15. Registrar post-mortem com causas, impacto e ações de melhoria.

## Política de teste de DR
- Testes de DR trimestrais (gameday).
- Validação de failover e failback.
- Revisão de playbooks e comunicação com os times.

## Backup strategy
- Backups automáticos de Cloud SQL com PITR.
- Exportação diária para Cloud Storage cross-region.
- Retenção de backups por 90 dias.
