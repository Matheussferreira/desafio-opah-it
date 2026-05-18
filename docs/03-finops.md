# FinOps

A estratégia de FinOps que eu adotei, parte do principio de como os custos são rastreados por serviço e ambiente, quais descontos estão disponíveis e como serão aplicados, e de que forma o uso de serviços serverless e escalabilidade automática reduzem o custo ocioso. O objetivo é garantir previsibilidade orçamentária sem abrir mão da elasticidade que justifica o modelo cloud.

## Estratégia de descontos
- **Committed Use Discounts (CUDs)** para instâncias de Cloud SQL e recursos estáveis de GKE/Cloud Run.
- **Sustained Use Discounts** automáticos para cargas contínuas no GKE Autopilot e no EC2-like workloads.
- **Preemptible/Spot VMs** para batch, relatórios e ETL não críticos, reduzindo custo de processamento.

## Governança de custos
- Labels obrigatórias: `env`, `owner`, `cost-center`, `app`, `team`, `project`.
- Orçamento e alertas no Cloud Billing para evitar estouros por ambiente.
- Recommender para rightsizing trimestral e otimização de recursos.
- Auto-shutdown de ambientes de não produção fora do horário comercial usando Cloud Scheduler e Cloud Functions.

## Metodologia de FinOps
- Definir orçamento por ambiente e monitorar com alertas no Cloud Billing.
- Usar labels obrigatórias para rastrear custos e atribuir gastos por projeto, equipe e aplicativo.
- Automatizar análise de uso com Recommender e relatórios trimestrais.
- Priorizar serviços serverless e managed para minimizar custos operacionais.

## Estimativa de custo mensal (exemplo)
| Componente | Custo estimado | Observação |
| --- | --- | --- |
| GKE Autopilot | ~R$ 8.000 | Base de pods e recursos reservados |
| Cloud Run | ~R$ 2.500 | Depende de invocações e tempo de execução |
| Cloud SQL | ~R$ 6.500 | HA regional com réplica de leitura |
| Memorystore Redis | ~R$ 1.200 | Cache de leitura |
| Networking / Interconnect | ~R$ 3.000 | Link dedicado e VPN HA |
| Logging/Monitoring | ~R$ 1.000 | Volume de logs e métricas |

## Processo de FinOps
| Ação | Objetivo | Ferramenta |
| --- | --- | --- |
| Budget + Alerts | Controlar gasto mensal | Cloud Billing |
| Labels obrigatórias | Rastrear custo por serviço | Resource Manager |
| Rightsizing trimestral | Ajustar recursos | Recommender |
| Auto-shutdown dev/hml | Evitar custo ocioso | Cloud Scheduler + Functions |
| CUDs / Sustained | Reduzir preço de recursos estáveis | Cloud Billing |

## KPIs de FinOps
- Custo por transação: Estimativa de custo mensal / número de transações.
- Custo por ambiente: Ambientes dev/hml/prd separados por etiquetas.
- Eficiência de uso: Porcentagem de recursos utilizados vs provisionados.

## Ações de economia
- Uso do Cloud Run para reduzir custo ocioso com escala a zero.
- Uso do Cloud Storage para dados frios e backups de longo prazo.
- Revisão trimestral de direitos e CUDs.
