abstract class BarcodeScannerService {
  Future<String?> scanBarcode();
}

class MockBarcodeScannerServiceImpl implements BarcodeScannerService {
  @override
  Future<String?> scanBarcode() async {
    await Future.delayed(
      const Duration(seconds: 1),
    ); // Simula o tempo do usuário apontando a câmera
    return '9781569319017'; // Retorna o ISBN mockado
  }
}
