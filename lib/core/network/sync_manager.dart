import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/datasources/local_data_source.dart';
import 'api_client.dart';
import 'network_info.dart';

class SyncManager {
  final LocalDataSource localDataSource;
  final ApiClient apiClient;
  final NetworkInfo networkInfo;
  final FlutterSecureStorage secureStorage;

  bool _isSyncing = false;

  SyncManager({
    required this.localDataSource,
    required this.apiClient,
    required this.networkInfo,
    required this.secureStorage,
  });

  void startListening() {
    networkInfo.onConnectionChange.listen((hasConnection) {
      if (hasConnection) {
        syncPendingOperations();
      }
    });
  }

  Future<void> syncPendingOperations() async {
    if (_isSyncing) return;

    final hasConnection = await networkInfo.isConnected;
    if (!hasConnection) return;

    final currentUser = await secureStorage.read(key: 'current_user_email');
    if (currentUser == null) return;

    _isSyncing = true;

    try {
      final pendingOps = await localDataSource.getPendingOperations(
        currentUser,
      );

      for (final op in pendingOps) {
        final success = await _processOperation(op);
        if (success) {
          await localDataSource.removePendingOperation(op['id'] as int);
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<bool> _processOperation(Map<String, dynamic> operation) async {
    try {
      final method = operation['method'] as String;
      final endpoint = operation['endpoint'] as String;
      final payloadStr = operation['payload'] as String;
      final payload = payloadStr.isNotEmpty ? jsonDecode(payloadStr) : null;

      await apiClient.dio.request(
        endpoint,
        data: payload,
        options: Options(method: method),
      );

      return true;
    } on DioException catch (e) {
      if (ApiClient.isOfflineException(e)) {
        return false; // Sem internet: mantém na fila para tentar depois
      }
      return true; // Erro 400/500 da API: remove da fila para não gerar loop infinito
    } catch (_) {
      return false;
    }
  }
}
