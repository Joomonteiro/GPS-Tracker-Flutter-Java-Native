import 'package:floor/floor.dart';

@entity
class RouteEntity {

  @primaryKey
  final int? id;

  final String name;
  final String time;

  RouteEntity(this.id, this.name, this.time);
}