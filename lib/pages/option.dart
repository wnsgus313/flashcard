import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OptionPage extends StatefulWidget {
  const OptionPage({Key? key}) : super(key: key);

  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  @override
  Widget build(BuildContext context) {
    final docId = ModalRoute.of(context)!.settings.arguments as String;
    User userInfo = FirebaseAuth.instance.currentUser!;

    Future getSetting() async {
      final database = FirebaseFirestore.instance.collection('settings').doc(userInfo.uid);
      var settings = await database.get();
      if(!settings.exists){
        await database.set({
          'order': "랜덤",
          'type': "문제/답",
          'uid': userInfo.uid,
        });
        settings = await database.get();
      }
      return settings;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('암기'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getSetting(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
    
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: Text('Loading...'),
              );

            default:
              final order = snapshot.data['order'] ?? '랜덤';
              final type = snapshot.data['type'] ?? '문제/답';
              return SelectOptions(id: docId, order: order, type: type);
          }
        },
      ),
    );
  }
}


// 옵션 선택 위젯.
class SelectOptions extends StatefulWidget {
  const SelectOptions({Key? key, required this.id, required this.order, required this.type}) : super(key: key);

  final String id;
  final String order;
  final String type;
  
  @override
  State<SelectOptions> createState() => _SelectOptionsState();
}

class _SelectOptionsState extends State<SelectOptions> {
  String problemOrder = "랜덤";
  String flashcardType = "문제/답";
  bool initialize = true;

  @override
  Widget build(BuildContext context) {
    final problemOrderList = ["랜덤", "최신순", "오래된순"];
    final flashcardTypeList = ["문제/답", "4지선다"];
    if (initialize){
      problemOrder = widget.order;
      flashcardType = widget.type;
      initialize = false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 100,),
        Container(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: 250,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(),
                right: BorderSide(),
                left: BorderSide(),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('문제 나열 순서'),
                SingleChildScrollView(
                  child: DropdownButton(
                    alignment: Alignment.center,
                    value: problemOrder,
                    items: problemOrderList.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),

                    onChanged: (String? newValue) {
                      setState(() {
                        problemOrder = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: 250,
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('플래시카드 종류'),
                SingleChildScrollView(
                  child: DropdownButton(
                    alignment: Alignment.center,
                    value: flashcardType,
                    items: flashcardTypeList.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),

                    onChanged: (String? newValue) {
                      setState(() {
                        flashcardType = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(left: 200),
          child: TextButton(
            onPressed: (){

              Navigator.of(context).pushNamed('/memorization', arguments: [widget.id, problemOrder, flashcardType]);
            },
            child: const Text('시작'),
          ),
        ),
      ],
    );
  }
}



