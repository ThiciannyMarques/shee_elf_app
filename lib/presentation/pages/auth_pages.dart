import 'package:flutter/material.dart';

import '../../core/di/service_locator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_state.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/library_repository.dart';
import '../controllers/auth_controller.dart';
import '../controllers/library_controller.dart';
import '../navigation/fantasy_page_route.dart';
import '../widgets/ember_dots_loader.dart';
import '../widgets/responsive_scene.dart';
import '../widgets/scene_image.dart';
import '../widgets/splash_motion_overlay.dart';
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
        FantasyPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  // The art's own canvas size (assets/splash_dark.svg viewBox="0 0 768
  // 1376") — the scene always fills the screen's full height at this
  // aspect ratio, so the logo (top) and loading (bottom) are never
  // cropped; only the sides crop on unusually shaped screens. Update these
  // if the art changes.
  static const _sceneWidth = 768.0;
  static const _sceneHeight = 1376.0;

  @override
  Widget build(BuildContext context) {
    // The art (assets/splash_dark.svg) already carries the "She Elf" title
    // and tagline lettering — no text overlay needed on top of it. The
    // motion overlay only makes sense once that art is actually present,
    // which today means dark mode; extend this once a light-mode scene
    // exists too.
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: ResponsiveScene(
        referenceWidth: _sceneWidth,
        referenceHeight: _sceneHeight,
        backgroundColor: isDark ? colors.deepBlue : colors.bg2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const SceneImage(sceneKey: 'splash'),
            if (isDark) const SplashMotionOverlay(),
            // Just three small embers pulsing near the lantern — no card,
            // no border, nothing that reads as a UI box sitting on the art.
            const Align(
              alignment: Alignment(0, 0.97),
              child: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: EmberDotsLoader(dotSize: 7),
              ),
            ),
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
    final colors = context.colors;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 220, child: SceneImage(sceneKey: 'auth')),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Bem-vindo à sua Biblioteca',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(labelText: 'E-mail'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passCtrl,
                      decoration: const InputDecoration(labelText: 'Senha'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    if (state is StateError<User>)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          state.message,
                          style: TextStyle(color: colors.wine),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ElevatedButton(
                      onPressed: state is StateLoading<User> ? null : _doLogin,
                      child: state is StateLoading<User>
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.textOnAccent,
                              ),
                            )
                          : const Text('Entrar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        FantasyPageRoute(builder: (_) => const RegisterPage()),
                      ),
                      child: const Text('Não tem uma conta? Cadastre-se'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
        FantasyPageRoute(builder: (_) => const InitialCollectionPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _authController.authState;
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Nova Conta')),
      body: Column(
        children: [
          const SizedBox(height: 150, child: SceneImage(sceneKey: 'auth')),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Nome'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(labelText: 'E-mail'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passCtrl,
                      decoration: const InputDecoration(labelText: 'Senha'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    if (state is StateError<User>)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          state.message,
                          style: TextStyle(color: colors.wine),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ElevatedButton(
                      onPressed: state is StateLoading<User>
                          ? null
                          : _doRegister,
                      child: state is StateLoading<User>
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.textOnAccent,
                              ),
                            )
                          : const Text('Cadastrar e Continuar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
    final colors = context.colors;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: SceneImage(sceneKey: 'auth'),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Quase lá!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Dê um nome para a sua primeira coleção/biblioteca.',
                style: TextStyle(color: colors.inkSoft),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nome da Coleção'),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _createAndGoHome,
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.textOnAccent,
                        ),
                      )
                    : const Text('Criar e Começar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
