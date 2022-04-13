import 'package:flutter/material.dart';
import 'package:gps_tracker/pages/map_route_page.dart';
// import 'package:gps_tracker/controller/localController.dart';
// import 'package:gps_tracker/controller/rotaController.dart';
// import 'package:gps_tracker/model/LocalPorRotaModel.dart';
// import 'package:gps_tracker/model/rotaModel.dart';
// import 'package:gps_tracker/view/detalheRota.dart';

import '../db/database.dart';
import '../entitys/user_location.dart';
import '../models/route.dart';

class RouteDetails extends StatefulWidget {
  const RouteDetails({Key? key, required this.db, required this.routeId}) : super(key: key);
  static String routeName = "/historico";
  final AppDatabase db;
  final int routeId;
  @override
  _RoutesListState createState() => _RoutesListState(this.db, this.routeId);
}

class _RoutesListState extends State<RouteDetails> {
  final AppDatabase db;
  final int routeId;
  _RoutesListState(this.db, this.routeId);
  // RotaController rotaController = RotaController();
  // LocalController localController = LocalController();
  late final List<UserLocation> _localListByRoute = [];
  // late final List<RouteEntity> _listaRotascerto = [];
  // late final List<Object> _listaRotas = [{"id":1,"title":"titulo","time":"time" }];

  @override
  void initState() {
    super.initState();
    _listRotas();
    _listLocaisPorRota();
  }

  _listRotas() async {
    // _listaRotas = [];
    // rotaController.listarRotas().then(
    //   (value) {
    //     value.forEach((rota) => _listaRotas.add(rota));
    //     print(_listaRotas);
    //   },
    // );
  }
  Future<List<UserLocation>> _listUserLocations() async {
    db.userLocationDao.findAllUserLocationByRouteId(routeId).then(
        (value) { 
          for (var local in value){
            _localListByRoute.add(local);
          }
          });
    return  db.userLocationDao.findAllUserLocationByRouteId(routeId);
  }

  _listLocaisPorRota() async {
    // RotaController rotaController = RotaController();
    // var _listaRota = [];
    // rotaController.listarRotas().then(
    //   (value) {
    //     for (var rota in value) {
    //       _listaRota.add(rota);
    //     }
    //   },
    // ).then((value) {
    //   for (var i = 0; i < _listaRota.length; i++) {
    //     localController.listarLocaisPorRota(_listaRota[i].id).then(
    //       (value) {
    //         _listaLocaisPorRota
    //             .add(LocalPorRotaModel(rota: _listaRota[i], locais: value));
    //       },
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    //card to list rotas
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rotas",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        child: FutureBuilder<List<UserLocation>>(
          future: _listUserLocations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data![index].latitude.toString()),
                      subtitle: Text(
                        //tempo e id
                        "Longitute: ${snapshot.data![index].longitude} \nId: ${snapshot.data![index].id} \n pontos: ${snapshot.data!.length}",
                      ),
                      onTap: () {
                        
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () {
          //ir para a pagina de rota passando rotas
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapRoutePage(
                                locais: _localListByRoute,
                              ),
                            ),
                          );
          // Navigator.push(context, MaterialPageRoute(builder: (context) => RoutesList(db: db,)));
        },
        child: const Icon(Icons.route_outlined),
      ),
    );
  }
}

