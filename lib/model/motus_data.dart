import 'dart:math';

import 'package:firebase/firebase_io.dart';
import 'package:flutter/material.dart';

class MotusData with ChangeNotifier{

  late String _wordAllCaps;
  late String _wordSmallCaps;

  MotusData() {
    getWordToFind();
  }

  // Getter
  String get wordSmallCaps => _wordSmallCaps;
  String get wordAllCaps => _wordAllCaps;


  // Picking a random word in the DB
  Future<String> getWordToFind() async {
      print('-- getWordToFind ran');
      FirebaseClient fbClient = FirebaseClient.anonymous();
      Map<String,dynamic> response;
      String path;

      // Getting number of words available from the param collection
      path = 'https://motus-12db3-default-rtdb.europe-west1.firebasedatabase.app/param.json';
      response = await fbClient.get(path);
      int count = response['count'];
      print('# of words: $count');

      // Generating random number
      Random random = Random();
      int randomNumber = random.nextInt(count-1) + 1; // from 1 to count

      path = 'https://motus-12db3-default-rtdb.europe-west1.firebasedatabase.app/words/$randomNumber/word.json';
      response = await fbClient.get(path);

      response.forEach((key, value) {
        _wordAllCaps = key;
        _wordSmallCaps = value;
      });

      print('random word #$randomNumber: $_wordSmallCaps');
      return _wordAllCaps;
  }

  Future<bool> checkIfExists(String? wordToBeChecked) async {

    if(wordToBeChecked != null) {
      FirebaseClient fbClient = FirebaseClient.anonymous();
      Map<String, dynamic> response = {};
      var path = 'https://motus-12db3-default-rtdb.europe-west1.firebasedatabase.app/check/$wordToBeChecked.json';

      response = await fbClient.get(path) ?? response;
      if(response.isEmpty) {
        // If the proposed word has not been found in the DB
        print('Word: $wordToBeChecked has not been found !');
      } else {
        // If the proposed word has been found in the DB -> proceed to the full check
        print('Word $wordToBeChecked has been found ! ${response}');
        return true;
      }
    }
      return false;

  }

}