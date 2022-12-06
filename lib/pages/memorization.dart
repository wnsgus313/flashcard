import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/memorization.dart';
import '../utils/button.dart';
import '../utils/page_creater.dart';

class MemorizationPage extends StatefulWidget {
  const MemorizationPage({Key? key}) : super(key: key);

  @override
  State<MemorizationPage> createState() => _MemorizationPageState();
}

class _MemorizationPageState extends State<MemorizationPage> {
  @override
  Widget build(BuildContext context) {
    final docIdAndOrderAndType = ModalRoute.of(context)!.settings.arguments as List<String>;

    // memo 초기 설정.
    Memorization initializeMemo = Memorization();
    initializeMemo.setOrder(docIdAndOrderAndType[1]);
    initializeMemo.setType(docIdAndOrderAndType[2]);
    // 최초만 셔플.
    if(docIdAndOrderAndType[1] == '랜덤'){
      initializeMemo.setRandomTrue();
    }
    print(initializeMemo.type);


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
      body: ChangeNotifierProvider(
        create: (context) => Memorization(),
        child: Consumer<Memorization>(
          builder: (context, memo, child){
            memo = initializeMemo;
            return ShowProblem(id: docIdAndOrderAndType[0], memo: memo);
          },
        ),
      ),
    );
  }
}

// 문제를 보여주는 widget.
class ShowProblem extends StatefulWidget {
  const ShowProblem({Key? key, required this.id, required this.memo}) : super(key: key);
  final String id;
  final Memorization memo;

  @override
  State<ShowProblem> createState() => _ShowProblemState();
}

class _ShowProblemState extends State<ShowProblem> {
  TextEditingController frontTextController = TextEditingController();
  TextEditingController backTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return widget.memo.type == '문제/답' ? SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30,),
          SizedBox(
            height: 380,
            child: FutureBuilder(
              future: widget.memo.getAllDocs(widget.id),
              builder: (BuildContext context, AsyncSnapshot snapshot){
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
                    final flashcards = snapshot.data;
                    frontTextController.text = flashcards[widget.memo.idx]['front'];
                    backTextController.text = "";
                    print(widget.memo.idx);

                    return ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 9, horizontal: 18),
                          child: PageCreator.makeCircularReadOnlyTextField(
                            context: context,
                            controller: frontTextController,
                            placeholder: '',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 9, horizontal: 18),
                          child: PageCreator.makeCircularReadOnlyBackTextField(
                            context: context,
                            controller: backTextController,
                            placeholder: '정답 확인',
                            text: flashcards[widget.memo.idx]['back'],
                          ),
                        ),
                      ],
                    );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    widget.memo.setIdx((widget.memo.idx - 1) % widget.memo.count);
                    Provider.of<Memorization>(context, listen: false).setIdx((widget.memo.idx - 1) % widget.memo.count);

                  },
                    child: const Text('이전'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    widget.memo.setIdx((widget.memo.idx + 1) % widget.memo.count);
                    Provider.of<Memorization>(context, listen: false).setIdx((widget.memo.idx - 1) % widget.memo.count);

                  },
                  child: const Text('다음'),
                ),
              ],
            ),
          ),
        ],
      ),
    )
    :
    SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30,),
          SizedBox(
            height: 380,
            child: FutureBuilder(
              future: widget.memo.getAllDocs(widget.id),
              builder: (BuildContext context, AsyncSnapshot snapshot){
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
                    final flashcards = snapshot.data;

                    frontTextController.text = flashcards[widget.memo.idx]['front'];
                    backTextController.text = flashcards[widget.memo.idx]['back'];
                    print(widget.memo.idx);
                    List<String> problemList = widget.memo.getProblemList(widget.memo.idx);


                    return ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 9, horizontal: 18),
                          child: PageCreator.makeCircularReadOnlyTextField(
                            context: context,
                            controller: frontTextController,
                            placeholder: '',
                          ),
                        ),
                        SelectProblem(answer: backTextController.text, problemList: problemList, memo: widget.memo,),
                      ],
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SelectProblem extends StatefulWidget {
  const SelectProblem({Key? key, required this.answer, required this.problemList, required this.memo}) : super(key: key);

  final String answer;
  final List<String> problemList;
  final Memorization memo;
  @override
  State<SelectProblem> createState() => _SelectProblemState();
}

class _SelectProblemState extends State<SelectProblem> {
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Choose4Button(answer: widget.answer, problem: widget.problemList[0], memo: widget.memo),
                const SizedBox(width: 30,),
                Choose4Button(answer: widget.answer, problem: widget.problemList[1], memo: widget.memo),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Choose4Button(answer: widget.answer, problem: widget.problemList[2], memo: widget.memo),
                const SizedBox(width: 30,),
                Choose4Button(answer: widget.answer, problem: widget.problemList[3], memo: widget.memo),
              ],
            ),
          ],
        ),
    );
  }
}

