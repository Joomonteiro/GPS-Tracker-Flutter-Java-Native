// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility that Flutter provides. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.
// import 'package:floor/floor.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:gps_tracker/db/database.dart';

// import 'package:gps_tracker/main.dart';

// void main() {
//   late AppDatabase db;
//   setDatabase() async {
//     return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
//   }

//   // group('database tests', () {
//   //   late AppDatabase database;
//   //   // late PersonDao personDao;

//   //   setUp(() async {
//   //     database = await $FloorAppDatabase
//   //         .inMemoryDatabaseBuilder()
//   //         .build();
//   //     // personDao = database.personDao;
//   //   });

//   //   tearDown(() async {
//   //     await database.close();
//   //   });

//   //   // test('find person by id', () async {
//   //   //   final person = Person(1, 'Simon');
//   //   //   await personDao.insertPerson(person);

//   //   //   final actual = await personDao.findPersonById(person.id);

//   //   //   expect(actual, equals(person));
//   //   // });
//   // },
  
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//       late AppDatabase db;
//     // late PersonDao personDao;

//     setUp(() async {
//       db = await $FloorAppDatabase
//           .inMemoryDatabaseBuilder()
//           .build();
//       // personDao = database.personDao;
//     });

//     tearDown(() async {
//       await db.close();
//     });
//     // Build our app and trigger a frame.
    
//     await tester.pumpWidget(const MyApp(db:db);
    

//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);

//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }
