import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  // Flag para evitar que leia o mesmo código 10x no mesmo segundo e feche a tela múltiplas vezes
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aponte para o código'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: MobileScanner(
        // Callback acionado quando a câmera encontra qualquer código
        onDetect: (BarcodeCapture capture) {
          if (_isScanned) return;

          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;

            if (code != null) {
              setState(() => _isScanned = true); // Trava novas leituras

              // Fecha a tela de scanner e devolve a String lida para quem abriu
              Navigator.pop(context, code);
            }
          }
        },
      ),
    );
  }
}
