// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserLocationDao? _userLocationDaoInstance;

  RouteEntityDao? _routeEntityDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserLocation` (`id` INTEGER, `latitude` REAL NOT NULL, `longitude` REAL NOT NULL, `routeId` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `RouteEntity` (`id` INTEGER, `name` TEXT NOT NULL, `time` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserLocationDao get userLocationDao {
    return _userLocationDaoInstance ??=
        _$UserLocationDao(database, changeListener);
  }

  @override
  RouteEntityDao get routeEntityDao {
    return _routeEntityDaoInstance ??=
        _$RouteEntityDao(database, changeListener);
  }
}

class _$UserLocationDao extends UserLocationDao {
  _$UserLocationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _userLocationInsertionAdapter = InsertionAdapter(
            database,
            'UserLocation',
            (UserLocation item) => <String, Object?>{
                  'id': item.id,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'routeId': item.routeId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserLocation> _userLocationInsertionAdapter;

  @override
  Future<List<UserLocation>> findAllUserLocation() async {
    return _queryAdapter.queryList('SELECT * FROM UserLocation',
        mapper: (Map<String, Object?> row) => UserLocation(
            row['id'] as int?,
            row['latitude'] as double,
            row['longitude'] as double,
            row['routeId'] as int));
  }

  @override
  Future<List<UserLocation>> findAllUserLocationByRouteId(int routeId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM UserLocation WHERE routeId = ?1',
        mapper: (Map<String, Object?> row) => UserLocation(
            row['id'] as int?,
            row['latitude'] as double,
            row['longitude'] as double,
            row['routeId'] as int),
        arguments: [routeId]);
  }

  @override
  Stream<UserLocation?> findUserLocationById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM UserLocation WHERE id = ?1',
        mapper: (Map<String, Object?> row) => UserLocation(
            row['id'] as int?,
            row['latitude'] as double,
            row['longitude'] as double,
            row['routeId'] as int),
        arguments: [id],
        queryableName: 'UserLocation',
        isView: false);
  }

  @override
  Future<void> insertUserLocation(UserLocation UserLocation) async {
    await _userLocationInsertionAdapter.insert(
        UserLocation, OnConflictStrategy.abort);
  }
}

class _$RouteEntityDao extends RouteEntityDao {
  _$RouteEntityDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _routeEntityInsertionAdapter = InsertionAdapter(
            database,
            'RouteEntity',
            (RouteEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'time': item.time
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RouteEntity> _routeEntityInsertionAdapter;

  @override
  Future<List<RouteEntity>> findAllRouteEntity() async {
    return _queryAdapter.queryList('SELECT * FROM RouteEntity',
        mapper: (Map<String, Object?> row) => RouteEntity(
            row['id'] as int?, row['name'] as String, row['time'] as String));
  }

  @override
  Stream<RouteEntity?> findRouteEntityById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM RouteEntity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => RouteEntity(
            row['id'] as int?, row['name'] as String, row['time'] as String),
        arguments: [id],
        queryableName: 'RouteEntity',
        isView: false);
  }

  @override
  Future<List<RouteEntity>> findLastRouteEntity() async {
    return _queryAdapter.queryList(
        'SELECT * FROM RouteEntity ORDER BY id DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => RouteEntity(
            row['id'] as int?, row['name'] as String, row['time'] as String));
  }

  @override
  Future<void> insertRouteEntity(RouteEntity routeEntity) async {
    await _routeEntityInsertionAdapter.insert(
        routeEntity, OnConflictStrategy.abort);
  }
}
