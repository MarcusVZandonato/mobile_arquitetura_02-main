# Respostas sobre a Arquitetura

## 1) Em qual camada foi implementado o mecanismo de cache?
O mecanismo de cache foi implementado na **camada de Data**, por meio de um DataSource específico (`ProductCacheDatasource`) e utilizado dentro do repositório (`ProductRepositoryImpl`).

Essa decisão é adequada porque, na arquitetura proposta, a camada de Data é responsável por detalhes de acesso e persistência de dados (remotos e locais). Assim, a camada de Presentation e a camada de Domain permanecem desacopladas de detalhes técnicos de armazenamento, dependendo apenas da abstração do repositório.

## 2) Por que o ViewModel não deve realizar chamadas HTTP diretamente?
Porque o ViewModel pertence à camada de Presentation e deve focar em estado de tela e regras de interação com a UI.

Se ele fizer HTTP diretamente:
- ocorre violação de responsabilidade única;
- aumenta o acoplamento com infraestrutura de rede;
- dificulta testes unitários (mock de rede dentro da UI);
- reduz reutilização de regras de negócio em outros fluxos.

Ao depender de `ProductRepository`, o ViewModel recebe dados já tratados e mantém separação clara entre apresentação e dados.

## 3) O que poderia acontecer se a interface acessasse diretamente o DataSource?
Se a interface (tela/ViewModel) acessar o DataSource diretamente, alguns problemas comuns seriam:
- forte acoplamento da UI com detalhes de implementação (HTTP, cache, parsing);
- duplicação de lógica de fallback e tratamento de erros em múltiplas telas;
- maior risco de regressões ao trocar API, formato de resposta ou estratégia de cache;
- redução da manutenibilidade e da testabilidade.

Em resumo, a UI passaria a carregar responsabilidades que deveriam estar na camada de Data/Repository.

## 4) Como essa arquitetura facilitaria a substituição da API por um banco de dados local?
A substituição fica simples porque a camada de Presentation conversa com a abstração do domínio (`ProductRepository`), não com uma fonte específica.

Na prática, bastaria:
- criar um novo DataSource local (por exemplo, SQLite/Hive);
- adaptar a implementação do repositório para usar essa fonte local (ou combinar local + remoto);
- manter a interface do repositório igual (`getProducts()`).

Como ViewModel e UI continuam dependentes apenas do contrato do repositório, eles não precisam ser alterados (ou exigem alterações mínimas).