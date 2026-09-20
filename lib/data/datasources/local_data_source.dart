import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDataSource {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'shee_elf_offline.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sync_queue(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL,
            method TEXT NOT NULL,
            endpoint TEXT NOT NULL,
            payload TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE books_cache(
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            data TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> enqueueOperation({
    required String userId,
    required String method,
    required String endpoint,
    required Map<String, dynamic> payload,
  }) async {
    final db = await database;
    await db.insert('sync_queue', {
      'user_id': userId,
      'method': method,
      'endpoint': endpoint,
      'payload': jsonEncode(payload),
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getPendingOperations(String userId) async {
    final db = await database;
    return await db.query(
      'sync_queue',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id ASC',
    );
  }

  Future<void> removePendingOperation(int id) async {
    final db = await database;
    await db.delete('sync_queue', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> cacheData({
    required String id,
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    final db = await database;
    await db.insert('books_cache', {
      'id': id,
      'user_id': userId,
      'data': jsonEncode(data),
      'updated_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getCachedData(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books_cache',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'updated_at DESC',
    );

    return maps
        .map((map) => jsonDecode(map['data'] as String) as Map<String, dynamic>)
        .toList();
  }

  Future<void> clearCacheForUser(String userId) async {
    final db = await database;
    await db.delete('books_cache', where: 'user_id = ?', whereArgs: [userId]);
  }
}
