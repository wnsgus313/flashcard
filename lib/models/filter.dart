import 'package:flutter/material.dart';

class FilterModel extends ChangeNotifier{
  String _filterVal = "최신순";

  String get filterVal => _filterVal;
  void setFilterVal(String? val){
    _filterVal = val!;
    notifyListeners();
  }
}
