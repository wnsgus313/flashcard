import 'package:flutter/material.dart';

class SearchModel extends ChangeNotifier{
  String _searchVal = "";

  String get searchVal => _searchVal;
  void setSearchVal(String val){
    _searchVal = val;
    notifyListeners();
  }
}
