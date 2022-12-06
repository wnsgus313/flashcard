import 'dart:developer';

import 'package:flashcard/models/folder.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 현재 user ID
final String? uid = FirebaseAuth.instance.currentUser?.uid;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("암기"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: optionBottomSheet,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0)),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: const TopicListWidget(),
    );
  }
}

// 주제 목록을 보여주는 Widget
class TopicListWidget extends StatefulWidget {
  const TopicListWidget({Key? key}) : super(key: key);

  @override
  State<TopicListWidget> createState() => _TopicListWidgetState();
}

class _TopicListWidgetState extends State<TopicListWidget> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> folders = FirebaseFirestore.instance.collection('folders').doc(uid).collection('info').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: folders,
      builder: (BuildContext context, snapshot){
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            final folder = snapshot.data!.docs[index];

            return ListTile(
              leading: const Icon(Icons.folder),
              title: Text(folder['name']),
              onTap: (){
                Folder folderM = Folder(id: folder.id);
                log(folder.id);
                Navigator.of(context).pushNamed('/flashcard', arguments: folderM);
              },
            );
          }
        );

      },
    );
  }
}

// Floating button 누르면 할 수 있는 목록 아래에 생성하는 widget.
Widget optionBottomSheet(BuildContext context) {

  // bottom modal 선택 후 폴더명 작성 alert.
  displayFolderNameInputDialog() {
    TextEditingController folderNameController = TextEditingController();
    showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                title: const Text('폴더명'),
                content: TextFormField(
                  controller: folderNameController,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, '취소'),
                    child: const Text('취소'),
                  ),
                  TextButton(
                    onPressed: () {
                      final folderName = folderNameController.text;
                      Navigator.pop(context, '추가');
                      FirebaseFirestore.instance.collection('folders').doc(uid).collection('info').add({
                        'name': folderName,
                      });
                    },
                    child: const Text('추가'),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              displayFolderNameInputDialog();
              log('a');
            },
            icon: const Icon(Icons.create_new_folder),
            label: const Text('폴더 만들기'),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download),
            label: const Text('엑셀에서 가져오기'),
          ),
        ],
      ),
    ),
  );
}

Future<void> displayTextInputDialog(BuildContext context) async {
  final textFieldController = TextEditingController();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('폴더명 작성'),
          content: TextField(
            onChanged: (value) {},
            controller: textFieldController,
            decoration: const InputDecoration(hintText: "Text Field in Dialog"),
          ),
        );
      });
}
