# Shee Elf App

Aplicativo Flutter para gerenciamento de uma biblioteca pessoal. A aplicação
permite autenticar usuários, consultar a biblioteca e escanear livros. A
interface está disponível em português e inglês.

## Pré-requisitos

Antes de começar, instale:

- Flutter com suporte ao Dart `3.13.2` ou superior compatível com o projeto;
- Android Studio e um emulador Android, ou um dispositivo físico;
- Xcode, caso o desenvolvimento seja feito em macOS para iOS;
- Uma API compatível executando localmente ou em um ambiente acessível pelo
  dispositivo.

Confira a instalação do Flutter com:

```bash
flutter doctor
```

Resolva os itens críticos reportados pelo comando antes de executar o app.

## Configuração local

1. Clone o repositório e entre na pasta do projeto.
2. Instale as dependências:

	```bash
	flutter pub get
	```

3. Crie o arquivo `.env` a partir do exemplo:

	```bash
	copy .env.example .env
	```

	No macOS ou Linux, use `cp .env.example .env`.

4. Edite o `.env` e informe o endereço da API:

	```env
	API_BASE_URL=http://IP_DA_MAQUINA:3000
	```

O arquivo `.env` é ignorado pelo Git. Não adicione credenciais, tokens ou
outras informações sensíveis ao repositório.

### Endereço da API no Android

Para um emulador Android, `127.0.0.1` aponta para o próprio emulador, não para
a máquina de desenvolvimento. Use o IP da máquina na rede local, como no
`.env.example`. Em alguns emuladores Android, `10.0.2.2` pode ser usado para
acessar o `localhost` da máquina host.

Em um dispositivo físico, o celular e o computador precisam estar na mesma
rede, e a API deve aceitar conexões no IP informado. Verifique também se o
firewall permite o acesso à porta `3000`.

## Executando o projeto

Liste os dispositivos disponíveis:

```bash
flutter devices
```

Inicie a aplicação no dispositivo selecionado:

```bash
flutter run
```

Para escolher um dispositivo explicitamente:

```bash
flutter run -d <device-id>
```

Durante o desenvolvimento, use `r` no terminal para hot reload e `R` para hot
restart.

## Testes e qualidade

Execute os testes automatizados com:

```bash
flutter test
```

Verifique problemas de análise estática com:

```bash
flutter analyze
```

Antes de abrir um pull request, rode ambos os comandos e confirme que o app
continua iniciando com um `.env` válido.

## Estrutura do projeto

```text
lib/
├── core/                  # Rede, localização e utilitários compartilhados
├── data/                  # Implementações de repositórios e cache
├── domain/                # Entidades e contratos da aplicação
└── presentation/          # Controllers e páginas da interface
```

As dependências são registradas em `lib/main.dart` usando `GetIt`. O cliente
HTTP fica em `lib/core/network/api_client.dart`, e o token de autenticação é
armazenado com `flutter_secure_storage`.

## Comandos úteis

```bash
flutter pub outdated              # Verifica dependências desatualizadas
dart format lib test              # Formata o código Dart
flutter build apk --debug         # Gera um APK de debug
```

## Recursos

- [Documentação do Flutter](https://docs.flutter.dev/)
- [Guia de instalação do Flutter](https://docs.flutter.dev/get-started/install)
- [Documentação do Dart](https://dart.dev/guides)
