# Teste de sistema: registro e histórico de glicose

Há **um único cenário novo**, em `integration_test/glucose_history_test.dart`.
Ele executa o aplicativo Flutter desktop, a API Node/Express real e PostgreSQL
descartável. A medição é criada pelos widgets do aplicativo e conferida nos
widgets do relatório, sem mocks de HTTP, serviços, repositórios ou persistência.
SQL serve apenas para preparar schema, usuário e período. Por isso o escopo é
de sistema, embora a ferramenta do SDK se chame `integration_test`.

## Cenário e resultado esperado

1. Criar um banco vazio, um usuário com email UUID em `example.invalid` e senha
   aleatória com o hash do próprio back-end; inserir período `1 = Jejum`, como
   exige o mapeamento existente dos botões do front-end.
2. Preparar as preferências reais de login. O aplicativo abre por `main()` e
   executa seu autologin normal (`POST /login`) para obter o usuário autenticado.
   Não há cenário de login/cadastro nem desvio de autenticação em produção.
3. Abrir **Novo Registro**, digitar **100**, selecionar data e **12:00** nos
   diálogos Material, escolher **Jejum**, avançar sem insulina e registrar com
   **Criar Lembrete** desligado. Conferir também os detalhes antes de salvar.
4. Aguardar a saída do formulário, que só ocorre após o POST concluir.
5. Abrir **Relatório**, selecionar o mês e dia da medição; verificar uma única
   linha **100 mg/dL**, **12:00**, **Jejum**, agrupada sob **DIA 1**, além do mês,
   ano e **Média = 100** apresentados na interface.
6. Selecionar dia 2 e aguardar a lista vazia e média zero; selecionar novamente
   dia 1 e repetir as verificações. Isso exige novas consultas reais ao histórico
   e impede que uma linha antiga em memória satisfaça a segunda conferência.
7. Restaurar as preferências anteriores e destruir banco, volume e processos
   desta execução em `finally`, inclusive quando há falha.

Data: **primeiro dia do mês UTC anterior ao início da execução**, capturado uma
única vez em `SYSTEM_DATE` e registrado em `execution.log`. É conhecido antes do
cenário, nunca é futuro e evita navegar por muitos meses. O intervalo é esse dia
das 00:00:00 às 23:59:59. API e PostgreSQL usam UTC. O contrato atual envia data e
hora civis sem offset e devolve ISO UTC; o front-end lê seus campos diretamente,
sem `toLocal()`. A asserção exige 12:00 também no Windows com fuso local diferente.
Não se altera o relógio nem o fuso global do computador.

O relatório não repete a data completa em cada linha: dia vem do agrupamento,
mês/ano vêm do cabeçalho. O teste confere essa apresentação existente. A tela de
confirmação mostra `!!! - 0 un` quando não há insulina; o teste registra essa
limitação atual sem adicionar funcionalidade nem mudar regras de negócio.
Trocar abas no `IndexedStack` não refaz `initState` do relatório; por isso a
reconsulta usa os filtros reais, em vez de pressupor atualização ao voltar à aba.

## Ferramentas e versões

- Flutter **3.41.6**, com Dart **3.11.4**, compatível com `sdk: ^3.11.4`.
- `flutter_test` existente e `integration_test` do próprio SDK, única dependência
  direta acrescentada. `flutter_driver`, `webdriver`, `process`, `sync_http` e
  `fuchsia_remote_debug_protocol` entram transitivamente pelo SDK, não são um
  framework externo escolhido para este teste.
- O lockfile foi resolvido com esse SDK; alguns pacotes fixados pelo Flutter
  mudam de versão. Execuções usam `flutter pub get --enforce-lockfile`, nunca
  `pub upgrade` ou atualização automática do lockfile.
- Node.js **24** (validado localmente com 24.13.1), `npm ci` com lockfile do backend.
- Docker com containers Linux, imagem **postgres:16.13**, sem banco externo.
- Desktop **Windows** local (`-d windows`) e desktop **Linux** no CI (`-d linux`),
  ambas plataformas já versionadas. O cenário Dart é o mesmo. Não se usa web
  porque o projeto contém serviços `dart:io`, e o CORS da API é restrito.

