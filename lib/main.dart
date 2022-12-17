import 'dart:convert';
import 'dart:io';
import 'package:app_jar/area.dart';
import 'package:app_jar/plant.dart';
import 'package:app_jar/plantlistpage.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';


Future<void> main() async {
  //récupérer la liste de plantes à partir du fichier CSV
  final input = File('C:\\LBE_Flutter\\app_JAR\\app_jar\\assets\\caracteristiques.csv').openRead();
  List<List<dynamic>> fieldsDyn = await input.transform(utf8.decoder).transform(const CsvToListConverter(fieldDelimiter: ';')).toList();

  //définir les colonnes correspondant à chacun des champs de plant et en faire une liste
  List<Plant> plantList = [];
  for (List<dynamic> line in fieldsDyn) {
    num? size = line[20] is num ? line[20] : null;
    String? hardiness;
    if (line[7] is num) {hardiness = line[7].toString();} 
    else {hardiness = line[7];}

    plantList.add(
      Plant(
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
      )
    );
  }

  runApp(
    MaterialApp(
      title: 'Plants', // used by the OS task switcher
      home: MyHomePage(
        plantList: plantList,
      ),
    ),
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({required this.plantList, super.key});
  final List<Plant> plantList;
  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece of paper on which the UI appears.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
                icon: const Icon(Icons.local_florist),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPlantListPage(plantList: plantList))
                  );
                },
                label: const Text(
                  'PLANTES',
                  textScaleFactor: 1.5,
                ),
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

