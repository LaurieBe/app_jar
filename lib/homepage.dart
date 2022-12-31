import 'dart:convert';
import 'dart:io'; // /!\ unsupported by web app
import 'package:app_jar/area.dart';
import 'package:app_jar/plant.dart';
import 'package:app_jar/plantlistpage.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
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
                icon: const Icon(Icons.local_florist),
                onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => MyPlantListPage(plantList: plantList)));},
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
                onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => MyAreaPage(plantList: plantList,)));},
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