// entity/person.dart

import 'package:floor/floor.dart';

@entity
class UserLocation {
  @primaryKey
  final int? id;

  final double latitude;
  final double longitude;

  final int routeId;

  UserLocation(this.id, this.latitude, this.longitude, this.routeId);
}