class Flashcard {
  late String front;
  late String back;

  Flashcard(this.front, this.back);

  @override
  String toString() => 'front: $front \nback: $back';
}