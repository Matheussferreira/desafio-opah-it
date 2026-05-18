# Segurança

Escolha dos protocolos de administração e comunicação, modelo de identidade e acesso, proteção de borda com WAF e a estratégia de criptografia end-to-end.

## IAM e identidade
- Princípio do mínimo privilégio para todas as contas de serviço.
- Workload Identity no GKE para evitar uso de chaves estáticas.
- IAM granular para Cloud Run, Cloud SQL, Pub/Sub e Secret Manager.

## Segredos e acesso
- Secret Manager para credenciais e tokens.
- IAP para acesso administrativo sem expor SSH/Bastion.
- Cloud Armor para filtrar tráfego malicioso na borda.

## Protocolos e criptografia
- HTTPS com TLS 1.3 em todas as fronteiras públicas.
- mTLS interno via service mesh planeado para etapas futuras (Anthos Service Mesh).
- Criptografia em repouso por padrão e CMEK para dados regulados.
- VPC Service Controls para segmentar Cloud SQL e reduzir risco de exfiltração.

## Regras de proteção
- Regras OWASP Top 10 no Cloud Armor.
- Políticas de firewall baseadas em zero trust na VPC.
- Auditoria de login e acessos em Cloud Audit Logs.

## Justificativa de protocolos de administração e monitoramento

| Protocolo | Uso | Justificativa |
| --- | --- | --- |
| HTTPS/TLS 1.3 | Toda comunicação pública e entre serviços | Criptografia moderna com perfect forward secrecy e SSH clássico não escala para serviços cloud-native |
| IAP (Identity-Aware Proxy) | Acesso administrativo a GKE e VMs | Elimina a necessidade de portas SSH expostas e acesso baseado em identidade e contexto, auditável por Cloud Audit Logs |
| SSH via IAP Tunneling | Acesso a VMs on-prem ou GKE nodes quando necessário | Tunnel criptografado sem IP público e acesso mediado por IAP garante MFA e logging |
| HTTPS/REST | APIs de Lançamentos e Consolidado | Interoperabilidade, suporte a balanceamento de carga e terminação TLS no Cloud LB |
| gRPC/HTTP2 | Comunicação futura entre microsserviços (ex: Anthos SM) | Eficiência de serialização e suporte a streaming bidirecional para serviços com alta frequência de chamadas |
| SNMP / Cloud Monitoring API | Monitoramento de rede e infraestrutura | Cloud Monitoring substitui SNMP clássico em ambientes GCP e VMs on-prem podem exportar métricas via Ops Agent |
| BGP | Roteamento entre on-prem e GCP via Partner Interconnect | Protocolo padrão de roteamento dinâmico para links dedicados |
