import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final settings = FirebaseFirestore.instance.collection('settings');

  User userInfo = FirebaseAuth.instance.currentUser!;
  String order = '랜덤';
  String type = "문제/답";
  String problemOrder = '랜덤';
  String flashcardType = '문제/답';
  bool initialize = true;

  @override
  Widget build(BuildContext context) {
    final problemOrderList = ["랜덤", "최신순", "오래된순"];
    final flashcardTypeList = ["문제/답", "4지선다"];

    Future getSettingVal() async {
      var setting = await settings.doc(userInfo.uid).get();
      if (!setting.exists){
        settings.doc(userInfo.uid).set({
          'order': order,
          'type': type,
          'uid': userInfo.uid,
        });
        setting = await settings.doc(userInfo.uid).get();
      }
      return setting;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('환경설정'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await settings.doc(userInfo.uid).set({
                'order': order,
                'type': type,
                'uid': userInfo.uid,
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('저장되었습니다!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getSettingVal(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasError){
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return const Center(
                child: Text('Loading...'),
              );
            default:
              final data = snapshot.data;

              if(initialize){
                problemOrder = order = data['order'];
                flashcardType = type = data['type'];
                initialize = false;
              }

              return Column(
                children: [
                  const SizedBox(height: 40,),
                  const Text(
                    '기본값 설정',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 40,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                                      order = newValue;
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
                                      type = newValue;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
          }
        },

      ),
    );
  }
}
//
// class Profile extends StatefulWidget {
//   const Profile({Key? key}) : super(key: key);
//
//   @override
//   State<Profile> createState() => _ProfileState();
// }
//
// class _ProfileState extends State<Profile> {
//   User userInfo = FirebaseAuth.instance.currentUser!;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(
//           height: 20,
//         ),
//         Image.network(
//           userInfo.photoURL!,
//           scale: 0.4,
//         ),
//         const SizedBox(height: 60),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(60.0, 0, 60, 0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 userInfo.uid,
//                 style: const TextStyle(color: Colors.black),
//               ),
//               const Divider(
//                 thickness: 1,
//                 height: 40,
//                 color: Colors.black,
//               ),
//               Text(
//                 userInfo.email!,
//                 style: const TextStyle(color: Colors.black),
//               ),
//               const SizedBox(height: 60),
//             ],
//           ),
//         ),
//       ],
//     );
//     ;
//   }
// }
