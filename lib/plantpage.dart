import 'package:app_jar/plant.dart';
import 'package:flutter/material.dart';

class MyPlantPage extends StatelessWidget {
  const MyPlantPage({required this.plantList, required this.index, super.key});
  final List<Plant> plantList;
  final int index;
  
  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece of paper on which the UI appears.
    return Scaffold(
      appBar: AppBar(
        title: Text(plantList[index].name),
      ),
      body: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(plantList[index].scientificName ?? ''),
              subtitle: Text(plantList[index].type ?? ''),
              trailing: Text(plantList[index].hardiness ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}