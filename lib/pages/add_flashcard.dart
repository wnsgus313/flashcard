
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/folder.dart';
import '../utils/mlkit_util/text_detector_view.dart';
import '../utils/text_field.dart';


class AddFlashcardPage extends StatefulWidget {
  const AddFlashcardPage({Key? key}) : super(key: key);

  @override
  State<AddFlashcardPage> createState() => _AddFlashcardPageState();
}

class _AddFlashcardPageState extends State<AddFlashcardPage> {
  @override
  Widget build(BuildContext context) {
    final folder = ModalRoute.of(context)!.settings.arguments as Folder;

    TextEditingController frontTextController = TextEditingController();
    TextEditingController backTextController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("카드 추가"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              FirebaseFirestore.instance.collection('flashcards').doc(folder.id).collection('info').add({
                'front': frontTextController.text,
                'back': backTextController.text,
                'cdate': FieldValue.serverTimestamp(),
                'udate': FieldValue.serverTimestamp(),
              });

              frontTextController.clear();
              backTextController.clear();
            },
            child: const Text('Done'),
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

