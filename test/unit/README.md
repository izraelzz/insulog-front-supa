# Testes unitários do frontend

## Executar

Com Flutter instalado e compatível com o `pubspec.yaml`:

```bash
flutter pub get
flutter test test/unit
```

São **36 testes em 6 arquivos**, usando `flutter_test`, que já era dependência do projeto. Alguns testes percorrem várias entradas para verificar uma mesma regra.

Não é necessário iniciar backend, Supabase, navegador, emulador ou aplicativo Linux. Os testes usam `test(...)` para instanciar classes e verificar suas regras diretamente. Não executam navegação, envio de formulários para a API ou persistência real.

## Comportamentos cobertos

| Arquivo | Testes | O que verifica |
| --- | ---: | --- |
| `api_date_time_formatter_test.dart` | 5 | Formatação com zeros; combinação de data e hora de seletores diferentes; ano bissexto; leitura SQL/ISO/sem segundos; offset explícito; data ausente ou texto inválido. |
| `registro_glicose_test.dart` | 8 | Leitura de números textuais e campos alternativos da API; cores por status; cálculo e arredondamento da média; lista vazia; resposta direta/envelopada; rejeição de lista malformada; JSON de novo registro e lembrete. |
| `clock_alarm_draft_test.dart` | 4 | Omissão de vínculos ausentes no JSON; inclusão de vínculos e preferências explícitas; cópia sem alterar o original; conversão para registro local; leitura de dias, IDs e booleanos da API. |
| `login_form_state_test.dart` | 6 | Estado inicial; mínimo de três caracteres; notificação de ouvintes; campos obrigatórios após tentativa; limpeza de erro ao editar texto; manutenção do erro ao mover cursor; limpeza do formulário. |
| `register_form_state_test.dart` | 6 | Estado inicial; nome/senha mínimos; sobrenome opcional com validação quando informado; formato do e-mail; campos obrigatórios após tentativa; limpeza de dados e erros. |
| `glucose_record_form_screen_state_test.dart` | 7 | Glicose e período obrigatórios; insulina opcional, mas quantidade e tipo devem estar juntos; limites 0–999; botões e controllers; destaque/remoção de erros; montagem do registro; preenchimento da edição. |

As expectativas representam as regras já implementadas. Nenhuma regra foi adicionada ou corrigida na aplicação para fazer os testes passarem.

## Isolamento e repetibilidade

As classes de estado são recriadas a cada teste e descartadas com `dispose()`, liberando controllers e timers. Nos testes do formulário de glicose, o ID global é definido para um usuário fictício e restaurado no final. As verificações de data utilizam datas explícitas.

Os métodos de validação são exercitados por controllers e métodos públicos, sem chamar a API. Os testes de modelos conferem os mapas JSON em memória, sem enviar dados. Por isso são testes de unidade; os testes de integração e sistema permanecem separados.

## Relação com a atividade e CI

O PDF Aula 05 pede rastreabilidade entre comportamento e teste (página 16), CI automático (página 19) e isolamento de função/regra pequena (página 20). A tabela acima faz essa ligação com o código disponível. Não foram inventados identificadores RF/RN, pois o PDF não contém a especificação particular do Insulog.

O workflow existente já executa `flutter test`, que descobre automaticamente `test/unit/`. Assim, não foi necessário alterar o CI, as dependências ou as configurações de plataforma. A execução automática acontecerá quando estas alterações forem enviadas a um Pull Request para `main` ou a um push em `main`, conforme os gatilhos existentes.

## Validação local em 11/09/2026

- Linux, Flutter 3.47.1 e Dart 3.13.1.
- `flutter test test/unit`: **36 aprovados, nenhuma falha**.
- `flutter test --no-pub --reporter expanded`: **37 aprovados**, incluindo o smoke preexistente.
- `flutter analyze test/unit`: **nenhum problema encontrado**.
- Novos arquivos Dart formatados com `dart format test/unit`.

Os testes de `integration_test/`, o aplicativo Linux completo e o GitHub Actions remoto não foram executados nesta entrega de unitários. Não houve push ou merge.

Somente arquivos novos em `test/unit/` foram adicionados. Nenhum arquivo de `lib/`, teste preexistente, dependência, lockfile ou configuração de plataforma foi alterado.
