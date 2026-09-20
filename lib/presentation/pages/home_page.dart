import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/di/service_locator.dart';
import '../../core/localization/app_locale_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/utils/app_state.dart';
import '../../domain/entities/models.dart';
import '../../domain/repositories/library_repository.dart';
import '../controllers/auth_controller.dart';
import '../controllers/library_controller.dart';
import '../widgets/app_empty_state.dart';
import '../widgets/book_cover_tile.dart';
import '../widgets/location_badge.dart';
import 'add_book_page.dart';
import 'auth_pages.dart';
import 'consult_book_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _controller = getIt<LibraryController>();
  final _authController = getIt<AuthController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.addListener(_updateState);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _controller.currentCollection != null) {
      _controller.initializeApp();
    }
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_updateState);
    super.dispose();
  }

  void _showCreateLocationDialog() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Localização'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Ex: Quarto, Casa dos Pais',
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (textController.text.trim().isEmpty) return;
              try {
                await _controller.createNewLocation(textController.text.trim());
                if (mounted) Navigator.pop(context);
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceAll('Exception: ', '')),
                    ),
                  );
                }
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  void _showCreateCollectionDialog() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Criar Coleção'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: 'Nome da Coleção'),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (textController.text.trim().isEmpty) return;
              try {
                await _controller.createNewCollection(
                  textController.text.trim(),
                );
                if (mounted) Navigator.pop(context);
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceAll('Exception: ', '')),
                    ),
                  );
                }
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  void _showEditCollectionDialog() {
    final collection = _controller.currentCollection;
    if (collection == null) return;
    final textController = TextEditingController(text: collection.name);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Renomear coleção'),
        content: TextField(controller: textController, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = textController.text.trim();
              if (name.isEmpty) return;
              try {
                await _controller.updateCurrentCollection(name);
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              } catch (error) {
                if (dialogContext.mounted) Navigator.pop(dialogContext);
                if (mounted)
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('$error')));
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showLocationsDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Localizações'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: _controller.currentLocations
                .map(
                  (location) => ListTile(
                    leading: LocationBadge(name: location.name, size: 40),
                    title: Text(location.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: HugeIcon(icon: AppIcons.edit, color: context.colors.terracottaDeep, size: 20),
                          onPressed: () => _editLocation(location),
                        ),
                        IconButton(
                          icon: HugeIcon(icon: AppIcons.trash, color: context.colors.wine, size: 20),
                          onPressed: () async {
                            await _controller.deleteLocation(location);
                            if (dialogContext.mounted)
                              Navigator.pop(dialogContext);
                          },
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _editLocation(Location location) async {
    final textController = TextEditingController(text: location.name);
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Renomear localização'),
        content: TextField(controller: textController, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(dialogContext, textController.text.trim()),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty)
      await _controller.updateLocation(location, name);
  }

  Widget _buildDrawer() {
    final strings = AppLocalizations.of(context);
    final colors = context.colors;
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Minhas Coleções',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: _controller.myCollections.length,
                itemBuilder: (context, index) {
                  final col = _controller.myCollections[index];
                  final isSelected =
                      col.id == _controller.currentCollection?.id;

                  return ListTile(
                    selected: isSelected,
                    selectedTileColor: colors.bg2,
                    leading: HugeIcon(icon: AppIcons.shelf, color: colors.ink),
                    title: Text(
                      col.name,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: col.joinCode == null
                        ? null
                        : Text('Código: ${col.joinCode}'),
                    trailing: col.id == _controller.currentCollection?.id
                        ? PopupMenuButton<String>(
                            onSelected: (action) {
                              if (action == 'edit') _showEditCollectionDialog();
                              if (action == 'delete')
                                _confirmDeleteCollection();
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Renomear'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Excluir'),
                              ),
                            ],
                          )
                        : null,
                    onTap: () {
                      _controller.selectCollection(col);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: HugeIcon(icon: AppIcons.language, color: colors.ink),
              title: Text(strings.language),
              trailing: DropdownButton<Locale>(
                value: getIt<AppLocaleController>().locale,
                underline: const SizedBox.shrink(),
                items: [
                  DropdownMenuItem(
                    value: const Locale('pt'),
                    child: Text(strings.portuguese),
                  ),
                  DropdownMenuItem(
                    value: const Locale('en'),
                    child: Text(strings.english),
                  ),
                ],
                onChanged: (locale) {
                  if (locale != null) {
                    getIt<AppLocaleController>().setLocale(locale);
                  }
                },
              ),
            ),
            ListTile(
              leading: HugeIcon(icon: AppIcons.add, color: colors.ink),
              title: const Text('Nova Coleção'),
              onTap: () {
                Navigator.pop(context);
                _showCreateCollectionDialog();
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: HugeIcon(icon: AppIcons.logout, color: colors.wine),
              title: Text('Sair', style: TextStyle(color: colors.wine)),
              onTap: () async {
                Navigator.pop(context);
                await _authController.logout();
                getIt<LibraryRepository>().setSession(null);
                _controller.clearSession();
                if (mounted)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.screenState;

    if (state is StateLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state is StateError<void>) {
      final colors = context.colors;
      return Scaffold(
        appBar: AppBar(title: const Text('Biblioteca')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AppEmptyState(
              icon: AppIcons.offline,
              iconColor: colors.wine,
              title: 'Sem conexão',
              message: state.message,
              actionLabel: 'Tentar novamente',
              onAction: _controller.initializeApp,
            ),
          ),
        ),
      );
    }

    if (_controller.currentCollection == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Biblioteca')),
        drawer: _buildDrawer(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AppEmptyState(
              icon: AppIcons.shelf,
              iconColor: context.colors.plum,
              title: 'Nenhuma coleção selecionada',
              message: 'Abra o menu lateral para criar ou escolher uma.',
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_controller.currentCollection!.name),
        actions: [
          IconButton(
            icon: HugeIcon(icon: AppIcons.scan),
            tooltip: 'Consultar Livro',
            onPressed: () {
              _controller.resetConsultFlow();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ConsultBookPage()),
              );
            },
          ),
          IconButton(
            icon: HugeIcon(icon: AppIcons.exploreLocation),
            tooltip: 'Criar Localização',
            onPressed: _showCreateLocationDialog,
          ),
          IconButton(
            icon: HugeIcon(icon: AppIcons.location),
            tooltip: 'Gerenciar localizações',
            onPressed: _showLocationsDialog,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _controller.currentBooks.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: AppEmptyState(
                  icon: AppIcons.book,
                  iconColor: context.colors.moss,
                  title: 'Sua coleção está vazia',
                  message: 'Adicione seu primeiro livro pelo botão abaixo.',
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _controller.currentBooks.length,
              itemBuilder: (context, index) {
                final book = _controller.currentBooks[index];
                return ListTile(
                  leading: BookCoverTile(
                    title: book.title,
                    seed: book.id,
                    width: 40,
                    height: 58,
                  ),
                  title: Text(
                    book.isPending ? '${book.title} (pendente)' : book.title,
                  ),
                  subtitle: Text(
                    book.author.isEmpty ? 'Autor não informado' : book.author,
                  ),
                  isThreeLine: true,
                  onTap: () => _showEditBookDialog(book),
                  trailing: IconButton(
                    icon: HugeIcon(icon: AppIcons.trash, color: context.colors.wine),
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
        icon: HugeIcon(icon: AppIcons.add, color: context.colors.textOnAccent),
        label: const Text('Cadastrar'),
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
              _controller
                  .removeBook(book.id)
                  .then((_) {
                    if (context.mounted) Navigator.pop(context);
                  })
                  .catchError((error) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Não foi possível remover: $error'),
                        ),
                      );
                    }
                  });
            },
            child: Text('Remover', style: TextStyle(color: context.colors.wine)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCollection() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir coleção?'),
        content: const Text(
          'Todos os livros e localizações desta coleção serão removidos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await _controller.deleteCurrentCollection();
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: Text('Excluir', style: TextStyle(color: context.colors.wine)),
          ),
        ],
      ),
    );
  }

  void _showEditBookDialog(Book book) {
    final titleController = TextEditingController(text: book.title);
    final authorController = TextEditingController(text: book.author);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Editar livro'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: 'Autor'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final collection = _controller.currentCollection;
              if (collection == null || titleController.text.trim().isEmpty)
                return;
              try {
                await _controller.updateBook(
                  book,
                  titleController.text,
                  authorController.text,
                );
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              } catch (error) {
                if (dialogContext.mounted) Navigator.pop(dialogContext);
                if (mounted)
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('$error')));
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
