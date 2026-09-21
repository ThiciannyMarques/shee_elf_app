import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/di/service_locator.dart';
import '../../core/localization/app_locale_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
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
import 'book_detail_page.dart';
import 'locations_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _controller = getIt<LibraryController>();
  final _authController = getIt<AuthController>();

  int _currentIndex = 0;

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
            child: Text(
              'Excluir',
              style: TextStyle(color: context.colors.wine),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    final strings = AppLocalizations.of(context);
    final colors = context.colors;

    return Drawer(
      backgroundColor: colors.wood,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: colors.ink.withOpacity(0.12)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'She Elf',
                    style: AppTypography.display(
                      color: colors.butter,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'PROTÓTIPO',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11,
                      color: colors.inkFaint,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Text(
                      'MINHAS COLEÇÕES',
                      style: TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 11,
                        color: colors.inkFaint,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  ..._controller.myCollections.map((col) {
                    final isSelected =
                        col.id == _controller.currentCollection?.id;
                    return ListTile(
                      selected: isSelected,
                      selectedTileColor: colors.ink.withOpacity(0.08),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      title: Text(
                        col.name,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected ? colors.ink : colors.inkSoft,
                        ),
                      ),
                      subtitle: col.joinCode == null
                          ? null
                          : Text(
                              'Código: ${col.joinCode}',
                              style: TextStyle(
                                fontSize: 11,
                                color: colors.inkFaint,
                              ),
                            ),
                      trailing: isSelected
                          ? PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_vert,
                                color: colors.inkSoft,
                                size: 20,
                              ),
                              onSelected: (action) {
                                if (action == 'edit')
                                  _showEditCollectionDialog();
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
                  }),

                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Text(
                      'AÇÕES',
                      style: TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 11,
                        color: colors.inkFaint,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: HugeIcon(
                      icon: AppIcons.add,
                      color: colors.inkSoft,
                      size: 20,
                    ),
                    title: Text(
                      'Nova Coleção',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        color: colors.inkSoft,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showCreateCollectionDialog();
                    },
                  ),
                  ListTile(
                    leading: HugeIcon(
                      icon: AppIcons.language,
                      color: colors.inkSoft,
                      size: 20,
                    ),
                    title: Text(
                      strings.language,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        color: colors.inkSoft,
                      ),
                    ),
                    trailing: DropdownButton<Locale>(
                      value: getIt<AppLocaleController>().locale,
                      underline: const SizedBox.shrink(),
                      dropdownColor: colors.bg1,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        color: colors.ink,
                      ),
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
                        if (locale != null)
                          getIt<AppLocaleController>().setLocale(locale);
                      },
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: colors.ink.withOpacity(0.10)),
                ),
              ),
              child: ListTile(
                leading: HugeIcon(
                  icon: AppIcons.logout,
                  color: colors.wine,
                  size: 20,
                ),
                title: Text(
                  'Sair',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 13,
                    color: colors.wine,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await _authController.logout();
                  getIt<LibraryRepository>().setSession(null);
                  _controller.clearSession();
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthPage()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final colors = context.colors;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 64 + bottomPadding,
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: colors.bg1,
        border: Border(top: BorderSide(color: colors.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, 'Início', Icons.home_outlined, Icons.home),
          _buildNavItem(1, 'Lugares', Icons.vpn_key_outlined, Icons.vpn_key),

          GestureDetector(
            onTap: () {
              _controller.resetBookFlow();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddBookPage()),
              );
            },
            child: Container(
              width: 52,
              height: 52,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: colors.terracotta,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.qr_code_scanner, color: colors.ink),
            ),
          ),

          _buildNavItem(3, 'Consultar', Icons.search_outlined, Icons.search),
          _buildNavItem(4, 'Mais', Icons.menu_outlined, Icons.menu),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String label,
    IconData iconOff,
    IconData iconOn,
  ) {
    final colors = context.colors;
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LocationsPage()),
          );
        } else if (index == 3) {
          _controller.resetConsultFlow();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ConsultBookPage()),
          );
        } else if (index == 4) {
          Scaffold.of(context).openDrawer();
        } else {
          setState(() => _currentIndex = index);
        }
      },
      child: Container(
        color: Colors.transparent,
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? iconOn : iconOff,
              color: isActive ? colors.terracotta : colors.inkFaint,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? colors.terracotta : colors.inkFaint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.screenState;
    final colors = context.colors;

    if (state is StateLoading) {
      return Scaffold(
        backgroundColor: colors.bg0,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state is StateError<void>) {
      return Scaffold(
        backgroundColor: colors.bg0,
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
        backgroundColor: colors.bg0,
        appBar: AppBar(title: const Text('Biblioteca')),
        drawer: _buildDrawer(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AppEmptyState(
              icon: AppIcons.shelf,
              iconColor: colors.plum,
              title: 'Nenhuma coleção selecionada',
              message: 'Abra o menu lateral para criar ou escolher uma.',
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.bg0,
      drawer: _buildDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: 20,
            right: 12,
          ),
          decoration: BoxDecoration(
            color: colors.bg0,
            border: Border(bottom: BorderSide(color: colors.line)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _controller.currentCollection!.name,
                      style: AppTypography.display(
                        color: colors.ink,
                        fontSize: 20,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${_controller.currentBooks.length} livros',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12,
                        color: colors.inkFaint,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: HugeIcon(
                  icon: AppIcons.exploreLocation,
                  color: colors.ink,
                ),
                onPressed: _showCreateLocationDialog,
              ),
            ],
          ),
        ),
      ),

      body: _controller.currentBooks.isEmpty
          ? Center(
              child: AppEmptyState(
                icon: AppIcons.book,
                iconColor: colors.moss,
                title: 'Sua coleção está vazia',
                message:
                    'Adicione seu primeiro livro pelo botão de scanner abaixo.',
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.65,
                crossAxisSpacing: 16,
                mainAxisSpacing: 24,
              ),
              itemCount: _controller.currentBooks.length,
              itemBuilder: (context, index) {
                final book = _controller.currentBooks[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailPage(book: book),
                      ),
                    );
                  },
                  child: BookCoverTile(
                    title: book.title,
                    author: book.author.isEmpty ? null : book.author,
                    seed: book.id,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                );
              },
            ),

      bottomNavigationBar: _buildBottomNav(),
    );
  }
}
