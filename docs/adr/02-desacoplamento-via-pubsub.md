# Desacoplamento via Pub/Sub

## Contexto
O requisito exige que o serviço de lançamentos continue disponível mesmo se o consolidado falhar.

## Decisão
Usar Pub/Sub para desacoplar a emissão de eventos do processamento do consolidado.

## Dinâmica
- O serviço de lançamentos não depende da disponibilidade imediata do consolidado.
- Mensagens podem ser retidas por até 7 dias.
- Deve-se gerenciar tamanho da fila e DLQ.

## Alternativas consideradas
- Chamadas síncronas HTTP: Alta acoplagem e maior risco de falha.
- Banco de mensagens interno no GKE: Mais gerenciamento e custo operacional.
