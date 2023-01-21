import 'package:flutter/material.dart';

class setFontSize with ChangeNotifier {
  double i = 20;
  double get _i => i;

  setFontSizes(double num){
    i = num;
    notifyListeners();
  }

  addFontNum() {
    if(i > 45){
      return;
    }else{
      i += 5;
      notifyListeners();
    }
  }
  minusFontNum() {
    if(i < 25){
      return;
    }else{
      i -= 5;
      notifyListeners();
    }

    notifyListeners();
  }
}

class setFontStyle with ChangeNotifier {

  String fontStyle = '';

  setFontStyles(String value){
    fontStyle = value;
    notifyListeners();
  }
}