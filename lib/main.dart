import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';


Future<void> main() async {   
    //récupérer la liste de plantes à partir du fichier CSV
    final input = File('C:\\LBE_Flutter\\app_JAR\\app_jar\\assets\\caracteristiques.csv').openRead();
    final fields = await input.transform(utf8.decoder).transform(const CsvToListConverter(fieldDelimiter: ';')).toList();
    //stdout.writeln(fields);
    runApp(
    MaterialApp(
      title: 'Plants', // used by the OS task switcher
      home: SafeArea(
        child: MyScaffold(
          plantlist: fields,
        ),
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

class MyBody extends StatelessWidget {
  const MyBody({required this.plantlist, super.key});
  final List<List<dynamic>> plantlist;
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child : ListView.builder(
        itemCount: plantlist.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(plantlist[index][0]),
          );
        },
      ),
    );
  }
}

class MyScaffold extends StatelessWidget {
  const MyScaffold({required this.plantlist, super.key});
  final List<List<dynamic>> plantlist;
  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece of paper on which the UI appears.
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

          MyBody(
            plantlist: plantlist
          )

        ]
      ),
    );
  }
}

