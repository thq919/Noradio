import 'package:flutter/material.dart';

class SearchBarModel extends ChangeNotifier {
  String searchQue = '';

  void makeSearchQue(String searchQue) {
    this.searchQue = searchQue;
    notifyListeners();
  }
}
