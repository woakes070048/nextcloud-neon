import 'dart:async';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/src/platform/platform.dart';
import 'package:neon_framework/src/utils/request_manager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:timezone/timezone.dart' as tz;

final _log = Logger('RequestCache');

/// A storage used to cache a key value pair.
abstract interface class RequestCache {
  /// Get's the cached value for the given [key].
  ///
  /// Use [getParameters] if you only need to check whether the cache is still
  /// valid.
  Future<String?> get(Account account, String key);

  /// Set's the cached [value] at the given [key].
  ///
  /// If a value is already present it will be updated with the new one.
  Future<void> set(Account account, String key, String value, CacheParameters? parameters);

  /// Retrieves the cache parameters for the given [key].
  Future<CacheParameters> getParameters(Account account, String key);

  /// Updates the cache [parameters] for a given [key] without modifying the `value`.
  Future<void> updateParameters(Account account, String key, CacheParameters? parameters);
}

/// Default implementation of the [RequestCache].
///
/// Values are persisted locally in an SQLite database in the application cache
/// directory.
///
/// The database must be initialized with by calling `DefaultRequestCache().init()`
/// and awaiting it's completion. If the database is not yet initialized a
/// `StateError` will be thrown.
@internal
final class DefaultRequestCache implements RequestCache {
  /// Creates a new request cache instance.
  ///
  /// There should be no need to create multiple instances.
  DefaultRequestCache();

  @visibleForTesting
  Database? database;

  /// Initializes this request cache by setting up the backing SQLite database.
  ///
  /// This must called and completed before accessing other methods of the cache.
  Future<void> init() async {
    if (database != null) {
      return;
    }

    assert(
      NeonPlatform.instance.canUsePaths,
      'Tried to initialize DefaultRequestCache on a platform without support for paths',
    );
    final cacheDir = await getApplicationCacheDirectory();
    database = await openDatabase(
      p.join(cacheDir.path, 'cache.db'),
      version: 3,
      onCreate: onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        // We can safely drop the table as it only contains cached data.
        // Non breaking migrations should not drop the cache. The next
        // breaking change should remove all non breaking migrations before it.
        await db.transaction((txn) async {
          if (oldVersion <= 2) {
            await txn.execute('DROP TABLE cache');
            await onCreate(txn);
          }
        });
      },
    );
  }

  @visibleForTesting
  static Future<void> onCreate(DatabaseExecutor db, [int? version]) async {
    await db.execute('''
CREATE TABLE "cache" (
	"account" TEXT NOT NULL,
	"key"     TEXT NOT NULL,
	"value"   TEXT NOT NULL,
	"etag"    TEXT,
	"expires" INTEGER,
	PRIMARY KEY("key", "account")
);
''');
  }

  Database get _requireDatabase {
    final database = this.database;
    if (database == null) {
      throw StateError(
        'Cache has not been set up yet. Please make sure DefaultRequestCache.init() has been called before and completed.',
      );
    }

    return database;
  }

  @override
  Future<String?> get(Account account, String key) async {
    List<Map<String, Object?>>? result;
    try {
      result = await _requireDatabase.rawQuery(
        '''
SELECT value
FROM cache
WHERE account = ? AND key = ?
      ''',
        [account.id, key],
      );
    } on DatabaseException catch (error, stackTrace) {
      _log.severe(
        'Error while getting `$key` from cache.',
        error,
        stackTrace,
      );
    }

    return result?.firstOrNull?['value'] as String?;
  }

  @override
  Future<void> set(Account account, String key, String value, CacheParameters? parameters) async {
    try {
      // UPSERT is only available since SQLite 3.24.0 (June 4, 2018).
      // Using a manual solution from https://stackoverflow.com/a/38463024
      final batch = _requireDatabase.batch()
        ..update(
          'cache',
          {
            'account': account.id,
            'key': key,
            'value': value,
            'etag': parameters?.etag,
            'expires': parameters?.expires?.millisecondsSinceEpoch,
          },
          where: 'account = ? AND key = ?',
          whereArgs: [account.id, key],
        )
        ..rawInsert(
          '''
INSERT INTO cache (account, key, value, etag, expires)
SELECT ?, ?, ?, ?, ?
WHERE (SELECT changes() = 0)
''',
          [
            account.id,
            key,
            value,
            parameters?.etag,
            parameters?.expires?.millisecondsSinceEpoch,
          ],
        );
      await batch.commit(noResult: true);
    } on DatabaseException catch (error, stackTrace) {
      _log.severe(
        'Error while setting `$value` at `$key` in the cache.',
        error,
        stackTrace,
      );
    }
  }

  @override
  Future<CacheParameters> getParameters(Account account, String key) async {
    List<Map<String, Object?>>? result;
    try {
      result = await _requireDatabase.rawQuery(
        '''
SELECT etag, expires
FROM cache
WHERE account = ? AND key = ?
''',
        [account.id, key],
      );
    } on DatabaseException catch (error, stackTrace) {
      _log.severe(
        'Error getting the cache parameters for `$key` from cache.',
        error,
        stackTrace,
      );
    }

    final row = result?.firstOrNull;

    final expires = row?['expires'] as int?;
    return CacheParameters(
      etag: row?['etag'] as String?,
      expires: expires != null
          ? tz.TZDateTime.fromMillisecondsSinceEpoch(
              tz.UTC,
              expires,
            )
          : null,
    );
  }

  @override
  Future<void> updateParameters(Account account, String key, CacheParameters? parameters) async {
    try {
      await _requireDatabase.update(
        'cache',
        {
          'account': account.id,
          'etag': parameters?.etag,
          'expires': parameters?.expires?.millisecondsSinceEpoch,
        },
        where: 'account = ? AND key = ?',
        whereArgs: [account.id, key],
      );
    } on DatabaseException catch (error, stackTrace) {
      _log.severe(
        'Error while updating cache parameters at `$key`.',
        error,
        stackTrace,
      );
    }
  }
}
