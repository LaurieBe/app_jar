import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path/path.dart' as p;
import 'package:app_jar/plant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart'; // /!\ unsupported by web app

class AppModel extends ChangeNotifier {
  List<Plant> plantList = [];

  void notify() {
    notifyListeners();
  }

  Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}



  //fonction de récupération du fichier
  void pickFile() async {
    var documentsDirectory = await _localPath;
    log('starting to pick file...');
    // opens storage to pick files and the picked file or files
    // are assigned into filePicked and if no file is chosen filePicked is null.
    final filePicked =
        await FilePicker.platform.pickFiles(allowMultiple: false);
    // if no file is picked

    if (filePicked == null) {
      return log('no file chosen, abort');
    } else {
      final sourcePath = filePicked.files.first.path;
      //var sourceFile = File(sourcePath);
      log('source path : $sourcePath');

      if (sourcePath == null) {
        return log('no path given, abort');
      } else {
        //identifier le fichier source et ouvrir
        log('reading file in $sourcePath');
        final input = File(sourcePath).openRead();

        //identifier le fichier final
        log('documents directory : $documentsDirectory');
        String finalPath =
            p.join(documentsDirectory, 'app_jar', 'caracteristiques.csv');
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
        ScaffoldMessenger.of(context).showSnackBar(content: Text('Liste téléchargée !')); */

        log('finish to pick file');
      }
    }
  }
}
