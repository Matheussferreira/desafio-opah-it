# Desafio: Arquitetura de Infraestrutura Híbrida com GCP

Cenário de arquitetura para migração e operação híbrida da plataforma. A solução mantém os investimentos on-premises existentes e adiciona a escalabilidade do GCP para os dois serviços de negócio: controle de lançamentos e consolidado diário.

O núcleo da arquitetura é o desacoplamento via Pub/Sub: O serviço de lançamentos publica eventos `transaction.created` e o serviço de consolidado que consome de forma assíncrona, com retry automático e Dead Letter Topic. Isso garante que uma falha no consolidado nunca derrube os lançamentos.

## Sumário

| # | Documento | Conteúdo |
|---|---|---|
| 1 | [Arquitetura](docs/01-architecture.md) | Visão geral, serviços GCP, fluxo de dados, padrões de resiliência e integração híbrida |
| 2 | [Dimensionamento](docs/02-sizing.md) | CPU, memória, escala horizontal/vertical e cenário de pico Black Friday |
| 3 | [FinOps](docs/03-finops.md) | Governança de custos, descontos, labels e estimativa mensal |
| 4 | [Disaster Recovery](docs/04-disaster-recovery.md) | RTO/RPO por componente e runbook de failover em 5 fases |
| 5 | [Observabilidade](docs/05-observability.md) | Stack de monitoramento, SLOs, alertas e observabilidade de rede |
| 6 | [Segurança](docs/06-security.md) | IAM, protocolos, criptografia, WAF e justificativa de cada protocolo adotado |
| 7 | [Modelo OSI](docs/07-osi-model.md) | Mapeamento de decisões por camada e cenários de diagnóstico |
| 8 | [Fluxo de Rede](docs/08-network-flow.md) | Fluxos de requisição, administração, sincronização on-prem e comparativo Kubernetes vs Serverless |
| 9 | [Estratégia IaC](docs/09-iac-strategy.md) | Terraform + Ansible, estrutura de módulos, pipeline CI/CD e workflow de deploy |
| 10 | [Roadmap](docs/10-roadmap.md) | Evoluções futuras e trade-offs |
| — | [ADRs](docs/adr/) | 5 decisões arquiteturais registradas (GCP, Pub/Sub, GKE Autopilot, Cloud Run, IAP) |

## Diagramas

| Diagrama | Descrição |
|---|---|
| [Topologia Geral](diagrams/01-topologia-geral.md) | Infraestrutura completa: on-prem, borda, aplicação, dados, segurança e DR |
| [Fluxo de Requisição](diagrams/02-fluxo-requisicao.md) | Sequência de uma criação de lançamento até a persistência no banco |
| [Fluxo de DR](diagrams/03-fluxo-dr.md) | Replicação entre regiões primária e secundária |
| [Camadas OSI](diagrams/04-camadas-osi.md) | Mapeamento de controles por camada OSI |

## Infraestrutura como Código - IaC

Todo o ambiente GCP é provisionado via Terraform com módulos independentes:

| Módulo | Recurso |
|---|---|
| `terraform/modules/network` | VPC, sub-redes, Cloud NAT, firewall |
| `terraform/modules/gke` | Cluster GKE Autopilot |
| `terraform/modules/pubsub` | Tópico Pub/Sub, assinatura com retry/backoff e Dead Letter Topic |
| `terraform/modules/cloud-sql` | PostgreSQL 15 com HA regional, PITR e acesso privado |
| `terraform/modules/redis` | Memorystore Redis STANDARD_HA 2 GB em rede privada |
| `terraform/modules/cloud-run` | Serviço Consolidado com service account dedicada e limites de escala |

A pipeline em `.github/workflows/terraform.yml` executa `fmt`, `validate` e `plan` em todo PR, e `apply` automaticamente no merge em main, autenticando no GCP via Workload Identity sem chaves estáticas.

O hardening das VMs on-premises é automatizado via Ansible em `ansible/`.

## Escolhas e definições: 

- **GKE Autopilot** para o serviço de lançamentos: tráfego HTTP contínuo, controle de recursos por pod e integração com Cloud Armor via Load Balancer.
- **Cloud Run** para o consolidado: acionado por eventos Pub/Sub via pull, escala a zero em baixa demanda e custo reduzido fora dos picos.
- **Pub/Sub com DLQ** como backbone de desacoplamento: garante tolerância a falhas do consolidado sem impactar os lançamentos.
- **IAP em vez de Bastion**: elimina portas SSH expostas; acesso administrativo mediado por identidade e auditável.
- **Partner Interconnect + VPN HA**: link dedicado de produção com fallback automático para VPN em caso de falha.
