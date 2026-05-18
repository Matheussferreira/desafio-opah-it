# Modelo OSI

Em um ambiente híbrido com tráfego passando por Interconnect, VPCs, load balancers e serviços gerenciados, gosto de mapear cada decisão de arquitetura e a camada OSI facilita o diagnóstico de incidentes e ajuda a identificar onde aplicar controles adicionais. Fiz esse mapeamento e como usar o modelo em situações de troubleshooting.

## Mapeamento OSI
| Camada | Decisão | Exemplo |
| --- | --- | --- |
| L7 Aplicação | Cloud Armor, Cloud LB HTTPS, API Gateway | Proteção contra ataques de aplicação e roteamento seguro |
| L6 Apresentação | TLS 1.3, certificados gerenciados | Criptografia de dados em trânsito |
| L5 Sessão | IAP, OAuth2/OIDC | Controle de sessão e autenticação de usuários/admin |
| L4 Transporte | NLB, regras de firewall, Cloud SQL TCP privado | Transmissão confiável de pacotes TCP/UDP |
| L3 Rede | VPC, subnets, rotas, Cloud NAT, Interconnect | Segmentação e roteamento de tráfego |
| L2 Enlace | VLANs do Partner Interconnect | Conexão física entre on-prem e GCP |
| L1 Física | Responsabilidade do provedor e fibra | Infraestrutura física de rede e energia |

## Diagnóstico por camada

### Cenário 1: latência alta nas APIs
1. **L7 (Aplicação)**: Verificar logs do Cloud Armor para regras ativas desnecessárias, análise de latência do Cloud LB com Cloud Trace.
2. **L6 (Apresentação)**: Confirmar versão de TLS negociada e ausência de renegociação desnecessária.
3. **L4 (Transporte)**: Verificar conexões TCP lentas no Cloud SQL e analisar timeouts de conexão no firewall.
4. **L3 (Rede)**: Checar VPC Flow Logs para tráfego com alto RTT e verificar rota do Interconnect vs VPN.

### Cenário 2: falha de conectividade on-prem / GCP
1. **L3**: Confirmar se o BGP entre on-prem e Partner Interconnect está anunciando as rotas corretas.
2. **L2**: Cerificar status do VLAN attachment no Interconnect e detectar erros de frame com o provedor.
3. **L4**: Checar se firewall na VPC está bloqueando a porta/protocolo e usar Network Intelligence Center para teste de conectividade.

### Cenário 3: tráfego bloqueado para o serviço de Lançamentos
1. **L7**: Inspecionar logs do Cloud Armor para verificar se requisição foi bloqueada por regra OWASP.
2. **L4**: Verificar regras de firewall da VPC e health checks do Cloud LB.
3. **L3**: Confirmar que pod GKE está em sub-rede com rota correta para o LB.

## Controles de segurança por camada OSI
| Camada | Controle aplicado |
| --- | --- |
| L7 | Cloud Armor (WAF), rate limiting, bloqueio de IPs |
| L6 | TLS 1.3 obrigatório |
| L5 | IAP com verificação de identidade e contexto antes de abrir sessão |
| L4 | Regras de firewall least-privilege, Cloud SQL com acesso via IP privado apenas |
| L3 | VPC Service Controls, segmentação de sub-redes por serviço |
| L2 | VLANs privadas no Partner Interconnect, sem acesso direto à rede pública |
| L1 | Responsabilidade do Google e do provedor de colocation on-prem |
