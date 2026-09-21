import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/di/service_locator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/entities/models.dart';
import '../controllers/library_controller.dart';
import '../widgets/app_text_input.dart';
import '../widgets/book_cover_tile.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final _controller = getIt<LibraryController>();

  void _showEditDialog() {
    final titleController = TextEditingController(text: widget.book.title);
    final authorController = TextEditingController(text: widget.book.author);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.colors.bg1,
        title: Text(
          'Editar livro',
          style: TextStyle(
            fontFamily: 'Fraunces',
            fontSize: 20,
            color: context.colors.ink,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextInput(label: 'Título', controller: titleController),
            const SizedBox(height: AppSpacing.md),
            AppTextInput(label: 'Autor', controller: authorController),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancelar',
              style: TextStyle(color: context.colors.inkSoft),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.moss,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (titleController.text.trim().isEmpty) return;
              try {
                await _controller.updateBook(
                  widget.book,
                  titleController.text,
                  authorController.text,
                );
                if (dialogContext.mounted) Navigator.pop(dialogContext);
                if (mounted) setState(() {});
              } catch (error) {
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.colors.bg1,
        title: Text(
          'Remover livro?',
          style: TextStyle(
            fontFamily: 'Fraunces',
            fontSize: 20,
            color: context.colors.ink,
          ),
        ),
        content: Text(
          'Deseja retirar "${widget.book.title}" da coleção?',
          style: TextStyle(color: context.colors.inkSoft),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: context.colors.inkSoft),
            ),
          ),
          TextButton(
            onPressed: () {
              _controller.removeBook(widget.book.id).then((_) {
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              });
            },
            child: Text(
              'Remover',
              style: TextStyle(
                color: context.colors.wine,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoveDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.bg1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Mover para',
                style: TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: 20,
                  color: context.colors.ink,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ..._controller.currentLocations.map((loc) {
                final isCurrent = false;
                return ListTile(
                  tileColor: isCurrent
                      ? context.colors.bg3
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isCurrent
                          ? context.colors.terracotta
                          : context.colors.line,
                    ),
                  ),
                  leading: HugeIcon(
                    icon: AppIcons.location,
                    color: isCurrent
                        ? context.colors.terracotta
                        : context.colors.inkFaint,
                  ),
                  title: Text(
                    loc.name,
                    style: TextStyle(color: context.colors.ink),
                  ),
                  trailing: isCurrent
                      ? Text(
                          'atual',
                          style: TextStyle(
                            color: context.colors.terracotta,
                            fontSize: 12,
                          ),
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Livro movido!')),
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final book = widget.book;

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final locationName = 'Não definido';

    return Scaffold(
      backgroundColor: colors.bg0,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _showEditDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 320,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  BookCoverTile(
                    title: book.title,
                    seed: book.id,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colors.bg0.withOpacity(0.5),
                          Colors.transparent,
                          colors.bg0.withOpacity(0.2),
                          colors.bg0,
                        ],
                        stops: const [0.0, 0.3, 0.6, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: AppSpacing.lg,
                    left: AppSpacing.lg,
                    right: AppSpacing.lg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(
                            fontFamily: 'Fraunces',
                            fontSize: 28,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book.author,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.lg,
                bottom: AppSpacing.xl + bottomPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colors.bg1,
                      border: Border(
                        top: BorderSide(color: colors.line),
                        right: BorderSide(color: colors.line),
                        bottom: BorderSide(color: colors.line),
                        left: BorderSide(color: colors.terracotta, width: 3),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        HugeIcon(
                          icon: AppIcons.location,
                          color: colors.terracotta,
                          size: 24,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'LOCALIZAÇÃO',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 11,
                                  color: colors.inkFaint,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                locationName,
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 16,
                                  color: colors.ink,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SecondaryButton(
                          label: 'Mover',
                          onPressed: _showMoveDialog,
                          variant: SecondaryButtonVariant.outline,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 2.5,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    children: [
                      _buildMetaBox('ANO', '2024', colors),
                      _buildMetaBox('PÁGINAS', '—', colors),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _buildMetaBox('ISBN', book.isbn ?? 'Não informado', colors),

                  const SizedBox(height: AppSpacing.xl),

                  TextButton.icon(
                    onPressed: _showDeleteDialog,
                    icon: HugeIcon(
                      icon: AppIcons.trash,
                      color: colors.wine,
                      size: 20,
                    ),
                    label: Text(
                      'Remover da coleção',
                      style: TextStyle(color: colors.wine, fontSize: 14),
                    ),
                    style: TextButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaBox(String label, String value, AppColors colors) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.bg1,
        border: Border.all(color: colors.line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 11,
              color: colors.inkFaint,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              color: colors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
