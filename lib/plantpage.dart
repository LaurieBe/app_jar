//import 'dart:html';

// ignore_for_file: unused_local_variable

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
        body: Column(
          children: [Expanded
              (child: MyPlantCaracteristics(plantList: plantList, index: index),)
          ]
        ) 
    );
  }
}

class MyPlantCaracteristics extends StatelessWidget {
  const MyPlantCaracteristics(
      {required this.plantList, required this.index, super.key});
  final List<Plant> plantList;
  final int index;

  @override
  Widget build(BuildContext context) {
    //preparation contenu
      String scientificName = plantList[index].scientificName ?? '-';
      String type = plantList[index].type ?? '-';
      String sizeAsText;
      if (plantList[index].size == null) {
        sizeAsText = '-';
      } else {
        sizeAsText = '${plantList[index].size} m';
      }
      String exposure = plantList[index].exposure ?? '-';
      String hardiness = plantList[index].hardiness ?? '-';
      String ph = plantList[index].ph ?? '-';
      String soil = plantList[index].soil ?? '-';
      String watering = plantList[index].watering ?? '-';
      String area = plantList[index].area ?? '-';
      String color = plantList[index].color ?? '-';
      String flowerBegin = plantList[index].flowerBegin ?? '-';
      String flowerEnd = plantList[index].flowerEnd ?? '-';
      String fruitEnd = plantList[index].fruitEnd ?? '-';
      String fruitBegin = plantList[index].fruitBegin ?? '-';
      String leavesEnd = plantList[index].leavesEnd ?? '-';
      String leavesBegin = plantList[index].leavesBegin ?? '-';
      String wish = plantList[index].wish ?? '-';
      String comment = plantList[index].comment ?? '-';
      String persistence = plantList[index].persistence ?? '-';
      String leavesDescription = plantList[index].leavesDescription ?? '-';
      int nbColumn;
      if (MediaQuery.of(context).size.width < 600) {
        nbColumn = 1;
      } else {
        if (MediaQuery.of(context).size.width < 1200) {
          nbColumn = 3;
        } else {
          nbColumn = 4;
        }
      }


    //contenu
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
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
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: nbColumn,
                  childAspectRatio: 4,
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
                      caracValue: area,
                      plantList: plantList,
                      index: index,
                      caracIcon: Icons.place,
                    ),
                    CaracteristicsTile(
                      caracName: 'Couleur',
                      caracValue: color,
                      plantList: plantList,
                      index: index,
                      caracIcon: Icons.category,
                    ),
                    CaracteristicsTile(
                      caracName: 'Feuillage',
                      caracValue: leavesDescription,
                      plantList: plantList,
                      index: index,
                      caracIcon: Icons.category,
                    ),
                    CaracteristicsTile(
                      caracName: 'Persistance',
                      caracValue: persistence,
                      plantList: plantList,
                      index: index,
                      caracIcon: Icons.category,
                    ),
                    CaracteristicsTile(
                      caracName: 'Wishlist',
                      caracValue: wish,
                      plantList: plantList,
                      index: index,
                      caracIcon: Icons.height,
                    ),
                  ],
                ),
                const ListTile(
                  title: Text('Besoins'),
                ),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: nbColumn,
                  childAspectRatio: 4,
                  children: [
                    CaracteristicsTile(
                      caracName: 'Rusticité',
                      caracValue: hardiness,
                      plantList: plantList,
                      index: index,
                      caracIcon: Icons.thermostat,
                    ),
                    CaracteristicsTile(
                      caracName: 'Exposition',
                      caracValue: exposure,
                      plantList: plantList,
                      index: index,
                      caracIcon: Icons.wb_sunny,
                    ),
                    CaracteristicsTile(
                        caracName: 'Sol',
                        caracValue: soil,
                        plantList: plantList,
                        index: index,
                        caracIcon: Icons.public),
                    CaracteristicsTile(
                        caracName: 'Besoins en eau',
                        caracValue: watering,
                        plantList: plantList,
                        index: index,
                        caracIcon: Icons.water_drop),
                    CaracteristicsTile(
                        caracName: 'pH',
                        caracValue: ph,
                        plantList: plantList,
                        index: index,
                        caracIcon: Icons.moving),
                  ],
                ),
                ListTile(
                  title: const Text('Commentaire'),
                  subtitle: Text(comment),
                ),
              ]
            )
          )
        )
      ]
    );
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
