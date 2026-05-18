# Estratégia IaC

Toda a camada de infraestrutura GCP é gerenciada com Terraform e a configuração de VMs on-premises é automatizada com Ansible. O fluxo de trabalho de deploy, a separação por ambiente e como a pipeline de CI/CD garante que nenhuma mudança chegue a produção sem revisão e validação.

## Abordagem
- Terraform para infraestrutura GCP.
- Ansible para hardening e configuração de VMs on-prem.
- Módulos para rede, GKE, Pub/Sub, Cloud SQL e Cloud Run.

## Estrutura de módulos
- `terraform/modules/network` = VPC, subnets, Cloud NAT, firewall.
- `terraform/modules/gke` = cluster GKE Autopilot.
- `terraform/modules/pubsub` = tópico Pub/Sub, DLQ e subscrição.
- `terraform/modules/cloud-sql` = instância PostgreSQL HA + réplica.
- `terraform/modules/cloud-run` = serviço Consolidado.

## Backend remoto
- `backend.tf` usa o GCS bucket para estado remoto.
- Locking de estado por meio do backend Terraform no GCS.
- Exemplo de bucket: `gs://<seu-bucket-terraform>/state`.

## Workflow recomendado
1. Branch feature.
2. PR com revisão de código e variáveis.
3. `terraform init` e `terraform plan` no pipeline.
4. Merge após aprovação.
5. `terraform apply` em ambiente controlado.

## Ambientes
- `dev`, `hml`, `prd` com workspaces ou pastas separadas.
- Variáveis específicas por ambiente.
- Controle de acesso e revisão antes de aplicar em produção.

## Pipeline de automação
- GitHub Actions ou Cloud Build executa `terraform init`, `terraform fmt`, `terraform validate`, `terraform plan`.
- Revisão de PRs com alterações de infraestrutura antes do merge.
- Deploy de produção somente após aprovação e revisão de custos.

## Como o Terraform responde aos requisitos
- Reutilização de módulos para manter o design limpo.
- Backend remoto para garantir estado compartilhado e bloqueio.
- Estrutura clara para separar rede, Kubernetes, mensageria, banco e serverless.
- Ansible para automação de hardening de VMs on-prem, mostrando a integração entre cloud e legado.
