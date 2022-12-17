import 'package:flutter/material.dart';

class Plant {
  const Plant({required this.name, this.scientificName, this.type, this.size, this.exposure,this.hardiness,this.ph,this.soil,this.watering,this.area});
  final String name;
  final String? scientificName;
  final String? type;
  final double? size;
  final String? exposure;
  final String? soil;
  final String? ph;
  final String? watering;
  final String? hardiness;
  final String? area;

}

//------------------------Plant page------------------------

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