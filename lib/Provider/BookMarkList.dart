import 'package:flutter/material.dart';

class BookMarkList with ChangeNotifier {
  List<Map<String,dynamic>> results = [];

  List<Map<String,dynamic>> get getData => results;

  void setData (List<Map<String,dynamic>> data){
    results = data;
    notifyListeners();
  }
}