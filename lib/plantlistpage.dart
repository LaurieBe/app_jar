import 'dart:developer';
import 'package:animations/animations.dart';
import 'package:app_jar/plant.dart';
import 'package:app_jar/plantpage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io'; // /!\ unsupported by web app
import 'package:csv/csv.dart';

class MyPlantListPage extends StatefulWidget {
  const MyPlantListPage ({super.key, required this.plantList});
  final List<Plant> plantList;  
  @override
  State<MyPlantListPage> createState() => _MyPlantListState();
}

class _MyPlantListState extends State<MyPlantListPage> {
  final List<Plant> plantList = [];
  
  void _pickFile() async {  
    // opens storage to pick files and the picked file or files
    // are assigned into filePicked and if no file is chosen filePicked is null.
    final filePicked = await FilePicker.platform.pickFiles(allowMultiple: false);
    // if no file is picked
    if (filePicked == null) {return log('no file chosen');} else {
      final path = filePicked.files.first.path;
      log('path : $path');
      if (path == null) {
        return log('no path given');
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
      log('Plant list ok ! first row : ');
      log(plantList[0].name);}
    }
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plantes'),),
      body: MyPlantList(plantList: plantList),
      floatingActionButton: DownloadFAB(onPressed: _pickFile)
    );
  }
}



class DownloadFAB extends StatelessWidget {
  const DownloadFAB ({super.key, required this.onPressed});
  final VoidCallback onPressed;
  
  @override
  Widget build(BuildContext context) {
     return FloatingActionButton(
        onPressed: onPressed,
        child: const Icon(Icons.file_upload,semanticLabel: 'Pick a file',),
      );
  }
}


class MyPlantList extends StatelessWidget {
  const MyPlantList({required this.plantList, super.key});
  final List<Plant> plantList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: plantList.length,
      itemBuilder: (context, index) {
        String sizeAsText;
        if (plantList[index].size == null) {sizeAsText = '';} 
        else {sizeAsText = '${plantList[index].size} m';}
        return  _OpenContainerWrapper(
            plantList: plantList, 
            index: index, 
            closedChild: ListTile(
              title: Text(plantList[index].name),
              subtitle: Text(plantList[index].scientificName ?? ''),
              trailing: Text(sizeAsText),
            )
          )
        ;
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(height: 1,),
    );
  }
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({required this.plantList, required this.index,required this.closedChild});
  final List<Plant> plantList;
  final int index;
  final Widget closedChild;

  @override
  Widget build(BuildContext context) {
   final theme = Theme.of(context);
   return OpenContainer(
     openBuilder: (context, closedContainer) {
       return MyPlantPage (plantList: plantList, index:index);
     },
     openColor: theme.cardColor,
     closedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0)),),
     closedElevation: 0,
     closedColor: theme.cardColor,
     closedBuilder: (context, openContainer) {
       return InkWell(
         onTap: () {openContainer();},
         child: closedChild,
       );
     },
   );
  }
}