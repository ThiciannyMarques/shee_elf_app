import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/di/service_locator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/utils/app_state.dart';
import '../../domain/entities/models.dart';
import '../controllers/library_controller.dart';
import '../widgets/app_empty_state.dart';
import '../widgets/book_cover_tile.dart';
import 'scanner_page.dart';

class AddBookPage extends StatefulWidget {
  final String? initialIsbn;
  const AddBookPage({super.key, this.initialIsbn});
  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _controller = getIt<LibraryController>();
  bool _manualMode = false;
  String? _manualIsbn;
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateState);
    if (widget.initialIsbn != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.scanAndDraftBook(widget.initialIsbn!);
      });
    }
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_updateState);
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  Future<void> _openCameraAndScan() async {
    final String? scannedIsbn = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const ScannerPage()),
    );
    if (scannedIsbn != null && scannedIsbn.isNotEmpty) {
      _manualIsbn = scannedIsbn;
      _controller.scanAndDraftBook(scannedIsbn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.bookFlowState;

    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Livro')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _buildBody(state),
        ),
      ),
    );
  }

  Widget _buildBody(AppState<Book> state) {
    final colors = context.colors;

    if (state is StateLoading<Book>) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colors.terracotta),
          const SizedBox(height: 16),
          const Text('Consultando dados...'),
        ],
      );
    }

    if (state is StateError<Book>) {
      if (_manualMode) return _buildManualForm();
      final providerUnavailable =
          state.message.contains('Metadata provider unavailable');
      return AppEmptyState(
        icon: AppIcons.warning,
        iconColor: colors.wine,
        title: 'Não foi possível consultar',
        message: state.message,
        actionLabel: 'Tentar novamente (escanear)',
        onAction: _openCameraAndScan,
        secondaryLabel:
            providerUnavailable ? 'Informar dados manualmente' : null,
        onSecondary:
            providerUnavailable ? () => setState(() => _manualMode = true) : null,
      );
    }

    if (state is StateSuccess<Book>) {
      final draftBook = state.data;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: BookCoverTile(
              title: draftBook.title,
              seed: draftBook.isbn ?? draftBook.title,
              width: 96,
              height: 144,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            draftBook.title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          Text(
            draftBook.author,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.inkSoft, fontSize: 16),
          ),
          Text(
            'ISBN lido: ${draftBook.isbn}',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.inkFaint),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _controller.confirmAddBook(draftBook),
            child: const Text('Confirmar e Salvar na Coleção'),
          ),
          TextButton(
            onPressed: _controller.resetBookFlow,
            child: const Text('Cancelar / Limpar'),
          ),
        ],
      );
    }

    if (state is StateComplete<Book>) {
      return AppEmptyState(
        icon: AppIcons.checkCircle,
        iconColor: colors.moss,
        title: 'Livro salvo com sucesso!',
        message: 'Ele já está disponível na sua coleção.',
        actionLabel: 'Voltar para a Biblioteca',
        onAction: () => Navigator.pop(context),
      );
    }

    if (_manualMode) {
      return _buildManualForm();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HugeIcon(icon: AppIcons.scan, size: 88, color: colors.inkFaint),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _openCameraAndScan,
          icon: HugeIcon(icon: AppIcons.camera, color: colors.textOnAccent),
          label: const Text('Abrir Câmera e Escanear'),
        ),
        TextButton.icon(
          onPressed: () => setState(() {
            _manualMode = true;
            _manualIsbn = null;
          }),
          icon: HugeIcon(icon: AppIcons.edit, color: colors.terracottaDeep),
          label: const Text('Cadastrar sem ISBN'),
        ),
      ],
    );
  }

  Widget _buildManualForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Cadastrar livro sem ISBN',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Título'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _authorController,
          decoration: const InputDecoration(labelText: 'Autor'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final title = _titleController.text.trim();
            if (title.isNotEmpty) {
              _controller.addManualBook(
                title,
                _authorController.text.trim(),
                isbn: _manualIsbn,
              );
            }
          },
          child: const Text('Salvar livro'),
        ),
        TextButton(
          onPressed: () => setState(() => _manualMode = false),
          child: const Text('Voltar para scanner'),
        ),
      ],
    );
  }
}
