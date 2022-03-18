import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/motus_grid.dart';
import 'screens/show_result.dart';
import 'validation/input_validation.dart';
import 'model/motus_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<MotusGrid>(create: (_) => MotusGrid()),
          ChangeNotifierProvider<InputValidation>(create: (_) => InputValidation()),
          ChangeNotifierProvider<MotusData>(create: (_) => MotusData()),
        ],
    
          child: MaterialApp(
            // Hide the debug banner
            debugShowCheckedModeBanner: false,
            title: 'Motus 2.0',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey
            ),
            home: MyHomePage(),
          ),
        ),
    );
  }
}


class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final title = 'Motus 2.0';
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    MotusGrid _grid = Provider.of<MotusGrid>(context);
    InputValidation _validationService = Provider.of<InputValidation>(context);
    MotusData _db = Provider.of<MotusData>(context);

    test() {
      print('-- homepage: test');
    }

    // Triggers player input validation
    validateForm(String wordAllCaps) async {

      // Checking if user proposition is an existing word
      bool playerPropositionExists = await _db.checkIfExists(_validationService.input.value!.toUpperCase());
      // Injecting word to be found in validation service
      _validationService.setWordToFind(wordAllCaps);
      // Checking player proposition
      dynamic _result = _validationService.validateInput(context, playerPropositionExists);
      // Updating grid result in grid
      _grid.updateGrid(_result);
      
      // Is this the end of the game ?
      if(_grid.tryNum > 6 || _validationService.playerHasWon) {
        // Showing popup with result
        ShowResult(context, _validationService.playerHasWon, _db.wordSmallCaps);

        // Intializing new game
        _grid.initGrid();
        _validationService.initForm();
        _validationService.setWordToFind(await _db.getWordToFind());
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 10,  40, 10),
        child: 
            ListView(
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                   SizedBox(
                    width: 200,
                    child: TextField(
                    controller: _controller,
                    maxLength: 5,
                    onChanged: (String value) {
                      _validationService.changeInput(value, null);
                    },
                    decoration: InputDecoration(
                      labelText: 'Votre proposition:',
                      errorText: _validationService.input.error,
                      hintText: 'Entrez un mot de 5 lettres',
                      /*suffixIcon: IconButton(     // Icon to 
                          icon: const Icon(Icons.clear), // clear text
                          onPressed: _controller.clear,
                      ),*/
                    ),
                ),
                  ),
                  const SizedBox(width: 10),
                ElevatedButton(
                onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    validateForm(_db.wordAllCaps);
                    _controller.clear();
                }, 
                child: const Text('Envoi')),
                ],
              ),

              const SizedBox(height: 20),

              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
                children: _grid.lstSquaresWidgets,
              ),

              const SizedBox(height: 20),
                
              ]
            )
        )
      );
      
  }
}

