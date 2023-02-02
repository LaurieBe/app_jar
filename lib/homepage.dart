import 'dart:convert';
import 'dart:developer';
import 'dart:io'; // /!\ unsupported by web app
import 'package:app_jar/area.dart';
import 'package:app_jar/model.dart';
import 'package:app_jar/plant.dart';
import 'package:app_jar/plantlistpage.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final filePicked = null;
  final fieldsDyn = null;

  //récupérer la liste de plantes à partir du fichier CSV

  @override
  Widget build(BuildContext context) {
    log('Build screen');

    return Consumer<AppModel>(builder: (context, model, child) {
      //fonction de récupération du fichier
      void pickFile() async {
        log('starting to pick file...');
        // opens storage to pick files and the picked file or files
        // are assigned into filePicked and if no file is chosen filePicked is null.
        final filePicked =
            await FilePicker.platform.pickFiles(allowMultiple: false);
        // if no file is picked
        if (filePicked == null) {
          return log('no file chosen');
        } else {
          final path = filePicked.files.first.path;
          log('path : $path');

          if (path == null) {
            return log('no path given');
          } else {
            log('opening file...');
            final input = File(path).openRead();
            List<List<dynamic>> fieldsDyn = await input
                .transform(utf8.decoder)
                .transform(const CsvToListConverter(fieldDelimiter: ';'))
                .toList();

            //définir les colonnes correspondant à chacun des champs de plant et en faire une liste
            for (List<dynamic> line in fieldsDyn) {
              //préparation du champ size
              num? size = line[20] is num ? line[20] : null;

              //préparation champ hardiness
              String? hardiness;
              if (line[7] is num) {
                hardiness = line[7].toString();
              } else {
                hardiness = line[7];
              }

              // remplissage de la liste de plantes
              log('filing plant list...');
              model.plantList.add(Plant(
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
            model.notify();
            log('Plant list ok !');
          }
        }
      }

      //vérifier si la liste de plante est présente
      if (model.plantList.isNotEmpty) {
        log('Plant list ok ! first row : ');
        log(model.plantList[0].name);
      } else {
        log('il faut charger la plantlist');
        pickFile();
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('Accueil'),
          actions : <Widget>[
            TextButton.icon(
              onPressed: () {
                pickFile();
                final snackBar = SnackBar(
                  content: const Text('Yay! A SnackBar!'),
                  /* action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {},
                  ), */
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: const Icon(Icons.file_upload),
              label: const Text('Pick a file'),
            ),
          ],
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
                        MaterialPageRoute(
                            builder: (context) =>
                                PlantListPage(plantList: model.plantList)));
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyAreaPage(
                                  plantList: model.plantList,
                                )));
                  },
                  label: const Text(
                    'ZONES',
                    textScaleFactor: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
