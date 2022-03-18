
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowResult {

  ShowResult(BuildContext context, bool victory, String wordSmallCaps) {

    // Wikitionnaire url
    String wikiUrl = 'https://fr.wiktionary.org/wiki';

    // set up the wikitionnaire button
    Widget wikiButton = TextButton(
      child: const Text("Voir la définition sur wikitionnaire"),
      onPressed: () async {
          var url = Uri.encodeFull('$wikiUrl/$wordSmallCaps');
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
      title: const Text("Bien joué !"),
      content: Text("Vous avez trouvé ! '$wordSmallCaps' était bien le mot recherché ! \n\nCliquez sur 'OK' pour démarrer une nouvelle partie"),
      actions: [
        wikiButton, okButton,
      ],
    );

    // set up the AlertDialog for losers
    AlertDialog alertPlayerLoses = AlertDialog(
      title: Text("Pas de chance..."),
      content: Text("Le mot recherché était: '$wordSmallCaps'... \n\nCliquez sur 'OK' pour démarrer une nouvelle partie."),
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