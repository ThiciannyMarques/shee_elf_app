import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/di/service_locator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/entities/models.dart';
import '../controllers/library_controller.dart';
import '../widgets/app_text_input.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
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

  void _showLocationDialog({Location? location}) {
    final isEditing = location != null;
    final textController = TextEditingController(
      text: isEditing ? location.name : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.bg1,
        title: Text(
          isEditing ? 'Renomear lugar' : 'Novo lugar',
          style: TextStyle(
            fontFamily: 'Fraunces',
            fontSize: 20,
            color: context.colors.ink,
          ),
        ),
        content: AppTextInput(
          label: 'Nome',
          hintText: 'Ex: Estante Principal',
          controller: textController,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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
              if (textController.text.trim().isEmpty) return;
              try {
                if (isEditing) {
                  await _controller.updateLocation(
                    location,
                    textController.text.trim(),
                  );
                } else {
                  await _controller.createNewLocation(
                    textController.text.trim(),
                  );
                }
                if (mounted) Navigator.pop(context);
              } catch (e) {
                if (mounted) Navigator.pop(context);
              }
            },
            child: Text(isEditing ? 'Salvar' : 'Criar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Location location) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.colors.bg1,
        title: Text(
          'Remover lugar',
          style: TextStyle(
            fontFamily: 'Fraunces',
            fontSize: 20,
            color: context.colors.ink,
          ),
        ),
        content: Text(
          'Tem certeza que deseja remover "${location.name}"? Os livros não serão excluídos.',
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
              _controller.deleteLocation(location).then((_) {
                if (context.mounted) Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locations = _controller.currentLocations;

    return Scaffold(
      backgroundColor: colors.bg0,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lugares',
              style: TextStyle(
                fontFamily: 'Fraunces',
                fontSize: 24,
                color: colors.ink,
              ),
            ),
            Text(
              'Onde seus livros estão guardados',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12,
                color: colors.inkFaint,
              ),
            ),
          ],
        ),
        backgroundColor: colors.bg0,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.ink),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: colors.inkSoft),
            onPressed: () => _showLocationDialog(),
          ),
        ],
      ),
      body: locations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: colors.bg2,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      Icons.vpn_key_rounded,
                      color: colors.terracotta,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Nenhum lugar ainda',
                    style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 24,
                      color: colors.ink,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Adicione lugares como "Sala de Estar", "Quarto" ou "Caixa 1" para organizar seus livros.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: colors.inkFaint,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.moss,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _showLocationDialog(),
                    child: const Text(
                      'Adicionar primeiro lugar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: locations.length,
              separatorBuilder: (_, __) =>
                  Divider(color: colors.line, height: 1),
              itemBuilder: (context, index) {
                final loc = locations[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.bg2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.vpn_key_rounded,
                      color: colors.terracotta,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    loc.name,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      color: colors.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '0 livros',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 12,
                      color: colors.inkFaint,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        color: colors.inkFaint,
                        onPressed: () => _showLocationDialog(location: loc),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        color: colors.inkFaint,
                        onPressed: () => _showDeleteDialog(loc),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
