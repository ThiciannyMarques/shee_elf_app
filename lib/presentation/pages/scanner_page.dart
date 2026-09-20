import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_spacing.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with WidgetsBindingObserver {
  late final MobileScannerController _cameraController;
  bool _isScanned = false;
  bool _torchOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Inicialização orientada a hardware com prioridade para ISBN (EAN-13)
    _cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
      autoStart: true,
      formats: const [
        BarcodeFormat.ean13, // ISBN padrão de livros
        BarcodeFormat.ean8, // Livros de bolso e edições compactas
        BarcodeFormat.upcA, // Livros importados
        BarcodeFormat.upcE,
        BarcodeFormat.code128, // Códigos patrimoniais/bibliotecas
        BarcodeFormat.all, // Fallback para qualquer outro formato
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Gerenciamento de ciclo de vida nativo para evitar bloqueio de câmera no Android
    if (!_cameraController.value.isInitialized) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _cameraController.stop();
    } else if (state == AppLifecycleState.resumed) {
      _cameraController.start();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture capture) async {
    if (_isScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? code = barcode.rawValue ?? barcode.displayValue;

      if (code != null && code.trim().isNotEmpty) {
        setState(() => _isScanned = true);

        // Libera o sensor da câmera no driver da Samsung antes de fechar a rota
        await _cameraController.stop();

        if (mounted) {
          Navigator.pop(context, code.trim());
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.deepBlue,
      appBar: AppBar(
        title: const Text('Escanear Código de Barras'),
        backgroundColor: colors.deepBlue,
        foregroundColor: Colors.white,
        actions: [
          // Controle de iluminação útil para leitura de códigos em papel
          IconButton(
            icon: HugeIcon(
              icon: _torchOn ? AppIcons.flashOn : AppIcons.flashOff,
              color: _torchOn ? colors.butter : Colors.white,
            ),
            tooltip: 'Lanterna',
            onPressed: () {
              _cameraController.toggleTorch();
              setState(() => _torchOn = !_torchOn);
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Feed contínuo da câmera nativa
          MobileScanner(
            controller: _cameraController,
            onDetect: _handleBarcode,
            errorBuilder: (context, error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HugeIcon(icon: AppIcons.videoOff, color: colors.wine, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        'Falha ao acessar a câmera nativa: ${error.errorCode.name}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Verifique se a permissão de câmera foi concedida no menu Configurações do dispositivo.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Máscara escura ao redor do visor (guia visual de foco)
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.black54,
              BlendMode.srcOut,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 280,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Borda do enquadramento de leitura, com a folhinha da floresta no canto
          Center(
            child: SizedBox(
              width: 280,
              height: 160,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.terracotta, width: 3),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  Positioned(
                    left: -14,
                    top: -14,
                    child: HugeIcon(icon: AppIcons.leaf, color: colors.moss, size: 26),
                  ),
                ],
              ),
            ),
          ),

          // Instruções explícitas de ação do usuário em tempo real
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: const Border.fromBorderSide(BorderSide(color: Colors.white24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HugeIcon(icon: AppIcons.sparkles, color: colors.butter, size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        'Leitura Automática',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Aponte para as linhas do código de barras (ISBN).\nNão é necessário tirar foto ou tocar na tela.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
