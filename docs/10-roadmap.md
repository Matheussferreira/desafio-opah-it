# Roadmap

A solução entregue neste desafio representa o núcleo funcional da arquitetura híbrida, mas há evoluções relevantes que poderiam ser incorporadas com mais tempo de projeto. Listei as próximas iniciativas planejadas, as evoluções tecnológicas que fariam sentido para o negócio a médio prazo, e os trade-offs que guiariam essas decisões. A ideia é que este roadmap sirva como base para conversas com o time de produto e engenharia sobre onde investir esforço após a fase inicial de migração.

## Próximos passos
- Implementar **Anthos Service Mesh** para observabilidade de serviço e mTLS interno.
- Adotar **GitOps com ArgoCD** para deploy contínuo de cluster e aplicações.
- Usar **Kubecost** para FinOps avançado em Kubernetes.
- Incluir **Chaos Engineering** com Chaos Mesh para testar resiliência.
- Evoluir para **data mesh** e catalogação de eventos transacionais.

## Evolução tecnológica
- Avaliar **BigQuery** para análises históricas de fluxo de caixa.
- Inserir **Vertex AI** para detecção de anomalias de fraude.
- Expandir os dados para **Cloud Storage Archive** e lifecycle policies.

## Trade-offs
- Mesa de serviço gerenciado reduz esforço operacional mas aumenta custo unitário.
- Analisar se Anthos é necessário para governança multi-cloud futura ou se basta Cloud Run/GKE.
- Balancear rapidez de deploy com segurança e controles de acesso.
