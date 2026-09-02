import 'dart:math';

abstract class ScannerService {
  Future<String?> scanCode();
}

class MockScannerServiceImpl implements ScannerService {
  @override
  Future<String?> scanCode() async {
    // Simula o tempo que o usuário leva abrindo a câmera e escaneando
    await Future.delayed(const Duration(seconds: 2));

    // Sorteia ISBNs simulados para você conseguir testar
    // "livro novo" vs "livro já existente" no MVP
    final mockIsbns = ['9780001', '9780002', '9780003', '978_INVALIDO'];
    return mockIsbns[Random().nextInt(mockIsbns.length)];
  }
}
