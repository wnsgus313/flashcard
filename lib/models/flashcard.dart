class Flashcard{
  late String _id;
  late final String _folderId;
  late String _front;
  late String _back;

  Flashcard(this._front, this._back, this._id, this._folderId);
  String get id => _id;
  String get front => _front;
  String get back => _back;
  String get folderId => _folderId;
  void setId(String id){
    _id = id;
  }
  void setFront(String val){
    _front = val;
  }
  void setBack(String val){
    _back = val;
  }

  @override
  String toString() => 'front: $_front \nback: $_back';
}