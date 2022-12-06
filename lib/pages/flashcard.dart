import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard/models/flashcard.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/folder.dart';
import '../models/search.dart';
import '../models/filter.dart';
import '../utils/flashcardUtils/rounded_flashcard.dart';

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({Key? key}) : super(key: key);

  @override
  State<FlashcardPage> createState() => _FlashcardPage();
}

class _FlashcardPage extends State<FlashcardPage> {

  @override
  Widget build(BuildContext context) {
    final folder = ModalRoute.of(context)!.settings.arguments as Folder;

    return Scaffold(
      appBar: AppBar(
        title: const Text("목록"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/option', arguments: folder.id);
            },
            icon: const Icon(
              Icons.play_circle,
              color: Colors.amberAccent,
            ),
          ),
        ],
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SearchModel()),
          ChangeNotifierProvider(create: (context) => FilterModel()),
        ],
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<FilterModel>(
                        builder: (context, filter, child){
                          return const FilterWidget();
                        },
                      ),
                      Consumer<SearchModel>(
                        builder: (context, search, child){

                          return const SearchWidget();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Consumer<SearchModel>(
                    builder: (context, search, child){
                      return Consumer<FilterModel>(
                        builder: (context, filter, child){
                          return GridFlashcard(id: folder.id);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/addFlashcard', arguments: folder);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// filter Widget.
class FilterWidget extends StatefulWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final List<String> filterType = ["최신순", "오래된순"];

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        const Icon(Icons.filter_alt_outlined),
        SingleChildScrollView(
          child: DropdownButton(
            alignment: Alignment.center,
            value: Provider.of<FilterModel>(context, listen: false).filterVal,
            items: filterType.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),

            onChanged: (String? newValue) {
              setState(() {
                Provider.of<FilterModel>(context, listen: false).setFilterVal(newValue);
              });
            },
          ),
        ),
      ],
    );
  }
}

// Search Widget
class SearchWidget extends StatefulWidget {

  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return SizedBox(
      width: 200,
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onSubmitted: (String value){
          Provider.of<SearchModel>(context, listen: false).setSearchVal(value);
        },
      ),
    );
  }
}


// make grid flashcard Widget.
class GridFlashcard extends StatefulWidget {
  const GridFlashcard({Key? key, required this.id}) : super(key: key);

  final String id;
  @override
  State<GridFlashcard> createState() => _GridFlashcardState();
}

class _GridFlashcardState extends State<GridFlashcard> {
  @override
  Widget build(BuildContext context) {
    final filterBool = Provider.of<FilterModel>(context, listen: false).filterVal == '최신순' ? true : false;
    final searchVal = Provider.of<SearchModel>(context, listen: false).searchVal;
    final database = FirebaseFirestore.instance.collection('flashcards').doc(widget.id).collection('info');
    late Stream<QuerySnapshot> flashcards = searchVal != "" ? database.where('front', isGreaterThanOrEqualTo: searchVal).snapshots() : database.orderBy('udate', descending: filterBool).snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: flashcards,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 8.0 / 10.0,
          ),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index){
            final Flashcard flashcard = Flashcard(snapshot.data!.docs[index]['front'], snapshot.data!.docs[index]['back']);

            return FlipCard(
              front: RoundedFlashcard(
                card: flashcard,
                child: Text(
                  flashcard.front,
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
              ),
              back: RoundedFlashcard(
                card: flashcard,
                child: Text(
                  flashcard.back,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        );
      }
    );
  }
}
