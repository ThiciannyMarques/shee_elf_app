import 'package:flutter/material.dart';

import '../../core/di/service_locator.dart';
import '../../core/utils/app_state.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/library_repository.dart';
import '../controllers/auth_controller.dart';
import '../controllers/library_controller.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _authController = getIt<AuthController>();
  final _libraryController = getIt<LibraryController>();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await _authController.checkAuth();

    if (!mounted) return;

    if (_authController.authState is StateSuccess<User>) {
      final user = (_authController.authState as StateSuccess<User>).data;
      getIt<LibraryRepository>().setSession(user.email);
      await _libraryController.initializeApp();
      if (mounted)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books, size: 80, color: Colors.indigo),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authController = getIt<AuthController>();
  final _libraryController = getIt<LibraryController>();

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authController.addListener(_updateState);
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _authController.removeListener(_updateState);
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _doLogin() async {
    final success = await _authController.login(
      _emailCtrl.text.trim(),
      _passCtrl.text,
    );
    if (success && mounted) {
      getIt<LibraryRepository>().setSession(_emailCtrl.text.trim());
      await _libraryController.initializeApp();
      if (mounted)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _authController.authState;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.menu_book_rounded,
                size: 80,
                color: Colors.indigo,
              ),
              const SizedBox(height: 32),
              const Text(
                'Bem-vindo à sua Biblioteca',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passCtrl,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              if (state is StateError<User>)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: state is StateLoading<User> ? null : _doLogin,
                child: state is StateLoading<User>
                    ? const CircularProgressIndicator()
                    : const Text('Entrar'),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                ),
                child: const Text('Não tem uma conta? Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _authController = getIt<AuthController>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authController.addListener(_updateState);
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _authController.removeListener(_updateState);
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _doRegister() async {
    final success = await _authController.register(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _passCtrl.text,
    );
    if (success && mounted) {
      getIt<LibraryRepository>().setSession(_emailCtrl.text.trim());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InitialCollectionPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _authController.authState;

    return Scaffold(
      appBar: AppBar(title: const Text('Nova Conta')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passCtrl,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              if (state is StateError<User>)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: state is StateLoading<User> ? null : _doRegister,
                child: state is StateLoading<User>
                    ? const CircularProgressIndicator()
                    : const Text('Cadastrar e Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InitialCollectionPage extends StatefulWidget {
  const InitialCollectionPage({super.key});
  @override
  State<InitialCollectionPage> createState() => _InitialCollectionPageState();
}

class _InitialCollectionPageState extends State<InitialCollectionPage> {
  final _libraryController = getIt<LibraryController>();
  final _nameCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _createAndGoHome() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() => _isLoading = true);

    try {
      await _libraryController.createNewCollection(_nameCtrl.text.trim());
      if (mounted)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.auto_awesome, size: 64, color: Colors.indigo),
              const SizedBox(height: 24),
              const Text(
                'Quase lá!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Dê um nome para a sua primeira coleção/biblioteca.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nome da Coleção',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: _isLoading ? null : _createAndGoHome,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Criar e Começar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
