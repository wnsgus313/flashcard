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

    return Scaffold(
      appBar: AppBar(
        title: const Text('암기'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      body: SelectOptions(id: docId),
    );
  }
}


// 옵션 선택 위젯.
class SelectOptions extends StatefulWidget {
  const SelectOptions({Key? key, required this.id}) : super(key: key);

  final String id;
  
  @override
  State<SelectOptions> createState() => _SelectOptionsState();
}

class _SelectOptionsState extends State<SelectOptions> {
  String problemOrder = "랜덤";
  String flashcardType = "문제/답";

  @override
  Widget build(BuildContext context) {
    final problemOrderList = ["랜덤", "최신순", "오래된순"];
    final flashcardTypeList = ["문제/답", "4지선다"];

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



