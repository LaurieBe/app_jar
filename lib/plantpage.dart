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
    // Material is a conceptual piece of paper on which the UI appears.
    return Scaffold(
      appBar: AppBar(
        title: Text(plantList[index].name),

      ),
      body: Column(
        children : [
          Card(
            margin: const EdgeInsets.all(10.0),
            child: ListTile(
              subtitle: Text(plantList[index].scientificName ?? '') ,
              title:Text(plantList[index].type ?? ''),
              trailing: Text(sizeAsText),
            ),
          ),
          
          ListTile(
            title : Text(plantList[index].hardiness ?? ''),
            subtitle : Text(plantList[index].area ?? ''),
            leading : Text(plantList[index].watering ?? ''),
            trailing: Text(plantList[index].ph ?? ''),
          ),
          ListTile(
            title:Text(plantList[index].exposure ?? ''),
            subtitle:Text(plantList[index].soil ?? '') ,
          )
        ]
        ),
      
    );
  }
}