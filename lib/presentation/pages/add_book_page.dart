import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/utils/app_state.dart';
import '../../domain/entities/book.dart';
import '../controllers/book_controller.dart';
import 'scanner_page.dart'; // Import da nova tela de câmera

class AddBookPage extends StatefulWidget {
  final String collectionId;
  const AddBookPage({super.key, required this.collectionId});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _controller = GetIt.I<BookController>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    setState(() {});
  }

  // Função responsável por chamar a tela da câmera e pegar o retorno
  Future<void> _openCameraAndScan() async {
    // Aguarda o usuário fechar a ScannerPage e pega a string retornada
    final String? scannedIsbn = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const ScannerPage()),
    );

    // Se o usuário leu um código (e não apenas clicou em voltar), envia pro controller
    if (scannedIsbn != null && scannedIsbn.isNotEmpty) {
      _controller.addBookByIsbn(widget.collectionId, scannedIsbn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Livro')),
      body: Center(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    final state = _controller.state;

    if (state is StateLoading<Book>) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Consultando informações do livro...'),
        ],
      );
    }

    if (state is StateError<Book>) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(state.message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _controller.resetState(),
            child: const Text('Tentar Novamente'),
          ),
        ],
      );
    }

    if (state is StateSuccess<Book>) {
      final book = state.data;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 64),
          const SizedBox(height: 16),
          Text(
            '${book.title} adicionado!',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(book.author),
          const SizedBox(height: 8),
          Text(
            'ISBN lido: ${book.isbn}',
            style: const TextStyle(color: Colors.grey),
          ), // Mostra o ISBN lido
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _controller.resetState(),
            child: const Text('Escanear outro livro'),
          ),
        ],
      );
    }

    // Chama a função da câmera ao invés de enviar direto pro controller
    return ElevatedButton.icon(
      icon: const Icon(Icons.camera_alt),
      label: const Text('Abrir Câmera e Escanear'),
      onPressed: _openCameraAndScan,
    );
  }
}
