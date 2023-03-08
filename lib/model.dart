import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:app_jar/plant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart'; // /!\ unsupported by web app

//trigger a snackbar even if not inside scaffold
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

class AppModel extends ChangeNotifier {
  List<Plant> plantList = [];
  String? errMsg;

  void notify() {
    notifyListeners();
  }

  Future<String> get _documentsDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    //log('documents directory : ${directory.path}');
    return directory.path;
  }

  Stream<List<int>> finalFileContent = const Stream.empty();

  //fonction de récupération du fichier
  void pickFile() async {
    log('--starting to pick file...');
    late SnackBar snackBar = SnackBar(
      content: Row(children: [
        Text(
          errMsg ?? '',
          style: TextStyle(color: Colors.red.shade900),
        ),
        Expanded(child: Container()),
        TextButton(
          style: ButtonStyle(
              overlayColor:
                  MaterialStatePropertyAll<Color>(Colors.red.shade200)),
          child: Text('Télécharger un fichier',
              style: TextStyle(color: Colors.red.shade900)),
          onPressed: () {
            pickFile();
          },
        )
      ]),
      showCloseIcon: true,
      closeIconColor: Colors.red.shade900,
      backgroundColor: Colors.red.shade100,
    );
    String documentsDirectory = await _documentsDirectory;
    final String sourcePath;
    // opens storage to pick files and the picked file or files
    // are assigned into filePicked and if no file is chosen filePicked is null.
    final filePicked =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    // check if no file is picked
    if (filePicked == null) {
      errMsg = 'Aucun fichier choisi';
      log(errMsg ?? '');
      snackbarKey.currentState?.showSnackBar(snackBar);
    } else {
      sourcePath = filePicked.files.first.path!;

      //check path
      if (sourcePath == '') {
        errMsg = 'Pas de chemin d\'accès au fichier';
        log(errMsg ?? '');
        snackbarKey.currentState?.showSnackBar(snackBar);
      } else {
        //check extention
        final extention = p.extension(sourcePath);
        if (extention != '.csv') {
          errMsg =
              'Seuls les fichier CSV sont acceptés';
          log(errMsg ?? '');
          snackbarKey.currentState?.showSnackBar(snackBar);
        } else {
          //identifier le fichier source
          var sourceFile = File(sourcePath);

          //identifier le fichier final
          String finalPath = p.join(
              documentsDirectory.toString(),/*  'app_jar',  */'caracteristiques.csv');
          log('finalPath : $finalPath');

          //copier fichier source à la place du fichier final
          await sourceFile.copy(finalPath);

          log('--finish to pick file');
          populatePlantList();
        }
      }
    }
  }

  Future populatePlantList() async {
    late SnackBar snackBar = SnackBar(
      content: Row(children: [
        Text(
          errMsg ?? '',
          style: TextStyle(color: Colors.red.shade900),
        ),
        Expanded(child: Container()),
        TextButton(
          style: ButtonStyle(
              overlayColor:
                  MaterialStatePropertyAll<Color>(Colors.red.shade200)),
          child: Text('Télécharger un fichier',
              style: TextStyle(color: Colors.red.shade900)),
          onPressed: () {
            pickFile();
          },
        )
      ]),
      showCloseIcon: true,
      closeIconColor: Colors.red.shade900,
      backgroundColor: Colors.red.shade100,
    );
    String documentsDirectory = await _documentsDirectory;
    String finalPath = p.join(
        documentsDirectory.toString(), 'caracteristiques.csv');
    late var finalFile = File(finalPath);
    plantList = [];

    log('--starting to populate plantlist');
    finalFileContent = finalFile.openRead();

    //mettre les éléments du fichier dans une liste
    List<List<dynamic>> fieldsDyn = await finalFileContent
        .transform(utf8.decoder)
        .transform(const CsvToListConverter(fieldDelimiter: ';'))
        .toList();
    if (fieldsDyn.isEmpty) {
      errMsg = 'Le fichier est vide';
      log(errMsg ?? '');
      snackbarKey.currentState?.showSnackBar(snackBar);
    } else {
      //log(fieldsDyn[1][0]);

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
        log('--filing plant list...');
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
      notify();
      log('--Plant list ok !');
      snackbarKey.currentState
          ?.showSnackBar(const SnackBar(content: Text('Liste téléchargée !')));
    }
  }
}
