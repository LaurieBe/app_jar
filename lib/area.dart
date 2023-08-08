//------------------------Areas Page------------------------

import 'package:app_jar/plant.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class WritingStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/draft.csv');
  }

  Future readDraft() async {
    final file = await _localFile;
    final contents = await file.readAsString();
    return contents;
  }

  Future writeDraft(String content) async {
    final file = await _localFile;
    return file.writeAsString(content);
  }
}

class MyAreaPage extends StatefulWidget {
  const MyAreaPage(
      {required this.plantList,
      super.key,
      required this.index,
      required this.storage});
  final List<Plant> plantList;
  final int index;
  final WritingStorage storage;

  @override
  State<MyAreaPage> createState() => _MyAreaPageState();
}

class _MyAreaPageState extends State<MyAreaPage> {
  final String contents = 'empty';

  void _addToFile(content) {
    widget.storage.writeDraft(content);
    widget.storage.readDraft();
  }

  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece of paper on which the UI appears.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zones'),
      ),
      body: Center(
        child: Text(contents),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addToFile("tata");
        },
        tooltip: 'écrire',
        child: const Icon(Icons.add),
      ),
    );
  }
}
