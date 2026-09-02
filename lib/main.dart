import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/repositories/library_repository.dart';
import 'data/repositories/local_library_repository_impl.dart';
import 'presentation/controllers/library_controller.dart';
import 'presentation/pages/scanner_page.dart'; // Import da câmera
import 'core/utils/app_state.dart';
import 'domain/entities/models.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  final prefs = await SharedPreferences.getInstance();

  // Apenas Repository e Controller. Nada de Scanner falso.
  getIt.registerLazySingleton<LibraryRepository>(
    () => LocalLibraryRepositoryImpl(prefs),
  );
  getIt.registerLazySingleton(() => LibraryController(getIt()));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  final controller = getIt<LibraryController>();
  await controller.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVP Biblioteca',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

// ==========================================
// TELA HOME (DASHBOARD)
// ==========================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = getIt<LibraryController>();

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

  @override
  Widget build(BuildContext context) {
    final state = _controller.screenState;

    if (state is StateLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_controller.currentCollection == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Biblioteca')),
        body: const Center(child: Text('Nenhuma coleção selecionada.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_controller.currentCollection!.name)),
      body: ListView.builder(
        itemCount: _controller.currentBooks.length,
        itemBuilder: (context, index) {
          final book = _controller.currentBooks[index];
          final loc = _controller.currentLocations.firstWhere(
            (l) => l.id == book.locationId,
            orElse: () =>
                const Location(id: '', collectionId: '', name: 'Desconhecido'),
          );

          return ListTile(
            leading: const Icon(Icons.book),
            title: Text(book.title),
            subtitle: Text('${book.author}\nLocal: ${loc.name}'),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context, book),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _controller.resetBookFlow();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddBookPage()),
          );
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Adicionar Livro'),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remover livro?'),
        content: Text('Deseja retirar "${book.title}" da coleção?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _controller.removeBook(book.id);
              Navigator.pop(context);
            },
            child: const Text('Remover', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TELA FLUXO DE ADICIONAR LIVRO
// ==========================================
class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});
  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _controller = getIt<LibraryController>();
  String? _selectedLocationId;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateState);
    if (_controller.currentLocations.isNotEmpty) {
      _selectedLocationId = _controller.currentLocations.first.id;
    }
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_updateState);
    super.dispose();
  }

  // --- Função que abre a câmera e devolve o código para o Controller ---
  Future<void> _openCameraAndScan() async {
    final String? scannedIsbn = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const ScannerPage()),
    );

    if (scannedIsbn != null && scannedIsbn.isNotEmpty) {
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
          Text('Consultando dados (simulando API)...'),
        ],
      );
    }

    if (state is StateError<Book>) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(state.message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _openCameraAndScan, // Chama a câmera real de novo
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

          const Text('Onde você vai guardar este livro?'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedLocationId,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: _controller.currentLocations.map((loc) {
              return DropdownMenuItem(value: loc.id, child: Text(loc.name));
            }).toList(),
            onChanged: (val) => setState(() => _selectedLocationId = val),
          ),

          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            onPressed: _selectedLocationId == null
                ? null
                : () => _controller.confirmAddBook(
                    draftBook,
                    _selectedLocationId!,
                  ),
            child: const Text('Confirmar e Salvar na Coleção'),
          ),
          TextButton(
            onPressed: _controller.resetBookFlow,
            child: const Text('Cancelar'),
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

    // Initial State
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.qr_code_scanner, size: 100, color: Colors.grey),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          onPressed: _openCameraAndScan, // Chama a câmera real
          icon: const Icon(Icons.camera_alt),
          label: const Text('Abrir Câmera e Escanear'),
        ),
      ],
    );
  }
}
