//import 'dart:html';

import 'package:app_jar/plant.dart';
import 'package:flutter/material.dart';

class MyPlantPage extends StatelessWidget {
  const MyPlantPage({required this.plantList, required this.index, super.key});
  final List<Plant> plantList;
  final int index;

  @override
  Widget build(BuildContext context) {
    //String scientificName = plantList[index].scientificName ?? '-';
    String name = plantList[index].name;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
          title: Text(name),
        ),
        body: Column(children: [
          /* //Heading
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
                title:,
                subtitle: Text(scientificName,style: const TextStyle(fontStyle: FontStyle.italic),),
              ),//Text(type,),
            ],
          ),
        ),  */
          //body
          Expanded(
            child: MyPlantCaracteristics(plantList: plantList, index: index),
          ),
        ]));
  }
}

class MyPlantCaracteristics extends StatelessWidget {
  const MyPlantCaracteristics(
      {required this.plantList, required this.index, super.key});
  final List<Plant> plantList;
  final int index;

  @override
  Widget build(BuildContext context) {
    String sizeAsText;
    if (plantList[index].size == null) {
      sizeAsText = '-';
    } else {
      sizeAsText = '${plantList[index].size} m';
    }
    String type = plantList[index].type ?? '-';
    String scientificName = plantList[index].scientificName ?? '-';
    int nbColumn;
    if (MediaQuery.of(context).size.width < 600) {
      nbColumn = 2;
    } else {
      if (MediaQuery.of(context).size.width < 1200) {
        nbColumn = 3;
      } else {
        nbColumn = 4;
      }
    }

    return ListView(children: <Widget>[
      ListTile(
        title: Text(
          scientificName,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      const ListTile(
        title: Text('Description'),
      ),
      GridView.count(
        shrinkWrap: true,
        crossAxisCount: nbColumn,
        childAspectRatio: 2,
        children: [
          CaracteristicsTile(
            caracName: 'Type',
            caracValue: type,
            plantList: plantList,
            index: index,
            caracIcon: Icons.category,
          ),
          CaracteristicsTile(
            caracName: 'Taille',
            caracValue: sizeAsText,
            plantList: plantList,
            index: index,
            caracIcon: Icons.height,
          ),
          CaracteristicsTile(
            caracName: 'Zone',
            caracValue: plantList[index].area ?? '-',
            plantList: plantList,
            index: index,
            caracIcon: Icons.place,
          ),
        ],
      ),
      const ListTile(
        title: Text('Besoins'),
      ),
      GridView.count(
        shrinkWrap: true,
        crossAxisCount: nbColumn,
        childAspectRatio: 2,
        children: [
          CaracteristicsTile(
            caracName: 'Rusticité',
            caracValue: plantList[index].hardiness ?? '-',
            plantList: plantList,
            index: index,
            caracIcon: Icons.thermostat,
          ),
          CaracteristicsTile(
            caracName: 'Exposition',
            caracValue: plantList[index].exposure ?? '-',
            plantList: plantList,
            index: index,
            caracIcon: Icons.wb_sunny,
          ),
          CaracteristicsTile(
              caracName: 'Sol',
              caracValue: plantList[index].soil ?? '-',
              plantList: plantList,
              index: index,
              caracIcon: Icons.public),
          CaracteristicsTile(
              caracName: 'Besoins en eau',
              caracValue: plantList[index].watering ?? '-',
              plantList: plantList,
              index: index,
              caracIcon: Icons.water_drop),
          CaracteristicsTile(
              caracName: 'pH',
              caracValue: plantList[index].ph ?? '-',
              plantList: plantList,
              index: index,
              caracIcon: Icons.moving),
        ],
      ),
    ]);
  }
}

class CaracteristicsTile extends StatelessWidget {
  const CaracteristicsTile(
      {required this.caracIcon,
      required this.caracValue,
      required this.caracName,
      required this.plantList,
      required this.index,
      super.key});
  final List<Plant> plantList;
  final int index;
  final String caracName;
  final String caracValue;
  final IconData caracIcon;

  @override
  Widget build(BuildContext context) {
    TextStyle? adaptedSize;
    if (MediaQuery.of(context).size.width > 600) {
      adaptedSize = Theme.of(context).textTheme.titleLarge;
    } else {
      adaptedSize = Theme.of(context).textTheme.titleSmall;
    }

    return Card(
        child: Row(
      children: [
        Expanded(child: Icon(caracIcon)),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                caracName,
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 0.7),
              ),
              Text(caracValue, style: adaptedSize)
            ],
          ),
        ),
      ],
    ));
  }
}
