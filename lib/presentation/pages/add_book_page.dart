import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/di/service_locator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/app_state.dart';
import '../../domain/entities/models.dart';
import '../controllers/library_controller.dart';
import '../widgets/app_empty_state.dart';
import '../widgets/app_text_input.dart';
import '../widgets/book_cover_tile.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';

class AddBookPage extends StatefulWidget {
  final String? initialIsbn;
  const AddBookPage({super.key, this.initialIsbn});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final _controller = getIt<LibraryController>();

  bool _manualMode = false;
  bool _isScanned = false;
  String? _manualIsbn;
  Location? _selectedLocation;

  late final MobileScannerController _cameraController;
  late final AnimationController _animationController;

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _isbnController = TextEditingController();
  final _yearController = TextEditingController();
  final _pagesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateState);
    WidgetsBinding.instance.addObserver(this);

    _cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
      autoStart: true,
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

    if (widget.initialIsbn != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.scanAndDraftBook(widget.initialIsbn!);
      });
    }

    if (_controller.currentLocations.isNotEmpty) {
      _selectedLocation = _controller.currentLocations.first;
    }
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
    } else if (state == AppLifecycleState.resumed &&
        !_manualMode &&
        _controller.bookFlowState is StateInitial) {
      _cameraController.start();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_updateState);
    _animationController.dispose();
    _cameraController.dispose();

    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _yearController.dispose();
    _pagesController.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture capture) async {
    if (_isScanned) return;

    for (final barcode in capture.barcodes) {
      final String? code = barcode.rawValue ?? barcode.displayValue;
      if (code != null && code.trim().isNotEmpty) {
        setState(() => _isScanned = true);
        await _cameraController.stop();
        _controller.scanAndDraftBook(code.trim());
        break;
      }
    }
  }

  void _resetFlow() {
    _controller.resetBookFlow();
    setState(() {
      _manualMode = false;
      _isScanned = false;
      _manualIsbn = null;
    });
    _cameraController.start();
  }

  void _handleManualAdd() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    _controller.addManualBook(
      title,
      _authorController.text.trim(),
      isbn: _manualIsbn ?? _isbnController.text.trim(),
    );
  }

  void _handleConfirmAdd(Book draftBook) {
    if (_selectedLocation == null) return;
    _controller.confirmAddBook(draftBook);
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.bookFlowState;
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg0,
      appBar: AppBar(
        title: const Text('Adicionar livro'),
        backgroundColor: colors.bg0,
        elevation: 0,
      ),
      body: SafeArea(child: _buildBody(state, colors)),
    );
  }

  Widget _buildBody(AppState<Book> state, AppColors colors) {
    if (state is StateLoading<Book>) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(icon: AppIcons.search, color: colors.butter, size: 64),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Consultando dados...',
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

    if (state is StateError<Book>) {
      if (_manualMode) return _buildManualForm(colors);
      final providerUnavailable = state.message.contains(
        'Metadata provider unavailable',
      );
      return Center(
        child: AppEmptyState(
          icon: AppIcons.warning,
          iconColor: colors.wine,
          title: 'Não foi possível consultar',
          message: state.message,
          actionLabel: 'Tentar novamente',
          onAction: _resetFlow,
          secondaryLabel: providerUnavailable ? 'Cadastrar manualmente' : null,
          onSecondary: providerUnavailable
              ? () => setState(() => _manualMode = true)
              : null,
        ),
      );
    }

    if (state is StateComplete<Book>) {
      return Center(
        child: AppEmptyState(
          icon: AppIcons.checkCircle,
          iconColor: colors.moss,
          title: 'Livro salvo com sucesso!',
          message: 'Ele já está disponível na sua coleção.',
          actionLabel: 'Voltar para a Biblioteca',
          onAction: () => Navigator.pop(context),
          secondaryLabel: 'Adicionar outro',
          onSecondary: _resetFlow,
        ),
      );
    }

    if (state is StateSuccess<Book>) {
      return _buildFoundStage(state.data, colors);
    }

    if (_manualMode) {
      return _buildManualForm(colors);
    }

    return _buildScanningStage(colors);
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
              height: 260,
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
                        top: 20 + (curvedValue * (220)),
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
            label: 'Cadastrar Manualmente',
            onPressed: () {
              _cameraController.stop();
              setState(() {
                _manualMode = true;
                _manualIsbn = null;
              });
            },
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

  Widget _buildFoundStage(Book draftBook, AppColors colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                  title: draftBook.title,
                  seed: draftBook.isbn ?? draftBook.title,
                  width: 80,
                  height: 120,
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LIVRO ENCONTRADO',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 11,
                          color: colors.moss,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        draftBook.title,
                        style: AppTypography.display(
                          color: colors.ink,
                          fontSize: 18,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        draftBook.author,
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
          const SizedBox(height: AppSpacing.xl),

          Text(
            'GUARDAR EM',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 11,
              color: colors.inkFaint,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _controller.currentLocations.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.bg2,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Nenhum lugar cadastrado.',
                    style: TextStyle(color: colors.inkFaint),
                  ),
                )
              : DropdownButtonFormField<Location>(
                  value: _selectedLocation,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colors.bg1,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: colors.lineStrong),
                    ),
                  ),
                  dropdownColor: colors.bg2,
                  items: _controller.currentLocations.map((l) {
                    return DropdownMenuItem(
                      value: l,
                      child: Text(l.name, style: TextStyle(color: colors.ink)),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedLocation = val),
                ),

          const SizedBox(height: AppSpacing.max),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SecondaryButton(
                  label: 'Cancelar',
                  onPressed: _resetFlow,
                  variant: SecondaryButtonVariant.outline,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: 'Adicionar',
                  onPressed: _selectedLocation == null
                      ? null
                      : () => _handleConfirmAdd(draftBook),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManualForm(AppColors colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.bg1,
              border: Border.all(color: colors.line),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Preencha os dados do livro. Campos com * são obrigatórios.',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                color: colors.inkSoft,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'DADOS PRINCIPAIS',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 11,
              color: colors.inkFaint,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextInput(label: 'Título *', controller: _titleController),
          const SizedBox(height: AppSpacing.md),
          AppTextInput(label: 'Autor *', controller: _authorController),

          const SizedBox(height: AppSpacing.xl),
          Text(
            'INFORMAÇÕES ADICIONAIS',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 11,
              color: colors.inkFaint,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AppTextInput(label: 'ISBN', controller: _isbnController),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppTextInput(
                  label: 'Ano',
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextInput(
            label: 'Número de Páginas',
            controller: _pagesController,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: AppSpacing.max),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SecondaryButton(
                  label: 'Voltar',
                  onPressed: _resetFlow,
                  variant: SecondaryButtonVariant.outline,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: 'Adicionar',
                  onPressed: _handleManualAdd,
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
