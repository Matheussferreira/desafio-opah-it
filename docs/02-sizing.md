# Dimensionamento

Pensando em escalabilidade, é preciso que o serviço de consolidado diário suporte 50 requisições por segundo com perda máxima de 5%. Para isso é ideal saber a quantidade de instâncias Cloud Run, quantidade de CPU e memória para o banco, e como dimensionar os componentes para absorver picos como em dias de Black Friday sem superprovisionamento permanente.

## Cálculo de demanda
O requisito é 50 requisições por segundo no serviço de consolidado. Com tolerância de 5% de perda, vou usar 52 req/s como alvo de capacidade útil.

Estimativa de latência média do consolidado:
- Processamento por mensagem: ~120 ms
- Tempo de rede e overhead: ~80 ms
- Latência total estimada: ~200 ms

Requisições por instância no Cloud Run:
- Concurrency padrão: 10
- Taxa de processamento estimada: 10 req/s por instância
- Instâncias mínimas necessárias: 52 / 10 = 5,2 → 6 instâncias

### Dimensionamento por componente
| Componente | Configuração estimada | Escala | Observação |
| --- | --- | --- | --- |
| GKE Autopilot | CPU 0.5, memória 1Gi por pod, requests automáticos | Horizontal: 2-10 pods | Recomendado para API de lançamentos com tráfego contínuo |
| HPA GKE | min 2 pods / max 10 pods | Horizontal | Ajusta o tráfego contínuo e evita escala excessiva |
| Cloud Run | concurrency 10, min instances 2, max instances 20, CPU 1 vCPU, memória 2Gi | Horizontal | Escala com eventos e reduz custo ocioso |
| Cloud SQL | db-custom-2-7680 (2 vCPU, 7.5 GiB) | Vertical / read replica | Inicia com HA regional e réplica de leitura |
| Redis | standard tier, 2 GB | Vertical | Usa o cache para reduzir leituras diretas em Cloud SQL |

## Estratégia de dimensionamento
- Horizontal: Usa o `max_instances` no Cloud Run e HPA no GKE para ajustar ao tráfego.
- Vertical: Aumenta o Cloud SQL o `db-custom-4-15360` em picos e usar réplica de leitura para offload.
- Picos de promoções devem ser tratados principalmente com escala horizontal e buffer de Pub/Sub.

## Cenário Black Friday
Para pico promocional, vou considerar 10x a carga: 500 req/s.
- No Cloud Run calcular 500 / 10 = 50 instâncias necessárias.
- Ajustar o max instances para 60 e manter concurrency 10.
- No Cloud SQL considerar escala vertical para o `db-custom-4-15360` ou replica adicional.
- No GKE Autopilot ajustar min 5 pods, max 30 pods para suportar bursts de tráfego.

## Observações
- O Pub/Sub desacopla os serviços e permite buffer para spikes de carga.
- O Cloud Run pode escalar rapidamente, mas a latência de cold start deve ser mitigada com `min_instances=2` para produção.
- Em Black Friday, o Redis garante respostas rápidas para leituras e reduz carga no Cloud SQL.
