import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:app_jar/plant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart'; // /!\ unsupported by web app

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

  late SnackBar snackBar = SnackBar(content: Text(errMsg??'vide')); 
 

  //fonction de récupération du fichier
  void pickFile() async {
    log('starting to pick file...');
    //String errMsg = '';
       
    String documentsDirectory = await _documentsDirectory;
    
    // opens storage to pick files and the picked file or files
    // are assigned into filePicked and if no file is chosen filePicked is null.
    final filePicked = await FilePicker.platform
        .pickFiles(allowMultiple: false, allowedExtensions: ['csv']);
    
    // if no file is picked
    final String sourcePath;
    if (filePicked == null) {
      errMsg = 'Aucun fichier choisi';
      log(errMsg??'');
      snackbarKey.currentState?.showSnackBar(SnackBar(content: Text(errMsg??'vide'))); 
    } else {
      sourcePath = filePicked.files.first.path!;
      //log('source path : $sourcePath');
      //check path
      if (sourcePath == '') {
        errMsg = 'Pas de chemin d\'accès au fichier';
        log(errMsg??'');
        snackbarKey.currentState?.showSnackBar(snackBar);
      } else {
        //check extention
        final extention = p.extension(sourcePath);
        if (extention != '.csv') {
          errMsg = 'Mauvaise extention : $extention. Seuls les fichier CSV sont acceptés';
          log(errMsg??'');
          snackbarKey.currentState?.showSnackBar(SnackBar(content: Text(errMsg??'vide')));
        } else {
          //identifier le fichier source
          //log('reading file in $sourcePath');
          var sourceFile = File(sourcePath);

          //identifier le fichier final
          String finalPath = p.join(
              documentsDirectory.toString(), 'app_jar', 'caracteristiques.csv');
          //log('documents directory : $documentsDirectory');
          //log('final path : $finalPath');

          //copier fichier source à la place du fichier final
          sourceFile.copySync(finalPath);

          log('finish to pick file');
        }
      }
    }
    populatePlantList(); 
  }

  void populatePlantList() async {
    String documentsDirectory = await _documentsDirectory;
    String finalPath = p.join(
        documentsDirectory.toString(), 'app_jar', 'caracteristiques.csv');
    late var finalFile = File(finalPath);

    log('starting to populate plantlist');
    finalFileContent = finalFile.openRead();
    log('file openened');
/*     if (await finalFileContent.isEmpty) {
      log('final File Content empty');
    } else { */
    //mettre les éléments du fichier dans une liste
    List<List<dynamic>> fieldsDyn = await finalFileContent
        .transform(utf8.decoder)
        .transform(const CsvToListConverter(fieldDelimiter: ';'))
        .toList();
    if (fieldsDyn.isEmpty) {
      errMsg = 'Le fichier est vide';
      final SnackBar snackBar = SnackBar(content: Text("your snackbar message"));
snackbarKey.currentState?.showSnackBar(snackBar); 
    } else {
      log(fieldsDyn[1][0]);

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
      log('Plant list ok !');
    }
  }
}
