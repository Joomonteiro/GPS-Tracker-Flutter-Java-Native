// Imports the Flutter Driver API.
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Concessionaria App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final botaoDeContinuar = find.byValueKey('botaoIniciaRastreio');
    // final botaoDeContinuarSemLogin = find.byValueKey('botaoDeContinuarSemLogin');
    // final botaoDeVeiculos = find.byValueKey('botaoDeVeiculos');
    // final botaoParaAdicionarEEditarVeiculos = find.byValueKey('botaoParaAdicionarEEditarVeiculos');
    // final txtFieldCadastrarVeiculo = find.byValueKey('txtFieldCadastrarVeiculo');
    // final botaoDeAdicionarVeiculo = find.byValueKey('botaoDeAdicionarVeiculo');
    
    // final buttonFinder = find.byValueKey('increment');

    late FlutterDriver driver;

    Future<bool> isPresent(SerializableFinder byValueKey,
        {Duration timeout = const Duration(seconds: 5)}) async {
      try {
        await driver.waitFor(byValueKey, timeout: timeout);
        return true;
      } catch (exception) {
        return false;
      }
    }
    
    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      
      driver = await FlutterDriver.connect();
      //  await sleep(Duration(seconds: 10));
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });

    test('Clicar no botao de continuar', () async {
       if (await isPresent(botaoDeContinuar)) {
        await driver.tap(botaoDeContinuar);
        await driver.waitFor(find.text("Stop Tracking"));
      }
      //  if (await isPresent(botaoDeContinuarSemLogin)) {
      //   await driver.tap(botaoDeContinuarSemLogin);
      // }
      //  if (await isPresent(botaoDeVeiculos)) {
      //   await driver.tap(botaoDeVeiculos);
      // }
      
      //  if (await isPresent(botaoParaAdicionarEEditarVeiculos)) {
      //   await driver.tap(botaoParaAdicionarEEditarVeiculos);
      // }
      //  if (await isPresent(txtFieldCadastrarVeiculo)) {
      //   await driver.tap(txtFieldCadastrarVeiculo);
      // }
      //  if (await isPresent(botaoDeAdicionarVeiculo)) {
      //   await driver.tap(botaoDeAdicionarVeiculo);
      //   await driver.enterText("2020");
      //   await driver.waitFor(find.text("2020"));

      // }
      
      // expect(await driver.getText(co;unterTextFinder), "0");
    });

    // test('increments the counter', () async {
    //   // First, tap the button.
    //   await driver.tap(buttonFinder);

    //   // Then, verify the counter text is incremented by 1.
    //   expect(await driver.getText(counterTextFinder), "1");
    // });

    // test('increments the counter during animation', () async {
    //   await driver.runUnsynchronized(() async {
    //     // First, tap the button.
    //     await driver.tap(buttonFinder);

    //     // Then, verify the counter text is incremented by 1.
    //     expect(await driver.getText(counterTextFinder), "1");
    //   });
    // });
  });
}