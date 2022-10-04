import 'package:flutter/material.dart';

import '../Model/memoList.dart';

class MemoItems with ChangeNotifier {
  List<MemoList> results = [];

  List<MemoList> get getData => results;

  void setData(List<MemoList> data){
    results = data;
    notifyListeners();
  }
}