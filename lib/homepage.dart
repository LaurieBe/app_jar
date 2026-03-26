import 'dart:convert';
import 'dart:developer';
import 'dart:io'; // /!\ unsupported by web app
import 'package:app_jar/area.dart';
import 'package:app_jar/model.dart';
import 'package:app_jar/plant.dart';
import 'package:app_jar/plantlistpage.dart';
import 'package:app_jar/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final filePicked = null;
  final fieldsDyn = null;

  //récupérer la liste de plantes à partir de la base SQLite

  @override
  Widget build(BuildContext context) {
    log('Build screen');

    return Consumer<AppModel>(builder: (context, model, child) {
      //fonction de chargement depuis SQLite
      void loadFromDatabase() async {
        log('Chargement depuis SQLite...');
        try {
          final plants = await DatabaseHelper().loadPlantsFromDB();
          if (plants.isNotEmpty) {
            model.plantList = plants;
            model.notify();
            log('${plants.length} plantes chargées');
            const snackBar = SnackBar(
              content: Text('Plantes chargées depuis la base de données !'),
            );
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            log('Aucune plante trouvée en base');
          }
        } catch (e) {
          log('Erreur chargement SQLite : $e');
        }
      }

      //Ancienne fonction de récupération du fichier CSV (optionnel, pour compatibilité)
      // Fonction désactivée - file_picker supprimé pour compatibilité Android
      /*
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
                color: line[9],
                flowerBegin: line[10],
                flowerEnd: line[11],
                fruitEnd: line[13],
                fruitBegin: line[12],
                leavesEnd: line[15],
                leavesBegin: line[14],
                wish: line[16],
                comment: line[17],
                persistence: line[19],
                leavesDescription: line[18],
              ));
            }
            model.notify();
            log('Plant list ok !');
            const snackBar = SnackBar(
              content: Text('Liste téléchargée !'),
            );
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      }
      */

      //vérifier si la liste de plante est présente
      if (model.plantList.isNotEmpty) {
        log('Plant list ok ! first row : ');
        log(model.plantList[0].name);
        log(model.plantList[0].hardiness ?? 'no hardiness');
      } else {
        log('Chargement des plantes depuis la base de données');
        loadFromDatabase();
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('Accueil'),
          actions: <Widget>[
            TextButton.icon(
              onPressed: () {
                loadFromDatabase();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Recharger'),
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
//                    textScaler: 1.5,
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
                                  plantList: model.plantList, index: 1,
                                )));
                  },
                  label: const Text(
                    'ZONES',
//                    textScaleFactor: 1.5,
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
