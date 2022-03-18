import 'package:flutter/material.dart';

class Square {

late String content;
late Decoration decoration;
late String style;

Square({required this.content, required this.style});

Widget getSquare() {

  Decoration decoration = setDecoration(style);

  return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      decoration: decoration,
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
    );

}


BoxDecoration setDecoration([type]) {

// Decoration of the letter containers
// -----------------------------------

if(type == 'KO') {
  // Letter not found
  return BoxDecoration(
      color: Colors.grey[300],
      border: Border.all(
        color: Colors.grey,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(12)
  );
} else if(type == 'MP') {
  return BoxDecoration(
    color: Colors.orange,
    border: Border.all(
      color: Colors.grey,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(12)
  );
} else { // type == 'OK' -> Letter found
  return BoxDecoration(
    color: Colors.green,
    border: Border.all(
      color: Colors.grey,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(12)
  );
}

}

}