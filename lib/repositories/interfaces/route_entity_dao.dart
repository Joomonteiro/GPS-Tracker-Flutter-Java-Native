// dao/person_dao.dart

import 'package:floor/floor.dart';
import 'package:gps_tracker/models/route.dart';

@dao
abstract class RouteEntityDao {
  @Query('SELECT * FROM RouteEntity')
  Future<List<RouteEntity>> findAllRouteEntity();

  @Query('SELECT * FROM RouteEntity WHERE id = :id')
  Stream<RouteEntity?> findRouteEntityById(int id);

  @Query('SELECT * FROM RouteEntity ORDER BY id DESC LIMIT 1')
  Future<List<RouteEntity>> findLastRouteEntity();

  @insert
  Future<void> insertRouteEntity(RouteEntity routeEntity);
}
