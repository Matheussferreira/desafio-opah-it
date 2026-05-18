# Observabilidade

A stack de observabilidade utilizará as ferramentas escolhidas para métricas, logs e rastreamento, os SLIs e SLOs que guiam a confiabilidade dos serviços, os alertas que acionam respostas operacionais, e a proposta de monitoramento para a camada de rede.

## Stack de observabilidade
- Cloud Monitoring para métricas e alertas.
- Cloud Logging para coleta de logs de aplicação e infraestrutura.
- Cloud Trace para rastreamento de latência de ponta a ponta.
- Opcional Grafana integrado ao Cloud Monitoring para dashboards customizados.

## Rede e logs
- VPC Flow Logs para visibilidade de tráfego interno e externo.
- Firewall Logs para auditoria de bloqueios e permissões.
- Cloud Armor logs para inspeção de ataques e regras bloqueadas.
- Network Intelligence Center para análise de conectividade e rotas.

## SLIs/SLOs sugeridos
- Disponibilidade: 99.9% para serviços críticos.
- Latência p95 < 300 ms para API de Lançamentos.
- Taxa de erro < 1% para requisições de produção.

## Alertas críticos
- Profundidade da fila Pub/Sub > 100 mensagens por assinatura.
- Taxa de erro 5xx acima de 1% por 5 minutos.
- Latência p99 do Cloud Run > 600 ms.
- Uso de CPU do Cloud SQL > 70% por mais de 10 minutos.

## Dashboards
- Visão geral de disponibilidade e custos.
- Tráfego de entrada e taxa de requisições.
- Profundidade de fila do Pub/Sub.
- Saúde do Cloud SQL e uso de memória.

## Observabilidade de rede
A camada de rede exige monitoramento separado em um ambiente híbrido, onde as falhas no Interconnect ou VPN podem ser silenciosas para a aplicação até que o tráfego comece a falhar.

| Ferramenta | Propósito |
| --- | --- |
| VPC Flow Logs | Visibilidade de fluxos IP entre sub-redes, VMs e serviços GCP |
| Firewall Logs | Auditoria de conexões aceitas e bloqueadas por regra de firewall |
| Network Intelligence Center | Análise de conectividade ponto a ponto e diagnóstico de rotas |
| Cloud Armor Logs | Registro de requisições bloqueadas/permitidas pelo WAF |
| Partner Interconnect Metrics | Throughput, latência e taxa de erro do link dedicado on-prem |
| Cloud VPN Metrics | Estado dos túneis VPN e eventos de reconexão |

**Alertas de rede críticos**:
- Queda de throughput no Interconnect abaixo de 80% da capacidade contratada.
- Latência round-trip entre on-prem e GCP acima de 20 ms por mais de 5 minutos.
- Túnel VPN HA com ambos os túneis inativos simultaneamente.
- VPC Flow Logs indicando tráfego incomum para sub-redes de dados (Ex: Possível exfiltração).
