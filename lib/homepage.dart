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
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.documentsDirectory});
  final String documentsDirectory;
  //final filePicked = null;
  //final fieldsDyn = null;
  //final bool listOk = false;

  //récupérer la liste de plantes à partir du fichier CSV

  @override
  Widget build(BuildContext context) {
    log('Build screen');
    

/*     var initialDirectoryUri =
        Platform.script.pathSegments; //Platform.resolvedExecutable;
    log('initialDirectory : $initialDirectoryUri');
    initialDirectoryUri = initialDirectoryUri.removeLast();
    String initialDirectoryPath =
        p.join(initialDirectoryUri, 'assets', 'caracteristiques.csv');
    //log(list.removeLast()); */

    return Consumer<AppModel>(builder: (context, model, child) {
      log('documents directory : $documentsDirectory');

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
          final sourcePath = filePicked.files.first.path;
          //var sourceFile = File(sourcePath);
          log('source path : $sourcePath');

          if (sourcePath == null) {
            return log('no path given');
          } else {
            //identifier le fichier source et ouvrir
            log('reading file in $sourcePath');
            final input = File(sourcePath).openRead();

            //identifier le fichier final
            log('documents directory : $documentsDirectory');
            String finalPath =
                p.join(documentsDirectory,'app_jar', 'caracteristiques.csv');
            log('final path : $finalPath');
            var finalFile = File(finalPath);
            String content = await finalFile.readAsString();
            log('initial file content : $content');

            //écrir le contenu dans le fichier final
            finalFile.writeAsStringSync('FILE ACCESSED', flush: true);

            content = finalFile.readAsStringSync();
            log('final file content : $content');

            //mettre les éléments du fichier dans une liste
            List<List<dynamic>> fieldsDyn = await input
                .transform(utf8.decoder)
                .transform(const CsvToListConverter(fieldDelimiter: ';'))
                .toList();
            log(fieldsDyn[1][0]);

            /* log("copying file from $sourcePath to $finalPath");
            File(sourcePath).copy(finalPath); */

            /* 

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
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(snackBar); */
          }
        }
      }

      const snackBar = SnackBar(
      content: Text('Liste téléchargée !'),
    );

    var snackbarKO = SnackBar(
        content: Row(children: [
          Text(
            'Il manque la liste de plantes',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          Expanded(child: Container()),
          TextButton(
            style: ButtonStyle(
                overlayColor: MaterialStatePropertyAll<Color>(
                    Theme.of(context).colorScheme.error.withOpacity(0.2))),
            child: Text('Télécharger la liste',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            onPressed: () {
              pickFile();
            },
          )
        ]),
        showCloseIcon: true,
        closeIconColor: Theme.of(context).colorScheme.error,
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      );

      return Scaffold(
        appBar: AppBar(
          title: const Text('Accueil'),
          actions: <Widget>[
            TextButton.icon(
              onPressed: () {
                pickFile();
              },
              icon: const Icon(Icons.file_upload),
              label: const Text('Nouveau Fichier'),
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
                  onHover: null,
                  onPressed: () {
                    if (model.plantList.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PlantListPage(plantList: model.plantList)));
                    } else {
                      log('plantList empty');
                      ScaffoldMessenger.of(context).showSnackBar(snackbarKO);
                    }
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
                                  index: 1,
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
