//import 'dart:convert';
//import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:csv/csv.dart';

/* Future<List<List<dynamic>>> processCsv() async {
      //récupère le contenu du fichier CSV et le met dans une liste
    final input = File('C:\\LBE_Flutter\\app_JAR\\app_jar\\assets\\caracteristiques.csv').openRead();
    final fields = await input.transform(utf8.decoder).transform(const CsvToListConverter(fieldDelimiter: ';')).toList();
    return const fields;
} */


Future<void> main() async {   
    runApp(
    const MaterialApp(
      title: 'Plants', // used by the OS task switcher
      home: SafeArea(
        child: MyScaffold(),
      ),
    ),
  );
  
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({required this.title, super.key});

  // Fields in a Widget subclass are always marked "final".
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0, // in logical pixels
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(color: Colors.blue[500]),
      // Row is a horizontal, linear layout.
      child: Row(
        children: [
          const IconButton(
            icon: Icon(
                Icons.local_florist,
                color: Colors.white ,
                ),
            tooltip: 'plantes',
            onPressed: null, // null disables the button
          ),
          // Expanded expands its child
          // to fill the available space.
          Expanded(
            child: title,
          ),
          const IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

/* class MyList extends StatelessWidget async {
  final input = File('C:\\LBE_Flutter\\app_JAR\\app_jar\\assets\\caracteristiques.csv').openRead();
  final fields = await input.transform(utf8.decoder).transform(const CsvToListConverter(fieldDelimiter: ';')).toList();

  MyList({super.key, required fields});

  @override
  Widget build(BuildContext context) {
    const title = 'Long List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        body: ListView.builder(
          itemCount: fields.length,
          prototypeItem: ListTile(
            title: Text(fields.first),
          ),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(fields[index]),
            );
          },
        ),
      ),
    );
  }
} */

class MyScaffold extends StatelessWidget {
  const MyScaffold({super.key});
  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece
    // of paper on which the UI appears.
    return Material(
      // Column is a vertical, linear layout.
      child: Column(
        children: [
          MyAppBar(
            title: Text(
              'Plantes',
              style: Theme.of(context) //
                  .primaryTextTheme
                  .headline6,
            ),
          ),
          //MyList(            fields: fields),
/*           Expanded(
            child: ListView.builder(
              itemCount: fields.length,
              prototypeItem: ListTile(
                title: Text(fields.fisrt),
              ),
              itemBuilder: (context, index) {
                return ListTile (
                  title: Text (fields[index]),
                );
              },
            ),
          ), */
          Expanded(
            child : Row(
              children: const [
                Expanded (
                  child: Text(
                      'vide',
                      textAlign: TextAlign.center,                        
                      ),
                ),
                Expanded (
                  child: Text(
                      'liste de plantes vide',
                      textAlign: TextAlign.center,                        
                      ),
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}

