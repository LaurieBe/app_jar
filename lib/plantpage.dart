import 'package:app_jar/plant.dart';
import 'package:flutter/material.dart';

class MyPlantPage extends StatelessWidget {
  const MyPlantPage({required this.plantList, required this.index, super.key});
  final List<Plant> plantList;
  final int index;
  
  @override
  Widget build(BuildContext context) {

    String sizeAsText;
    if (plantList[index].size == null) {sizeAsText = '';} 
    else {sizeAsText = '${plantList[index].size} m';}
    String scientificName = plantList[index].scientificName ?? '-';
    String type = plantList[index].type ?? '';
    String name = plantList[index].name;

    return Card(
      //margin: const EdgeInsets.all(50.0),
      child: Column(
        children : [
          Card (
            color: Theme.of(context).colorScheme.secondaryContainer,
            elevation: 0,
            margin: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(bottom: 25.0),
                  leading: IconButton(
                    onPressed: (){Navigator.pop(context);}, 
                    icon: const Icon(Icons.close),
                    alignment: Alignment.topCenter,
                  ),
                  title:Text(name,style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),),
                  subtitle: Text(scientificName,style: const TextStyle(fontStyle: FontStyle.italic),),
                ),//Text(type,),
              ],
            ),
          ),
          ListTile(
            subtitle: Text(sizeAsText),
            title: Text(type),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [  
                  Text('Zone'),
                  Text('Rusticité'),
                  Text('Exposition'),
                  Text('Sol'),
                  Text('Besoins en eau'),
                  Text('pH'),
                ]
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plantList[index].area ?? ''),
                  Text(plantList[index].hardiness ?? ''),
                  Text(plantList[index].exposure ?? ''),
                  Text(plantList[index].soil ?? '') ,
                  Text(plantList[index].watering ?? ''),
                  Text(plantList[index].ph ?? ''),
                ]
              ),
            ],
          ),
/*           ListTile(
            title : Text(plantList[index].hardiness ?? ''),
            leading: const Text('Rusticité'),
          ), */
        ]      
    ),)
    ;
  }
}