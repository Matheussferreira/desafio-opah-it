# Cloud Run para Consolidado

## Contexto
O serviço de consolidado é acionado por eventos e tem picos irregulares de processamento.

## Decisão
Executar o serviço de consolidado no Cloud Run.

## Dinâmica
- Escala automática e custo reduzido em períodos de baixa demanda.
- Latência de cold start mitigada com mínimo de instâncias em produção.
- Pode ser modelado para arquitetura event-driven.

## Alternativas consideradas
- O GKE poderia ser usado, mas aumentaria custo e complexidade em relação ao serverless.
- Cloud Functions possuí menos controle de runtime e limites de tempo mais restritos.