O comando de teste desktop segue a [documentação oficial do Flutter](https://docs.flutter.dev/testing/integration-tests).
No Windows, VSCode é o editor; a compilação precisa também de **Visual Studio**
com **Desenvolvimento para desktop com C++**, MSVC, CMake e Windows SDK.
Confira o diagnóstico com `flutter doctor -v`.

## Executar localmente no Windows

Abra Docker Desktop e aguarde o engine Linux estar pronto. Instale Flutter
3.41.6, Git e Node.js 24 e coloque seus executáveis no PATH. No PowerShell:

```powershell
Set-Location C:\front-insulog-devops\insulog-front-supa
git branch --show-current
flutter --version
node --version
docker info
flutter doctor -v
flutter pub get --enforce-lockfile
node scripts/system-test.cjs
```

Nesta preparação foi obtido um SDK isolado em
`C:\front-insulog-devops\flutter-sdk`. Para usá-lo apenas no terminal atual:

```powershell
$env:PATH = 'C:\front-insulog-devops\flutter-sdk\bin;' + $env:PATH
```

Não é necessário preparar um clone de back-end, banco, credenciais ou arquivo
`.env` manualmente. O script cria uma pasta `.system-test/<UUID>/backend`, faz
checkout destacado da revisão fixa, instala dependências, inicia PostgreSQL em
porta livre de loopback, reutiliza o schema, prepara fixtures e inicia a API em
porta livre. A disponibilidade do banco e da API tem timeout.

O comando Flutter interno é:

```powershell
flutter test integration_test/glucose_history_test.dart -d windows --no-pub --dart-define-from-file=.system-test/<UUID>/defines.json --reporter expanded
```

O arquivo temporário só existe durante a execução orquestrada e é removido no
final. Use `node scripts/system-test.cjs` para obter preparação e limpeza juntas.
O teste recusa API fora de `http://127.0.0.1` e exige credenciais de fixture.
`API_BASE_URL` é uma configuração de compilação opcional: quando ausente, o
comportamento original de endereço da API permanece intacto.

As preferências são isoladas via APPDATA/XDG; o teste também restaura credenciais
anteriores em teardown. O banco inteiro é descartado, removendo usuário,
período e medições mesmo se o aplicativo falhar antes do teardown. Não há
`docker prune`, limpeza de branches ou encerramento de processos por nome.
Somente PIDs/árvores e o container de UUID criado pelo script são encerrados.
Logs sanitizados ficam em `.system-test/logs/<UUID>/`; clones de preparação
ficam ignorados pelo Git. Nunca publique `defines.json` ou preferências.

## Revisão do back-end

Repositório: https://github.com/izraelzz/insulog-back-supa

Revisão fixa: **d77b213bd1df8be9d1a9f26b97cf7060cb35e613**, observada na `main`.
O commit **3006b558ccfb05e5ef343b462271f49dde34f82c** de `test/backend-ci` já está
integrado por **15ac490** (PR #2). Portanto, não há dependência oculta de PR aberto.
Reutilizam-se `scripts/prepare-test-db.cjs`, `test/fixtures/base-schema.sql`,
`src/config/registro-glicose-schema.sql` e `passwordService.hashPassword`.
O schema de teste do back-end se declara mínimo, inferido dos repositories;
ele é o recurso versionado disponível, não uma cópia de dados de produção.

Para atualizar: verifique a integração da revisão à principal, revise contratos
e scripts, altere `backendRevision` em `scripts/system-test.cjs`, atualize esta
seção e execute novamente o cenário completo. O clone de trabalho do usuário
não é utilizado nem modificado.

## GitHub Actions

Arquivo: `.github/workflows/frontend-system-test.yml`.

Dispara em push de qualquer branch e PR aberto, reaberto ou atualizado. Configura
Flutter/Dart e Node, instala os pacotes com lockfile, prepara GTK/CMake e Xvfb em
Ubuntu 24.04 e chama a mesma orquestração. As fases do backend, banco, fixtures,
API e cenário estão identificadas nos logs. O job tem limite de 25 minutos,
comando Flutter de 10 minutos e cenário de 4 minutos; condições da UI têm 20s.
Qualquer erro produz exit code diferente de zero, sem `continue-on-error` ou skip.
Permissão única: `contents: read`. Logs sanitizados são anexados em falhas por
7 dias. SIGINT/SIGTERM também acionam limpeza; em término forçado do runner,
a máquina efêmera do Actions elimina seus recursos locais.

Check que o administrador poderá exigir: **Frontend System Test - Glucose History**.
O workflow existente `flutter-tests.yml` foi preservado sem alterações.
Nenhuma configuração administrativa é feita por esta tarefa.

## Validação desta preparação

Branch: `test/frontend-ci`. Commit inicial dessa branch:
`b02a2ac018d5d3f67760fd62c7889137c5c4c3a7`.
O workspace inicialmente estava em `main` no commit
`967716076f07a073a215332f58620f7439c415d3`; a mudança para a branch existente
foi informada antes de editar arquivos. Não havia alterações locais.

O resultado efetivo da execução e eventuais impedimentos estão registrados
abaixo após a validação local. **O workflow foi somente preparado localmente;
não foi executado no GitHub Actions. Não foram feitos commit, push, PR ou merge.**

Validação local em 11/09/2026:

- Flutter 3.41.6 / Dart 3.11.4 confirmados; dependências resolvidas e instalação
  com `--enforce-lockfile` concluída pela orquestração.
- `flutter analyze` nos três arquivos Dart alterados: **No issues found**.
- `node --check scripts/system-test.cjs` e `git diff --check`: sem erros.
- YAML do workflow analisado com o parser `yaml` já disponível no SDK; gatilhos
  e permissões conferidos. `flutter test test`: **1 teste existente passou**.
- Backend fixado, `npm ci`, PostgreSQL 16.13, schema, usuário/período e saúde da
  API (`GET /`, HTTP 200): **executados com sucesso**.
- Primeira tentativa de UI: **não executada**, pois a compilação Windows falhou antes de
  iniciar o aplicativo: `Unable to find suitable Visual Studio toolchain`.
  `flutter doctor -v` aponta ausência de componentes MSVC, CMake e Windows SDK.
  Instale os componentes de desktop C++ no Visual Studio Installer e repita o
  comando. Isso é impedimento de infraestrutura, não falha funcional comprovada
  do aplicativo. A análise estática não substitui a execução do cenário.
- A execução retornou código 1; container e volume foram removidos, assim como
  arquivo de defines e preferências temporárias. Nenhum container do teste ficou
  em execução. Logs dessa tentativa:
  `.system-test/logs/2c336fe9-02f9-4f92-ad1b-609c513ef426/`.
- A execução Linux/Xvfb e o check no GitHub Actions permanecem sem validação
  dinâmica. Naquele momento ainda não havia execução aprovada do teste de sistema.

### Nova execução no Windows

Na execução `aff56eba-bb2b-4158-abb0-737ef1d96e16`, o aplicativo compilou e
iniciou. O POST da medição respondeu 201, a primeira conferência do histórico
foi concluída e o filtro do dia 2 retornou lista vazia e média zero.
Foram encontrados dois problemas:

- O cabeçalho `HomeHeaderWidget` apresenta `RenderFlex overflowed by 720 pixels`
  com o email exclusivo usado no login. `returnNameLogin()` devolve o username
  completo, e o texto da saudação não tem restrição de largura dentro do Row.
  É um defeito de layout do aplicativo. Não foi suprimida a exceção, reduzida
  a fixture ou ampliada a janela para esconder o problema.
- O teste não trazia novamente o botão do dia 1 para a área visível após rolar
  até o dia 2. Foi acrescentado `ensureVisible` antes desse clique, mantendo
  a interação pela interface e todas as verificações de persistência.

Após a correção de rolagem, a execução
`cfc98de4-7928-46b3-8e80-039f6225056b` concluiu também a segunda consulta e
conferência do dia 1, sem timeout. Ainda retornou **1** pelo overflow do
cabeçalho (719 pixels nessa execução). O cenário não está aprovado enquanto
esse defeito de layout permanecer. Container e volume foram removidos.

### Correção do cabeçalho

A execução `b67e937e-6766-4a17-b551-c57ffb885eb6` confirmou novamente o
overflow. Foi então corrigido `lib/widgets/home/home_header_widget.dart`:
a saudação ocupa somente a largura disponível antes do avatar, com uma linha
e reticências para textos longos. Fonte, conteúdo, regras de negócio, fixtures
e verificações do teste foram preservados. A correção resolve o layout real
em vez de suprimir erros de renderização no teste.

Validação após a correção: execução
`cc223e7d-4f5a-47e1-9030-a55f04a5cecc`, em 11/09/2026, no Windows.
**`All tests passed!` — 1 cenário, código final 0.** Registro pela interface,
dados e média no histórico e segunda consulta foram conferidos com API e banco
reais. A limpeza concluiu e o container foi removido. A análise estática do
cabeçalho retornou `No issues found!`. Logs:
`.system-test/logs/cc223e7d-4f5a-47e1-9030-a55f04a5cecc/`.
O workflow permanece somente preparado, sem execução no GitHub Actions.

### Falha posterior no GitHub Actions e ajuste Linux

Após a publicação feita pelo usuário, a execução do Actions `34623391633`
(commit `a73c06852ba62d836bf7ce13cf3ae1b72c27181e`) falhou no Linux.
O artefato `frontend-system-test-logs.zip`, execução interna
`31b6b878-2f36-4d43-98fd-64a29f69dbc1`, comprova compilação, autenticação,
salvamento e consultas reais concluídos. A falha principal foi um overflow
vertical de 17 pixels em uma coluna de botão com espaço de 127 × 81,9 pixels.
Os erros posteriores de `deactivated widget` ocorreram quando o Flutter
tentava descrever esse erro depois que o formulário já havia sido descartado.

O layout vertical de `CustomButtonWidget` foi ajustado com `Flexible` e
`FittedBox(fit: BoxFit.scaleDown)` no rótulo: o texto completo passa a respeitar
o espaço disponível sob o ícone, inclusive quando a fonte da plataforma tem
métricas diferentes. Não se cortam nomes de períodos/tipos de insulina nem
se alteram as ações dos botões. O cenário, a janela 430 × 932, as fixtures e
as verificações de persistência permanecem iguais; erros de renderização
continuam reprovando o teste.

Regressão Windows após esse ajuste: execução
`f0c68e4b-f535-4e48-88b1-fa93791b12e7`, **1 teste aprovado, código 0**, com
API e banco reais e limpeza concluída. A análise do arquivo não encontrou
erros; reportou apenas dois avisos informativos `use_null_aware_elements`
nas verificações de ícones já existentes. O diff foi conferido.

A validação Linux foi preparada em uma cópia separada
`C:\front-insulog-devops\insulog-front-linux-validation`, com Ubuntu 24.04
via WSL, Flutter 3.41.6/Dart 3.11.4, Node 24.13.1 e Xvfb. A instalação local
usa DejaVu Sans como fonte padrão. Nela, a versão anterior também passou:
o overflow específico do runner não foi reproduzido localmente. Portanto,
a hipótese de diferença nas métricas de fonte não deve ser tratada como
causa comprovada; o defeito de restrição de espaço está registrado no ZIP.
O resultado no GitHub ainda depende de nova execução após publicar o ajuste.

Versão corrigida validada no Ubuntu/Xvfb: execução
`ce53c302-e933-463f-94c0-8067b2decfe7`, **`All tests passed!`, 1 cenário,
código 0**. Foi usado o mesmo teste Dart, sem a instrumentação adicional usada
durante o diagnóstico. API, PostgreSQL e fluxo pela interface reais; limpeza
concluída e container removido. Logs na cópia Linux em
`.system-test/logs/ce53c302-e933-463f-94c0-8067b2decfe7/`.
Nenhum commit, push ou disparo remoto foi feito pelo assistente nesta correção.

### Conciliação com o repositório original

Referência conferida: `origin/main` em
`62f6b9349b98bd742d4af5b57a49138b7ff1dc3c`.

- `home_header_widget.dart` parte da versão atual da main: mantém largura de
  referência limitada a 600, altura mínima de 145 no cartão e `Flexible` no
  status. Sobre essa versão permanece a correção da saudação com `Expanded`
  e reticências, necessária para usernames longos.
- `pubspec.yaml` corresponde à main, com uma única declaração de
  `integration_test`. A simulação de união automática havia produzido uma
  declaração duplicada; o arquivo conciliado elimina essa incompatibilidade.
- O README foi restaurado da main. O workflow `flutter-tests.yml`, os dois
  arquivos de integração preexistentes e os seis arquivos de testes unitários
  foram trazidos sem alteração da main. Não são cenários novos desta tarefa.
  O teste de sistema continua sendo executado por caminho explícito, com API
  e banco reais, separado das verificações preexistentes.
- O lockfile fixado segue válido com `flutter pub get --enforce-lockfile`.
- Os 37 testes de `test/` passaram no Windows e no Ubuntu 24.04 com Flutter
  3.41.6. O teste de sistema Windows também passou após a conciliação.

A integra??o local com a main foi registrada para publica??o na branch
`test/frontend-ci`, ap?s autoriza??o de envio. O conflito no cabe?alho foi
resolvido mantendo a vers?o conciliada e validada acima. A integra??o n?o
alterou o conte?do de c?digo j? testado e preservou uma ?nica declara??o
de `integration_test`.
O merge remoto deve aguardar os checks do novo commit.

Validações da conciliação: análise do cabeçalho e do cenário sem problemas;
`flutter pub get --enforce-lockfile` aprovado; `flutter test test` com 37
aprovações em ambos os sistemas; `integration_test/app_test.dart`, usado
pelo workflow original, aprovado no Ubuntu/Xvfb. O teste de sistema Windows
passou na execução `649f1e09-9024-4a7c-a49e-f05e055926c2`, com código 0 e
limpeza concluída. O arquivo de login com API simulada já existente na main
foi preservado, mas não foi acrescentado ao workflow nem usado para validar
o teste de sistema desta tarefa.

O teste de sistema conciliado também passou no Ubuntu/Xvfb:
`3c14d5b8-d312-4394-bca6-d40f376ebe7c`, **1 aprovado, código 0**, com
API e banco reais. A limpeza concluiu e o container foi removido.
