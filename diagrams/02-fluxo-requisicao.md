sequenceDiagram
  participant Cliente
  participant LB as Cloud LB + Cloud Armor
  participant GKE as GKE Autopilot
  participant PubSub as Pub/Sub
  participant DLQ as Pub/Sub DLQ
  participant CloudRun as Cloud Run
  participant Redis as Memorystore Redis
  participant SQL as Cloud SQL

  Cliente->>LB: POST /lancamentos (HTTPS)
  LB->>GKE: tráfego validado pelo WAF
  GKE-->>Cliente: 202 Accepted
  GKE->>PubSub: publish transaction.created

  loop workers ativos (pull model)
    CloudRun->>PubSub: pull sub-consolidado
    PubSub-->>CloudRun: mensagem transaction.created
    CloudRun->>SQL: persiste consolidado
    CloudRun->>Redis: atualiza cache de leitura
    CloudRun->>PubSub: ack mensagem
  end

  alt falha no processamento
    CloudRun->>PubSub: nack (até 5 tentativas c/ backoff)
    PubSub->>DLQ: encaminha para topic-transactions-dlq
  end
