import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:gps_tracker/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
    (WidgetTester tester) async {
      app.main();

      // Econtra o widget de iniciar o rastreio 
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 10));
      final Finder buttonTracking = find.text('Start tracking');
      expect(buttonTracking, findsOneWidget);
      
      // Inicia uma nova rota e estpera encontrar o widget para parar o rastreio
      await tester.tap(buttonTracking);
      await Future.delayed(const Duration(seconds: 10));
      final Finder buttonStopTracking = find.text('Stop tracking');
      expect(buttonStopTracking, findsOneWidget);

      // Para o rastreio
      await tester.tap(buttonStopTracking);
     
      // Espera encontrar o widget de rotas
      final Finder button = find.byIcon(Icons.add_location_alt_rounded);
      expect(button, findsOneWidget);

      // Toca no icone de rotas e espera encontrar o widget appbar na proxima página
      await tester.tap(button);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 10));
      final Finder routesAppRoutes = find.text('Rotas');
      expect(routesAppRoutes, findsOneWidget);
      
      // Espera encontrar um widget de rota na lista
      final Finder routeItemList = find.byKey(const Key('routeItemList'));
      expect(routeItemList, findsOneWidget);

      // Toca no item de rota na lista e espera encontrar o widget de appBar da proxima tela de listagem
      // de locais
      await tester.tap(routeItemList);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 10));
      final Finder appBarRouteList = find.text('Locais da Rota');
      expect(appBarRouteList, findsOneWidget);

    });
  });
}