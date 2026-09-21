import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/di/service_locator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/app_state.dart';
import '../controllers/library_controller.dart';
import '../widgets/app_empty_state.dart';
import '../widgets/book_cover_tile.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import 'add_book_page.dart';

class ConsultBookPage extends StatefulWidget {
  const ConsultBookPage({super.key});

  @override
  State<ConsultBookPage> createState() => _ConsultBookPageState();
}

class _ConsultBookPageState extends State<ConsultBookPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final _controller = getIt<LibraryController>();
  String? _lastScannedIsbn;

  late final MobileScannerController _cameraController;
  late final AnimationController _animationController;
  bool _isScanned = false;
  bool _isScanningMode = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateState);
    WidgetsBinding.instance.addObserver(this);

    _cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
      autoStart: false,
      formats: const [
        BarcodeFormat.ean13,
        BarcodeFormat.ean8,
        BarcodeFormat.upcA,
        BarcodeFormat.upcE,
        BarcodeFormat.code128,
        BarcodeFormat.all,
      ],
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_cameraController.value.isInitialized) return;
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _cameraController.stop();
    } else if (state == AppLifecycleState.resumed && _isScanningMode) {
      _cameraController.start();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_updateState);
    _animationController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  void _startScanning() {
    setState(() {
      _isScanningMode = true;
      _isScanned = false;
    });
    _cameraController.start();
  }

  void _stopScanningAndReset() {
    _cameraController.stop();
    _controller.resetConsultFlow();
    setState(() {
      _isScanningMode = false;
      _isScanned = false;
      _lastScannedIsbn = null;
    });
  }

  void _handleBarcode(BarcodeCapture capture) async {
    if (_isScanned) return;

    for (final barcode in capture.barcodes) {
      final String? code = barcode.rawValue ?? barcode.displayValue;
      if (code != null && code.trim().isNotEmpty) {
        setState(() => _isScanned = true);
        await _cameraController.stop();

        _lastScannedIsbn = code.trim();
        _controller.consultBookByIsbn(code.trim());
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.consultFlowState;
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg0,
      appBar: AppBar(
        title: Text(
          'Consultar livro',
          style: TextStyle(
            fontFamily: 'Fraunces',
            fontSize: 24,
            color: colors.ink,
          ),
        ),
        backgroundColor: colors.bg0,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.ink),
      ),
      body: SafeArea(child: _buildBody(state, colors)),
    );
  }

  Widget _buildBody(AppState<ConsultResult> state, AppColors colors) {
    if (state is StateLoading<ConsultResult>) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: AppIcons.searching,
              color: colors.terracotta,
              size: 64,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Procurando na sua coleção...',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                color: colors.inkSoft,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    if (state is StateError<ConsultResult>) {
      return Center(
        child: AppEmptyState(
          icon: AppIcons.warning,
          iconColor: colors.wine,
          title: 'Não foi possível consultar',
          message: state.message,
          actionLabel: 'Tentar novamente',
          onAction: _startScanning,
        ),
      );
    }

    if (state is StateSuccess<ConsultResult>) {
      final result = state.data;

      if (result.isFound) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colors.moss.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: colors.moss,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Você já tem este livro!',
                style: AppTypography.display(color: colors.moss, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.bg1,
                  border: Border.all(color: colors.lineStrong),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookCoverTile(
                      title: result.book!.title,
                      seed: result.book!.id,
                      width: 80,
                      height: 120,
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.book!.title,
                            style: AppTypography.display(
                              color: colors.ink,
                              fontSize: 18,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            result.book!.author,
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 14,
                              color: colors.inkSoft,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.max),
              PrimaryButton(
                label: 'Consultar Outro Livro',
                onPressed: _startScanning,
                fullWidth: true,
              ),
              const SizedBox(height: AppSpacing.md),
              SecondaryButton(
                label: 'Voltar para o Início',
                onPressed: () => Navigator.pop(context),
                fullWidth: true,
                variant: SecondaryButtonVariant.outline,
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: AppEmptyState(
            icon: AppIcons.searching,
            iconColor: colors.terracotta,
            title: 'Livro não encontrado',
            message: 'Você ainda não tem este livro na coleção.',
            actionLabel: 'Cadastrar Livro',
            onAction: () {
              _controller.resetBookFlow();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => AddBookPage(initialIsbn: _lastScannedIsbn),
                ),
              );
            },
            secondaryLabel: 'Consultar Outro',
            onSecondary: _startScanning,
          ),
        );
      }
    }

    return _isScanningMode
        ? _buildScanningStage(colors)
        : _buildInitialStage(colors);
  }

  Widget _buildInitialStage(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HugeIcon(icon: AppIcons.scan, size: 80, color: colors.inkFaint),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Descubra se você já possui um livro e onde ele está guardado.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Manrope',
              color: colors.inkSoft,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppSpacing.max),
          PrimaryButton(
            label: 'Abrir Câmera e Consultar',
            onPressed: _startScanning,
            icon: Icon(Icons.qr_code_scanner, color: colors.bg0),
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildScanningStage(AppColors colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 320,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MobileScanner(
                    controller: _cameraController,
                    onDetect: _handleBarcode,
                    errorBuilder: (context, error) => Container(
                      color: colors.bg2,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.videocam_off,
                              color: colors.wine,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Câmera indisponível',
                              style: TextStyle(color: colors.inkSoft),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colors.bg0.withOpacity(0.5),
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: _buildCorner(colors.butter, top: true, left: true),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: _buildCorner(colors.butter, top: true, left: false),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: _buildCorner(colors.butter, top: false, left: true),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: _buildCorner(colors.butter, top: false, left: false),
                  ),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final curvedValue = Curves.easeInOutSine.transform(
                        _animationController.value,
                      );
                      return Positioned(
                        top: 20 + (curvedValue * (280)),
                        left: 20,
                        right: 20,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colors.butter.withOpacity(0.0),
                                colors.butter,
                                colors.butter.withOpacity(0.0),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colors.butter.withOpacity(0.6),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Aponte para o código de barras',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SecondaryButton(
            label: 'Cancelar',
            onPressed: _stopScanningAndReset,
            variant: SecondaryButtonVariant.outline,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Color color, {required bool top, required bool left}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: top ? BorderSide(color: color, width: 2.5) : BorderSide.none,
          bottom: !top ? BorderSide(color: color, width: 2.5) : BorderSide.none,
          left: left ? BorderSide(color: color, width: 2.5) : BorderSide.none,
          right: !left ? BorderSide(color: color, width: 2.5) : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: top && left ? const Radius.circular(8) : Radius.zero,
          topRight: top && !left ? const Radius.circular(8) : Radius.zero,
          bottomLeft: !top && left ? const Radius.circular(8) : Radius.zero,
          bottomRight: !top && !left ? const Radius.circular(8) : Radius.zero,
        ),
      ),
    );
  }
}
