import 'package:flutter/material.dart';

import '../../core/di/service_locator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/app_state.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/library_repository.dart';
import '../controllers/auth_controller.dart';
import '../controllers/library_controller.dart';
import '../navigation/fantasy_page_route.dart';
import '../widgets/app_text_input.dart';
import '../widgets/ember_dots_loader.dart';
import '../widgets/primary_button.dart';
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
    Future.delayed(const Duration(milliseconds: 1500), _checkAuth);
  }

  Future<void> _checkAuth() async {
    await _authController.checkAuth();

    if (!mounted) return;

    if (_authController.authState is StateSuccess<User>) {
      final user = (_authController.authState as StateSuccess<User>).data;
      getIt<LibraryRepository>().setSession(user.email);
      await _libraryController.initializeApp();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        FantasyPageRoute(builder: (_) => const AuthPage()),
      );
    }
  }

  static const _sceneWidth = 768.0;
  static const _sceneHeight = 1376.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: const Color(0xFF17151D),
      body: ResponsiveScene(
        referenceWidth: _sceneWidth,
        referenceHeight: _sceneHeight,
        backgroundColor: const Color(0xFF17151D),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const SceneImage(sceneKey: 'splash'),
            if (isDark) const SplashMotionOverlay(),
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

enum AuthMode { login, register }

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _authController = getIt<AuthController>();
  final _libraryController = getIt<LibraryController>();

  AuthMode _mode = AuthMode.login;

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

  void _submit() async {
    final isLogin = _mode == AuthMode.login;
    bool success = false;

    if (isLogin) {
      success = await _authController.login(
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );
      if (success && mounted) {
        getIt<LibraryRepository>().setSession(_emailCtrl.text.trim());
        await _libraryController.initializeApp();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      }
    } else {
      success = await _authController.register(
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
  }

  @override
  Widget build(BuildContext context) {
    final state = _authController.authState;
    final colors = context.colors;
    final isLogin = _mode == AuthMode.login;
    final isLoading = state is StateLoading<User>;

    return Scaffold(
      backgroundColor: colors.bg0,
      body: Column(
        children: [
          SizedBox(
            height: 240,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1603745676022-d1b77e3cbce8?w=480&h=480&fit=crop&q=60',
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.65),
                  colorBlendMode: BlendMode.darken,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF17151D).withOpacity(0.3),
                        const Color(0xFF17151D).withOpacity(0.95),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Icon(Icons.auto_awesome, color: colors.butter, size: 36),
                      const SizedBox(height: 8),
                      Text(
                        'She Elf',
                        style: AppTypography.display(
                          color: const Color(0xFFEDE6D6),
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'a biblioteca que vive em casa',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: const Color(0xFFEDE6D6).withOpacity(0.55),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.bg2,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.line),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Row(
                      children: [
                        _buildTab('Entrar', AuthMode.login, colors),
                        _buildTab('Criar conta', AuthMode.register, colors),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  if (!isLogin) ...[
                    AppTextInput(
                      label: 'Nome',
                      hintText: 'Seu nome',
                      controller: _nameCtrl,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  AppTextInput(
                    label: 'E-mail',
                    hintText: 'seu@email.com',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextInput(
                    label: 'Senha',
                    hintText: '••••••••',
                    controller: _passCtrl,
                    obscureText: true,
                    errorText: state is StateError<User> ? state.message : null,
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  PrimaryButton(
                    label: isLoading
                        ? 'Aguarde…'
                        : (isLogin ? 'Entrar na biblioteca' : 'Criar conta'),
                    onPressed: isLoading ? null : _submit,
                    fullWidth: true,
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  Divider(color: colors.line, height: 1),
                  const SizedBox(height: AppSpacing.lg),
                  Center(
                    child: Text(
                      'DESENVOLVIMENTO',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.inkFaint,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: colors.inkSoft,
                      side: BorderSide(color: colors.lineStrong),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 44),
                    ),
                    child: const Text('Entrar sem autenticação →'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, AuthMode tabMode, AppColors colors) {
    final isActive = _mode == tabMode;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _mode = tabMode);
        },
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? colors.bg1 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isActive ? colors.ink : colors.inkFaint,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
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
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuração Inicial'),
        backgroundColor: colors.bg0,
      ),
      backgroundColor: colors.bg0,
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
                style: AppTypography.display(color: colors.ink, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Dê um nome para a sua primeira coleção/biblioteca.',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: colors.inkSoft),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AppTextInput(
                label: 'Nome da Coleção',
                hintText: 'Ex: Estante Mágica',
                controller: _nameCtrl,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: _isLoading ? 'Aguarde...' : 'Criar e Começar',
                onPressed: _isLoading ? null : _createAndGoHome,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
