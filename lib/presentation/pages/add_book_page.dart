import 'package:flutter/material.dart';

import '../../core/di/service_locator.dart';
import '../../core/utils/app_state.dart';
import '../../domain/entities/models.dart';
import '../controllers/library_controller.dart';
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
    if (state is StateLoading<Book>) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Consultando dados...'),
        ],
      );
    }

    if (state is StateError<Book>) {
      if (_manualMode) return _buildManualForm();
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(state.message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          if (state.message.contains('Metadata provider unavailable'))
            ElevatedButton.icon(
              onPressed: () => setState(() => _manualMode = true),
              icon: const Icon(Icons.edit),
              label: const Text('Informar dados manualmente'),
            ),
          if (state.message.contains('Metadata provider unavailable'))
            const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _openCameraAndScan,
            child: const Text('Tentar Novamente (Escanear)'),
          ),
        ],
      );
    }

    if (state is StateSuccess<Book>) {
      final draftBook = state.data;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.library_books, size: 64, color: Colors.indigo),
          const SizedBox(height: 16),
          Text(
            draftBook.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            draftBook.author,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'ISBN lido: ${draftBook.isbn}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),

          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
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
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 80),
          const SizedBox(height: 16),
          const Text(
            'Livro salvo com sucesso!',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Voltar para a Biblioteca'),
          ),
        ],
      );
    }

    if (_manualMode) {
      return _buildManualForm();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.qr_code_scanner, size: 100, color: Colors.grey),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          onPressed: _openCameraAndScan,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Abrir Câmera e Escanear'),
        ),
        TextButton.icon(
          onPressed: () => setState(() {
            _manualMode = true;
            _manualIsbn = null;
          }),
          icon: const Icon(Icons.edit),
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
        const Text(
          'Cadastrar livro sem ISBN',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Título',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _authorController,
          decoration: const InputDecoration(
            labelText: 'Autor',
            border: OutlineInputBorder(),
          ),
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
