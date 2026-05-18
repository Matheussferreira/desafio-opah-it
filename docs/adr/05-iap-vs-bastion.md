# IAP em vez de bastion

## Contexto
Necessário acesso administrativo seguro a serviços e clusters sem expor SSH publicamente.

## Decisão
Usar Identity-Aware Proxy - IAP para acessar recursos administrativos.

## Dinâmica
- Sem portas SSH expostas para a internet.
- Controle centralizado de acesso com contexto de usuário.
- Dependência de IAP e identidade gerenciada.

## Alternativas consideradas
- O Bastion host aumentaria a superfície de ataque e exigeria manutenção de VM adicional.
- A VPN exclusiva de administração tem mais complexidade operacional.
