# Fluxo de Rede

A jornada de uma requisição de lançamento desde o usuário até o banco de dados, o processamento assíncrono do consolidado via Pub/Sub, o acesso administrativo seguro sem exposição de SSH, e a sincronização de dados entre o ambiente on-premises e a VPC no GCP.

## Fluxo de criação de lançamento
1. Cliente envia POST para API de lançamentos.
2. Requisição entra pelo Cloud Load Balancer HTTPS.
3. Cloud Armor valida e encaminha para o GKE Autopilot.
4. Serviço de lançamentos publica evento em Pub/Sub.
5. Mensagem fica disponível para o consolidado processar.

## Fluxo assíncrono do consolidado
O Consolidado usa modelo **pull**, o serviço busca ativamente mensagens da assinatura Pub/Sub em vez de aguardar o Pub/Sub chamar um endpoint HTTP.

1. O serviço de consolidado (Cloud Run, `min_instances=2`) mantém workers ativos que chamam `pull` na assinatura `sub-consolidado`.
2. A assinatura retorna mensagens `transaction.created` com `ack_deadline` de 60 segundos.
3. O serviço processa e grava o consolidado no Cloud SQL PostgreSQL.
4. Cache Redis é atualizado para leituras frequentes de saldo/período.
5. O serviço confirma a mensagem com `ack`. Em caso de falha, o `nack` devolve a mensagem ao Pub/Sub.
6. Após 5 tentativas com backoff exponencial (10 s a 600 s), a mensagem vai para o Dead Letter Topic `topic-transactions-dlq`.

A escolha por pull (em vez de push) foi deliberada, o modelo pull permite controle explícito de concorrência e backpressure, já o serviço nunca processa mais mensagens do que consegue ackear dentro do `ack_deadline`.

## Fluxo administrativo via IAP
- Acesso de operadores e times de administração passa por IAP e Cloud Identity.
- Não há exposição direta de portas SSH ao público.

## Fluxo de sincronização com on-prem
- Partner Interconnect leva tráfego de rede de produção principal.
- Cloud VPN HA é fallback para conectividade.
- Rotas privadas e peering garantem comunicação segura entre data center e VPC.

## Kubernetes vs Serverless

A escolha entre o GKE Autopilot e Cloud Run não é arbitrária, cada modelo se encaixa em um perfil de carga diferente.

| Critério | GKE Autopilot (Lançamentos) | Cloud Run (Consolidado) |
| --- | --- | --- |
| Perfil de tráfego | Contínuo e previsível, com picos de horário comercial | Event-driven, acionado por mensagens Pub/Sub |
| Escala a zero | Não (min 2 pods para disponibilidade) | Sim, mas mantemos min_instances=2 em produção |
| Tempo de resposta exigido | Síncrono, < 300 ms p95 | Assíncrono, tolerante a latência maior |
| Configuração de container | Controle de recursos, probes e sidecars | Runtime gerenciado, menos controle de nível de pod |
| Custo base | Maior (recursos reservados) | Menor (paga por invocação e tempo de execução) |
| Uso de rede interna | Sim (peering VPC, Cloud SQL direto) | Sim (VPC connector para acesso privado) |

**Regra de decisão**: Se o serviço tem tráfego HTTP síncrono contínuo e precisa de controle granular de recursos, usa o GKE Autopilot. Se o serviço é acionado por eventos ou mensagens e tolera escala a zero usa o Cloud Run.

**Orquestração integrada**: O GKE Autopilot gerencia o serviço de Lançamentos com HPA baseado em CPU/RPS. O Cloud Run escala instâncias conforme a profundidade da fila Pub/Sub, garantindo que 50 req/s sejam absorvidos com no máximo 5% de perda.
