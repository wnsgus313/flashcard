import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard/models/flashcard.dart';
import 'package:flutter/material.dart';

import '../utils/mlkit_util/text_detector_view.dart';
import '../utils/text_field.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final flashcard = ModalRoute.of(context)!.settings.arguments as Flashcard;

    TextEditingController frontTextController = TextEditingController();
    TextEditingController backTextController = TextEditingController();
    frontTextController.text = flashcard.front;
    backTextController.text = flashcard.back;

    return Scaffold(
      appBar: AppBar(
        title: const Text("카드 수정"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              FirebaseFirestore.instance.collection('flashcards').doc(flashcard.folderId).collection('info').doc(flashcard.id).update({
                'front': frontTextController.text,
                'back': backTextController.text,
                'udate': FieldValue.serverTimestamp(),
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('저장되었습니다!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: ListView(
        children: [
          TextRecognizerView(textController: frontTextController),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 18),
            child: CircularTextField.makeCircularTextField(context: context, controller: frontTextController, placeholder: '문제'),
          ),
          const Divider(height: 20, thickness: 2,),
          TextRecognizerView(textController: backTextController),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 18),
            child: CircularTextField.makeCircularTextField(context: context, controller: backTextController, placeholder: '답'),
          ),
        ],
      ),
    );
  }
}
