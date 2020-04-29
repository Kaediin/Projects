import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Name generator',
      theme: ThemeData.dark(),
      home: RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords>{

  final suggestions = <WordPair>[];
  final Set<WordPair> saved = Set<WordPair>();
  final biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: pushSaved),
        ],
      ),
      body: buildsSuggestions(),
    );
  }

  void pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context){
          final Iterable<ListTile> tiles = saved.map(
              (WordPair pair){
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: biggerFont,
                  ),
                );
              }
          );
          final List<Widget> divided = ListTile
              .divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved suggestions'),
            ),
            body: ListView(children: divided),
          );
        }
      )
    );
  }

  Widget buildsSuggestions(){
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i){
        if (i.isOdd) return Divider();

        final index = i ~/ 2;
        if (index >= suggestions.length){
          suggestions.addAll(generateWordPairs().take(10));
        }
        return buildRow(suggestions[index]);
    },
    );
  }

  Widget buildRow(WordPair pair){
    final bool alreadySaved = saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: (){
        setState(() {
          if (alreadySaved){
            saved.remove(pair);
          } else {
            saved.add(pair);
          }
        });
      },
    );
  }
}

List<String> WordPairToString(Set<WordPair> pair){
  List<String> strings = List<String>();
  for (WordPair name in pair){
    strings.add(name.toString());
  }

  return strings;
}

class RandomWords extends StatefulWidget{

  @override
  RandomWordsState createState() => RandomWordsState();
}