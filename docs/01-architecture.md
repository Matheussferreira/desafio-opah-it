# Arquitetura

Essa é a visão geral da solução arquitetural. A empresa XPTO está em transformação digital e precisa de uma infraestrutura híbrida capaz de suportar dois serviços de negócio, controle de lançamentos e consolidado diário com alta disponibilidade, resiliência e baixo custo operacional. Abaixo estão os serviços GCP escolhidos, a lógica de desacoplamento entre os sistemas, os padrões de resiliência adotados e a estratégia de integração on-premises com a nuvem.

## Visão geral
A solução é híbrida, com integração on-prem para GCP. O serviço de lançamentos roda no GKE Autopilot e publica eventos no Pub/Sub. O serviço de consolidado roda no Cloud Run e processa mensagens no próprio ritmo. Dados críticos ficam no Cloud SQL PostgreSQL e o cache de leitura no Memorystore Redis.

## Como esta solução atende os requisitos
- **Disponibilidade**: O serviço de lançamentos não depende da disponibilidade imediata do consolidado.
- **Carga de pico**: o consolidado suporta 50 req/s com escala horizontal pelo Cloud Run.
- **FinOps e automação**: Utilizamos o Terraform e os módulos para infraestrutura repetível.
- **Segurança e DR**: Inclusão do Cloud Armor, IAP, Cloud SQL HA e backup.

## Requisitos não funcionais
- O serviço de lançamentos não fica indisponível se o consolidado cair, porque o fluxo é desacoplado via Pub/Sub.
- O consolidado é projetado para 50 requisições por segundo com tolerância de perda inferior a 5%.

## Serviços GCP usados
| Serviço | Função | Justificativa |
| --- | --- | --- |
| GKE Autopilot | Lançamentos | API HTTP com tráfego contínuo, escalabilidade automática e gestão simplificada |
| Cloud Run | Consolidado | Processamento event-driven e escala a zero, ideal para consumo assíncrono |
| Pub/Sub | Desacoplamento | Garantia de retry, retenção e DLQ para falhas no consolidado |
| Cloud SQL PostgreSQL | Persistência | Banco relacional gerenciado, HA regional e réplica de leitura |
| Memorystore Redis | Cache | Redução de latência em consultas de leitura |
| Cloud Storage | Backups | Armazenamento de backups e dados frios |
| Cloud Load Balancing HTTPS | Entrada | Balanceamento global seguro e terminador de TLS |
| Cloud Armor | WAF | Proteção contra OWASP Top 10 e camadas de aplicação |
| Partner Interconnect | Conexão | Conexão dedicada on-prem e GCP com baixa latência |
| Cloud VPN HA | Fallback | Backup seguro para interconexão em caso de falhas |
| IAP | Administração | Acesso administrativo seguro sem portas SSH expostas |
| Secret Manager | Segredos | Gestão centralizada de credenciais e segredos |
| Artifact Registry | Imagens | Repositório privado para imagens de container |
| Cloud Monitoring | Observabilidade | Métricas, logs e alertas |
| Cloud Logging | Logs | Coleta centralizada de logs de aplicação e infraestrutura |
| Cloud Trace | Rastreio | Diagnóstico de latência em transações |

## Diagrama topológico
O diagrama de topologia geral está em `diagrams/01-topologia-geral.md`.

## Fluxo de dados
1. Usuário envia requisição para criação de lançamento.
2. Requisição chega ao Cloud Load Balancer HTTPS protegido pelo Cloud Armor.
3. O tráfego é direcionado ao serviço de lançamentos no GKE Autopilot.
4. O serviço publica evento `transaction.created` no Pub/Sub.
5. O serviço de consolidado no Cloud Run consome a mensagem assincronamente.
6. O consolidado grava resultados no Cloud SQL e atualiza cache no Redis.

## GKE vs Cloud Run
- Escolhi o GKE Autopilot para o lançamentos porque o serviço tem tráfego contínuo, requer controle de pod-level e beneficia-se da capacidade de rede e da configuração de container mais robusta.
- O Cloud Run é ideal para o consolidado porque o serviço é acionado por eventos, pode escalar a zero e reduz custo em períodos de baixa carga.

## Estratégia híbrida (On-prem e Cloud)
- On-prem: Sistemas legados, rede interna, VMs residuais e conectividade de backend.
- Cloud: Novos serviços, integração de dados e serviços gerenciados.
- Migrar: A API de lançamentos e processador de consolidado para GCP, mantendo replicação de dados e sincronia com on-prem.
- Residual on-prem: As VMs de integração, sistemas de ERP e batch que ainda não migraram.

**Vantagens do modelo híbrido**: Aproveita investimentos existentes em hardware e licenças on-prem enquanto adiciona elasticidade da nuvem para picos de demanda e também reduz o risco de migração big-bang.

**Desafios**: A latência na comunicação entre on-prem e GCP via Interconnect/VPN exige monitoramento, governança de identidade unificada entre ambientes, backup e DR cross-environment, o que deve exigir orquestração adicional.

## Padrões de resiliência
- **Circuit breaker**: Caso o consolidado apresente falhas consecutivas no processamento de mensagens, o Pub/Sub retém as mensagens (até 7 dias) e a DLQ recebe os eventos que esgotam as tentativas de retry. O serviço de lançamentos nunca é bloqueado, porque a publicação no tópico é desacoplada do consumo.
- **Retry com backoff exponencial**: O Cloud Run aplica política de retry automático com backoff antes de encaminhar para a Dead Letter Topic.
- **Cache Redis**: O Memorystore Redis fica na frente das leituras frequentes ao Cloud SQL, reduzindo latência e absorvendo picos de consulta.
- **Rate limiting no Cloud Armor**: As regras de throttling na borda protegem e cercam os serviços de tráfego abusivo antes de chegar à camada de aplicação.
