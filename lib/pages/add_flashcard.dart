import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/folder.dart';
import '../utils/page_creater.dart';


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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 18),
            child: PageCreator.makeCircularTextField(context: context, controller: frontTextController, placeholder: '문제'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 18),
            child: PageCreator.makeCircularTextField(context: context, controller: backTextController, placeholder: '답'),
          ),
        ],
      ),
    );
  }
}

