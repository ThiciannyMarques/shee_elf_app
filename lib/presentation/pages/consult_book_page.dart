import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/di/service_locator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/utils/app_state.dart';
import '../controllers/library_controller.dart';
import '../widgets/app_empty_state.dart';
import '../widgets/book_cover_tile.dart';
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
    final colors = context.colors;

    if (state is StateLoading<ConsultResult>) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colors.terracotta),
          const SizedBox(height: 16),
          const Text('Procurando na sua coleção...'),
        ],
      );
    }

    if (state is StateError<ConsultResult>) {
      return AppEmptyState(
        icon: AppIcons.warning,
        iconColor: colors.wine,
        title: 'Não foi possível consultar',
        message: state.message,
        actionLabel: 'Tentar novamente',
        onAction: _openCameraAndScan,
      );
    }

    if (state is StateSuccess<ConsultResult>) {
      final result = state.data;

      if (result.isFound) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(icon: AppIcons.checkCircle, color: colors.moss, size: 72),
            const SizedBox(height: 16),
            Text(
              'Você já tem este livro!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colors.mossDeep,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            BookCoverTile(
              title: result.book!.title,
              seed: result.book!.id,
              width: 88,
              height: 132,
            ),
            const SizedBox(height: 12),
            Text(
              result.book!.title,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              result.book!.author,
              style: TextStyle(color: colors.inkFaint),
            ),
            const SizedBox(height: 24),
            Text(
              'O backend confirma a presença deste livro na coleção selecionada.',
              style: TextStyle(color: colors.inkSoft),
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
        return AppEmptyState(
          icon: AppIcons.searching,
          iconColor: colors.terracottaDeep,
          title: 'Livro não encontrado',
          message: 'Você ainda não tem este livro na coleção selecionada.',
          actionLabel: 'Cadastrar este Livro',
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
          onSecondary: _openCameraAndScan,
        );
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HugeIcon(icon: AppIcons.scan, size: 96, color: colors.inkFaint),
        const SizedBox(height: 24),
        Text(
          'Descubra rapidamente se você já possui um livro ou mangá e onde ele está guardado.',
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.inkSoft, fontSize: 16),
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: _openCameraAndScan,
          icon: HugeIcon(icon: AppIcons.camera, color: colors.textOnAccent),
          label: const Text('Abrir Câmera para Consultar'),
        ),
      ],
    );
  }
}
