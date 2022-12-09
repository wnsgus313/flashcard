import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flashcard/models/folder.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';


import '../models/more.dart';

// 현재 user ID
final String? uid = FirebaseAuth.instance.currentUser?.uid;

List<CameraDescription> cameras = [];

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
          onPressed: () {
            Future<void> signOut() async {
              try {
                await FirebaseAuth.instance.signOut();
              } catch (e) {
                log(e.toString());
              }
            }

            signOut();

            Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
          },
          icon: const Icon(Icons.exit_to_app_outlined),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
            icon: const Icon(Icons.settings),
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
                topLeft: Radius.circular(20.0),
              ),
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
    final database = FirebaseFirestore.instance
        .collection('folders')
        .doc(uid)
        .collection('info');

    final Stream<QuerySnapshot> folders = database.snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: folders,
      builder: (BuildContext context, snapshot) {
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
                trailing: PopupMenuButton<More>(
                    onSelected: (More item) async {
                      if (item == More.edit) {
                        final TextEditingController folderName =
                            TextEditingController();

                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Center(
                              child: SingleChildScrollView(
                                child: AlertDialog(
                                  content: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20,),
                                      const Text(
                                        '폴더명',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20,),
                                      TextField(
                                        controller: folderName,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    Center(
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 130,),
                                          TextButton(
                                            onPressed: () {
                                              database.doc(folder.id).update({
                                                'name': folderName.text,
                                                'udate': FieldValue.serverTimestamp(),
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('수정'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('취소'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      else if (item == More.delete) {
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Center(
                              child: SingleChildScrollView(
                                child: AlertDialog(
                                  content: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: const [
                                      SizedBox(height: 20,),
                                      Text(
                                        '정말로 삭제하시겠습니까?',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    Center(
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 130,),
                                          TextButton(
                                            onPressed: () {
                                              database.doc(folder.id).delete();

                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('네'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('아니오'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }

                      setState(() {
                      });
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<More>>[
                          const PopupMenuItem<More>(
                            value: More.edit,
                            child: Text('편집'),
                          ),
                          const PopupMenuItem<More>(
                            value: More.delete,
                            child: Text('삭제'),
                          ),
                        ],
                ),
                onTap: () {
                  Folder folderM = Folder(id: folder.id);
                  log(folder.id);
                  Navigator.of(context)
                      .pushNamed('/flashcard', arguments: folderM);
                },
              );
            });
      },
    );
  }
}

// Floating button 누르면 할 수 있는 목록 아래에 생성하는 widget.
Widget optionBottomSheet(BuildContext context) {
  final folders = FirebaseFirestore.instance.collection('folders').doc(uid).collection('info');
  final flashcards = FirebaseFirestore.instance.collection('flashcards');

  // bottom modal 선택 후 폴더명 작성 alert.
  displayFolderNameInputDialog() {
    TextEditingController folderNameController = TextEditingController();
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Center(
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
                  folders.add({
                  'name': folderName,
                  'cdate': FieldValue.serverTimestamp(),
                  'udate': FieldValue.serverTimestamp(),                  });
                },
                child: const Text('추가'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // excel 파일만 읽는 함수
  Future<File?> openExcelFile() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx']   //excel 파일만 받도록 처리
    );
    if(pickedFile != null) {
      File file = File(pickedFile.files.single.path.toString());
      log(pickedFile.files.single.path.toString());
      return file;
    } else{
      log('no selected excel file');
    }
    return null;
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
            onPressed: () async {
              File? file = await openExcelFile();

              if(file != null){
                final folderName = file.path.split('/').last.split('.').first;

                await folders.add({
                  'name': folderName,
                  'cdate': FieldValue.serverTimestamp(),
                  'udate': FieldValue.serverTimestamp(),
                }).then((folder){
                  Uint8List bytes = file.readAsBytesSync();
                  Excel excel = Excel.decodeBytes(bytes);
                  for (var table in excel.tables.keys) {
                    for (var row in excel.tables[table]!.rows) {
                      flashcards.doc(folder.id).collection('info').add({
                        'front': row[0]?.value,
                        'back': row[1]?.value,
                        'cdate': FieldValue.serverTimestamp(),
                        'udate': FieldValue.serverTimestamp(),
                      });
                    }
                  }
                });
              }

              Navigator.of(context).pop();
            },
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
