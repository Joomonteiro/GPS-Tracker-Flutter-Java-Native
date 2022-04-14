import 'package:flutter/material.dart';
import 'package:gps_tracker/pages/route_details.dart';
// import 'package:gps_tracker/controller/localController.dart';
// import 'package:gps_tracker/controller/rotaController.dart';
// import 'package:gps_tracker/model/LocalPorRotaModel.dart';
// import 'package:gps_tracker/model/rotaModel.dart';
// import 'package:gps_tracker/view/detalheRota.dart';

import '../db/database.dart';
import '../models/route.dart';

class RoutesList extends StatefulWidget {
  const RoutesList({Key? key, required this.db}) : super(key: key);
  static String routeName = "/historico";
  final AppDatabase db;
  @override
  _RoutesListState createState() => _RoutesListState(this.db);
}

class _RoutesListState extends State<RoutesList> {
  final AppDatabase db;
  _RoutesListState(this.db);
  // RotaController rotaController = RotaController();
  // LocalController localController = LocalController();
  // late final List<LocalPorRotaModel> _listaLocaisPorRota = [];
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
        child: FutureBuilder<List<RouteEntity>>(
          future: db.routeEntityDao.findAllRouteEntity(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      key: const Key('routeItemList'),
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(
                        //tempo e id
                        "Data: ${snapshot.data![index].time} \nId: ${snapshot.data![index].id}",
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RouteDetails(
                              db: db,
                              routeId: snapshot.data![index].id!
                            ),
                          ),
                        );
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
    );
  }
}
