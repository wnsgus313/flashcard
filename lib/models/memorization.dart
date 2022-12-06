import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Memorization extends ChangeNotifier{
  String _order = '랜덤';
  String _type = '문제/답';
  bool _random = false;
  int _idx = 0; // 현재 위치
  int _count = 0; // 카드 개수
  int _score = 0; // 맞은 개수

  String get order => _order;
  String get type => _type;
  int get idx => _idx;
  int get count => _count;
  int get score => _score;

  List<dynamic> allDoc = [];

  void setOrder(String val){
    _order = val;
  }
  void setType(String val){
    _type = val;
  }
  void setRandomTrue(){
    _random = true;
  }
  void setIdx(int val){
    _idx = val;
    notifyListeners();
  }
  void setScore(int val){
    _score = val;
  }

  // 모든 카드 가져오기.
  Future<List<dynamic>> getAllDocs(String id) async {
    if(allDoc.isEmpty) {
      final result = await FirebaseFirestore.instance.collection('flashcards')
          .doc(id).collection('info').orderBy(
          'udate', descending: _order == '최신순' ? true : false)
          .get();
      AggregateQuerySnapshot countQuery = await FirebaseFirestore.instance.collection('flashcards').doc(id).collection('info').count().get();
      _count = countQuery.count;

      for (DocumentSnapshot docs in result.docs) {
        allDoc.add(docs);
      }

      if (_random) {
        shuffle();
        _random = false;
      }
    }
    return allDoc;
  }

  // 카드 랜덤 섞기.
  void shuffle(){
    allDoc.shuffle();
  }

  // 4지선다 문제 리시트 가져오기.
  List<String> getProblemList(int index){
    final random = Random();
    List<String> problemList = [allDoc[index]['back']];
    for(int i=0; i<3; i++){
      String problem = allDoc[random.nextInt(allDoc.length)]['back'];
      if(problemList.contains(problem)){
        i--;
        continue;
      }
      problemList.add(problem);
    }
    problemList.shuffle();

    return problemList;
  }
}