import 'package:flutter/material.dart';

import '../../core/di/service_locator.dart';
import '../../core/utils/app_state.dart';
import '../controllers/library_controller.dart';
import 'add_book_page.dart';
import 'scanner_page.dart';

class ConsultBookPage extends StatefulWidget {
  const ConsultBookPage({super.key});
  @override
  State<ConsultBookPage> createState() => _ConsultBookPageState();
}

class _ConsultBookPageState extends State<ConsultBookPage> {
  final _controller = getIt<LibraryController>();
  String? _lastScannedIsbn;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateState);
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_updateState);
    super.dispose();
  }

  Future<void> _openCameraAndScan() async {
    final String? scannedIsbn = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const ScannerPage()),
    );
    if (scannedIsbn != null && scannedIsbn.isNotEmpty) {
      _lastScannedIsbn = scannedIsbn;
      _controller.consultBookByIsbn(scannedIsbn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.consultFlowState;

    return Scaffold(
      appBar: AppBar(title: const Text('Consultar Livro')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _buildBody(state),
        ),
      ),
    );
  }

  Widget _buildBody(AppState<ConsultResult> state) {
    if (state is StateLoading<ConsultResult>) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Procurando na sua coleção...'),
        ],
      );
    }

    if (state is StateError<ConsultResult>) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(state.message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _openCameraAndScan,
            child: const Text('Tentar Novamente'),
          ),
        ],
      );
    }

    if (state is StateSuccess<ConsultResult>) {
      final result = state.data;

      if (result.isFound) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Você já tem este livro!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              result.book!.title,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              result.book!.author,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              'O backend confirma a presença deste livro na coleção selecionada.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _openCameraAndScan,
              child: const Text('Consultar Outro Livro'),
            ),
          ],
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.help_outline, color: Colors.orange, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Livro não encontrado.',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Você ainda não tem este livro na coleção selecionada.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Cadastrar este Livro'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              onPressed: () {
                _controller.resetBookFlow();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddBookPage(initialIsbn: _lastScannedIsbn),
                  ),
                );
              },
            ),
            TextButton(
              onPressed: _openCameraAndScan,
              child: const Text('Consultar Outro'),
            ),
          ],
        );
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.document_scanner, size: 100, color: Colors.grey),
        const SizedBox(height: 24),
        const Text(
          'Descubra rapidamente se você já possui um livro ou mangá e onde ele está guardado.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          onPressed: _openCameraAndScan,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Abrir Câmera para Consultar'),
        ),
      ],
    );
  }
}
