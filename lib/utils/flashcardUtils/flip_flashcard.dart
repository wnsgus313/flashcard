import 'package:flashcard/utils/flashcardUtils/rounded_flashcard.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

import '../../models/flashcard.dart';

class FlippableFlashcard extends StatefulWidget {
  const FlippableFlashcard({Key? key, required this.card}) : super(key: key);
  final Flashcard card;

  @override
  State<FlippableFlashcard> createState() => _FlippableFlashcardState();
}

class _FlippableFlashcardState extends State<FlippableFlashcard> {
  @override
  Widget build(BuildContext context) {
    return FlipCard(
      front: RoundedFlashcard(
          card: widget.card,
          child: Text(
            widget.card.front,
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          )),
      back: RoundedFlashcard(
        card: widget.card,
        child: Text(
          widget.card.back,
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}