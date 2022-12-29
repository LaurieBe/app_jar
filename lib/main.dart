import 'dart:convert';
import 'dart:io'; // /!\ unsupported by web app
import 'package:app_jar/area.dart';
import 'package:app_jar/plant.dart';
import 'package:app_jar/plantlistpage.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';



Future<void> main() async {

  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          secondary: Colors.teal,
          tertiary: Colors.cyan
          )
        ),
      title: 'Home', // used by the OS task switcher
      home: PickAFilePage(),
    ),
  );
} 

class PickAFilePage extends StatelessWidget {
  PickAFilePage({super.key});
  final List<Plant> plantList = [];
  final filePicked = null;
  final fieldsDyn =null;
  
  //récupérer la liste de plantes à partir du fichier CSV
  void _pickFile() async {  
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    final filePicked = await FilePicker.platform.pickFiles(allowMultiple: false);
    // if no file is picked
    if (filePicked == null) {return;} else {
      final path = filePicked.files.first.path;
      if (path == null) {
        return;
      } else {
        final input = File(path).openRead();
        List<List<dynamic>> fieldsDyn = await input.transform(utf8.decoder).transform(const CsvToListConverter(fieldDelimiter: ';')).toList();
        //définir les colonnes correspondant à chacun des champs de plant et en faire une liste
        for (List<dynamic> line in fieldsDyn) {
          //préparation champ size
          num? size = line[20] is num ? line[20] : null;
          //préparation champ hardiness
          String? hardiness;
            if (line[7] is num) {hardiness = line[7].toString();} 
            else {hardiness = line[7];}
          // remplissage de la liste de plantes
          plantList.add(Plant(
            name: line[0], 
            size: size?.toDouble(), 
            scientificName: line[1],
            exposure: line[3],
            soil: line[4],
            ph: line[5],
            watering: line[6],
            hardiness: hardiness,
            type: line[8],
            area: line[38],
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accueil'),),
      floatingActionButton: FloatingActionButton(
        backgroundColor:Colors.green,
        foregroundColor: Colors.white,
        onPressed: () {_pickFile() ;},
        child: const Icon(
          Icons.file_upload,
          semanticLabel: 'Pick a file',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //PLANTES
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.fromLTRB(40, 40, 40, 20),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor:Colors.green,foregroundColor: Colors.white,),
                icon: const Icon(Icons.local_florist),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPlantListPage(plantList: plantList))
                  );
                },
                label: const Text('PLANTES',textScaleFactor: 1.5,),
              ),
            ),
          ),
          //ZONES
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.fromLTRB(40, 20, 40, 40),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.map),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => MyAreaPage(plantList: plantList,)));
                },
                label: const Text('ZONES',textScaleFactor: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



/*

----------------------------------------------------------tests-------------------------

*/


/* -------------------- EXAMPLE COUNTER -------------------------------

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Reading and Writing Files',
      home: FlutterDemo(storage: CounterStorage()),
    ),
  );
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class FlutterDemo extends StatefulWidget {
  const FlutterDemo({super.key, required this.storage});

  final CounterStorage storage;

  @override
  State<FlutterDemo> createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _incrementCounter() {
    setState(() {
      _counter++;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading and Writing Files'),
      ),
      body: Center(
        child: Text(
          'Button tapped $_counter time${_counter == 1 ? '' : 's'}.',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
} */