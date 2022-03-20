import 'package:flutter/material.dart';
import '../model/validation_item.dart';

class InputValidation with ChangeNotifier{

  late ValidationItem _input;
  final _regInput = RegExp(r'^[a-zA-Z]+$');
  late bool playerHasWon;
  late String wordToFind;

  InputValidation() {
    initForm();
  }

  // Getters
  ValidationItem get input => _input;

  // Setters
  void initForm() {
    // Initializing new game
    _input = ValidationItem(null, null);
    playerHasWon = false;
  }

  void setWordToFind(String wordAllCaps) {
    wordToFind = wordAllCaps;
  }

  // Checking input format as player types in
  void changeInput(String value, error) {
    if(_regInput.hasMatch(value) || value.isEmpty) {
      _input = ValidationItem(value, null);
    } else {
      _input = ValidationItem(value, 'Caractère(s) invalides!');
    }
    notifyListeners();
  }

  // Checking input format as player clicks on the 'Envoi' button
  validateInput(BuildContext context, playerPropositionExists) {

    String _checkInputLength = _input.value ?? '';

    if(_input.error != null) {
      var _message = 'Votre proposition ne peut pas contenir de caractères spéciaux ou accentués';
      showValidationError(context, _message);
      return null;
    } else if(_checkInputLength.length < 5) {
      var _message = 'Votre proposition doit contenir 5 caractères';
      showValidationError(context, _message);
      return null;
    }

    if(!playerPropositionExists) {
      var _message = 'Le mot que vous proposez doit être un mot du dictionnaire';
      showValidationError(context, _message);
      return null;
    }

    return checkResult(_input.value);
    
  }

  // Showing validation message in snackbar
  void showValidationError(BuildContext context, String _message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text(
            _message,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          duration: (const Duration(seconds: 3)),
          elevation: 0,
          backgroundColor: Colors.black,
        ),
      );
  }

  dynamic checkResult(proposition) {

    // Procedure used to compare two words and to give ths status of the different letters
    // ***********************************************************************************

    // Procedure build a result variable containing an evaluation of every square:
    // OK (letter found) - MP (letter misplaced) - KO (letter not found)

    // Initialization of variables
    // ---------------------------

    bool _debug = false; // Activation of the debug of the procedure in the console

    int _numOKLetters = 0; // number of well-placed letters (used to determine if player has won)

    List<String> _wordLettersList = []; // List used to store each letters of the word to be found
    List<String> _propositionLettersList = []; // List used to store each letters of the player proposition
    List<String> _result = []; // List which will hold the results of the comparison process
    List<Map> lstOutput = []; // List used to ship the evaluation data to the grid object to update the squares
    // Creating lists of letters which can be compared
    _wordLettersList = wordToFind.split("");
    _propositionLettersList = proposition.toUpperCase().split("");


    // Comparison process
    // ------------------

    List _ctrlWordLettersList = _wordLettersList.sublist(0); // Working copy of the word list
    List _ctrlPropositionLettersList = _propositionLettersList.sublist(0); // Working copy of the proposition list

    // First iteration: looking for exact matches between word and proposition and remove them from the scope of the search
    for(var i=0; i < _wordLettersList.length; i++) {
      _result.add("?"); // Initialisation of the list of results with default values
      if(_ctrlWordLettersList[i] == _ctrlPropositionLettersList[i]) { // if exact match...
        _ctrlWordLettersList[i] =  _ctrlPropositionLettersList[i] = "!"; // ...then remove from ths scope of the search
        _result[i] = "OK";
        _numOKLetters++;
      }
    }

    // Second iteration: looking for misplaced or wrong letters in the proposition
    for(var i=0; i < _wordLettersList.length; i++) {
      if(_ctrlPropositionLettersList[i] != "!") { // Making sure the current letter has not been marked as an exact match in iteration 1
        if(_ctrlWordLettersList.contains(_ctrlPropositionLettersList[i])) { // if current letter is misplaced...
          _ctrlWordLettersList[_ctrlWordLettersList.indexOf(_ctrlPropositionLettersList[i])] = "!"; // ...then marking the case as "treated"
          _result[i] = "MP";
        } else {
          _result[i] = "KO";
        }
      }
    }

    // Composing the object which will be shipped to the grid object
    for(var i=0; i < _wordLettersList.length; i++) {
      Map _tmpMap = {'content': _propositionLettersList[i], 'style': _result[i]};
      lstOutput.add(_tmpMap);
    }

    // Has the player won ?
    if(_numOKLetters == 5) {
      playerHasWon = true;
    }


    // Displaying process result in console
    // ------------------------------------
    if(_debug) {
      print("");
      print("Word to be found: $_wordLettersList");
      print("Player proposition: $_propositionLettersList");
      print("");
      print("");
      print("RESULTS");
      print("\t\t #1 \t #2 \t #3 \t #4 \t #5");
      print(
          "Word\t\t ${_wordLettersList[0]} \t ${_wordLettersList[1]} \t ${_wordLettersList[2]} \t ${_wordLettersList[3]} \t ${_wordLettersList[4]}");
      print("\t\t | \t | \t | \t | \t |");
      print(
          "Proposition\t ${_propositionLettersList[0]} \t ${_propositionLettersList[1]} \t ${_propositionLettersList[2]} \t ${_propositionLettersList[3]} \t ${_propositionLettersList[4]}");
      print("\t\t | \t | \t | \t | \t |");
      print(
          "Result\t\t ${_result[0]} \t ${_result[1]} \t ${_result[2]} \t ${_result[3]} \t ${_result[4]}");
      print("");
    }

    // Important to reinitialize the stored value of the input field !
    _input = ValidationItem(null, null);

    return lstOutput;

  }

}