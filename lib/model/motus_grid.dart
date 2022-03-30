import 'package:flutter/material.dart';
import 'square.dart';

class MotusGrid with ChangeNotifier {

  final int _cols = 5;
  final int _rows = 6;
  final _mapSquares = {};
  late List<Widget> lstSquaresWidgets;
  late int tryNum; // Current player try 
  String label = 'Test';

  // Constructor used to build the grid and instanciate all squares
  MotusGrid() {
    initGrid();
  }

  void initGrid() {
    
    tryNum = 1;
    lstSquaresWidgets = [];

    for(var r = 1; r<=_rows; r++) {
      for(var c = 1; c<=_cols; c++) {
        var _index = int.parse('$r$c');
        _mapSquares[_index] = Square(content: '', style: 'KO');
        lstSquaresWidgets.add(_mapSquares[_index].getSquare());
      }
    }
    // Notifying provider listeners
    notifyListeners();
  }
  
  // Returns the list of squares widget
  List<Widget> buildGrid() {
    return lstSquaresWidgets;
  }

  // Updates the squares after the evaluation of the player proposition
  void updateGrid(result) {

    for(var i=0; i < _cols; i++) {
      var c = i + 1;
      var _index = int.parse('$tryNum$c');

      _mapSquares[_index].content = result[i]['content'];
      _mapSquares[_index].style = result[i]['style'];

    }

    // Rebuilding the list containing the squares widgets provided to build the grid
    lstSquaresWidgets = [];

    for(var r = 1; r<=_rows; r++) {
      for(var c = 1; c<=_cols; c++) {
        var _index = int.parse('$r$c');
        lstSquaresWidgets.add(_mapSquares[_index].getSquare());
      }
    }

    // Incrementing player try number
    tryNum++;

    // Notifying provider listeners
    notifyListeners();

  }

}