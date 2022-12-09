import 'package:flashcard/models/memorization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 4지선다형 문제 button 위젯.
class Choose4Button extends StatefulWidget {
  const Choose4Button({
    Key? key,
    required this.answer,
    required this.problem,
    required this.memo,
  }) : super(key: key);

  final String answer;
  final String problem;
  final Memorization memo;

  @override
  State<Choose4Button> createState() => _Choose4ButtonState();
}

class _Choose4ButtonState extends State<Choose4Button> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 150.0,
      color: const Color(0xFFECEBEE),
      onPressed: () {
        if(widget.problem == widget.answer) {
          widget.memo.setIdx((widget.memo.idx + 1) % widget.memo.count);
          Provider.of<Memorization>(context, listen: false).setIdx((widget.memo.idx + 1) % widget.memo.count);
        }
      },
      child: SizedBox(
        width: 120,
        child: Text(
          widget.problem,
          softWrap: false,
          style: const TextStyle(fontSize: 20.0, color: Colors.black),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}
