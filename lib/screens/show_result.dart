
import 'package:flutter/material.dart';
import 'package:gridview_example/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowResult {

  ShowResult(BuildContext context, bool victory, String wordSmallCaps) {

    // Wikitionnaire url
    String wikiUrl = 'https://fr.wiktionary.org/wiki';

    // set up the wikitionnaire button
    Widget wikiButton = TextButton(
      child: const Text("Show word def. in wikitionnaire"),
      onPressed: () async {
          var url = Uri.encodeFull('$wikiUrl/$wordSmallCaps');
          print(url);
          await launch(url); // requires a modification in AndroidManifest.xml in order to work
        },
    );

    // set up the ok button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        // Dismiss the alert Dialog
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog for winners
    AlertDialog alertPlayerWins = AlertDialog(
      title: const Text("Good job !"),
      content: Text("You found it ! $wordSmallCaps was the word ! \n\nClick on the 'OK' button to start a new game."),
      actions: [
        wikiButton, okButton,
      ],
    );

    // set up the AlertDialog for losers
    AlertDialog alertPlayerLoses = AlertDialog(
      title: Text("Well..."),
      content: Text("The word you were looking for was: $wordSmallCaps... \n\nClick on the 'OK' button to start a new game."),
      actions: [
        wikiButton, okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return victory ? alertPlayerWins : alertPlayerLoses;
      },
    );
  }


}