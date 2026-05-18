# GKE Autopilot vs Standard

## Contexto
É necessário um ambiente Kubernetes para o serviço de lançamentos, mas com menor sobrecarga de gestão.

## Decisão
Adotar o GKE Autopilot em vez do GKE Standard.

## Dinâmica
- Menor configuração de cluster e gerenciamento automático de nós.
- Restrições em configurações avançadas de nós e storage.
- Melhor alinhamento com o requisito de disponibilidade e tempo de operação reduzido.

## Alternativas consideradas
- GKE Standard possui maior controle e flexibilidade, porém mais custo e operação.
