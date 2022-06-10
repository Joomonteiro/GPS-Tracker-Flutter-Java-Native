// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:gps_tracker/models/route.dart';
import 'package:gps_tracker/repositories/interfaces/route_entity_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:gps_tracker/repositories/interfaces/user_location_dao.dart';
import 'package:gps_tracker/entitys/user_location.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [UserLocation, RouteEntity])
abstract class AppDatabase extends FloorDatabase {
  UserLocationDao get userLocationDao;
  RouteEntityDao get routeEntityDao;
}