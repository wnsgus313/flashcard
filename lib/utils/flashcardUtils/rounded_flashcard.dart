import 'package:flutter/material.dart';

import '../../models/flashcard.dart';

class RoundedFlashcard extends StatefulWidget {
  const RoundedFlashcard({Key? key, required this.card, required this.child}) : super(key: key);

  final Flashcard card;
  final Widget child;

  @override
  State<RoundedFlashcard> createState() => _RoundedFlashcardState();
}

class _RoundedFlashcardState extends State<RoundedFlashcard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          height: 500,
          child: FractionallySizedBox(
              widthFactor: 0.8,
              heightFactor: 1.0,
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: SingleChildScrollView(child: widget.child),
                  ),
              ),
          ),
        ),
      ),
    );
  }
}