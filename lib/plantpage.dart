//import 'dart:html';

// ignore_for_file: unused_local_variable

import 'package:app_jar/plant.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class MyPlantPage extends StatelessWidget {
  const MyPlantPage({required this.plantList, required this.index, super.key});
  final List<Plant> plantList;
  final int index;
  @override
  Widget build(BuildContext context) {
    String name = plantList[index].name;
    return CustomScrollView(slivers: <Widget>[
          MyAppBar(name:name),
          MyPlantCaracteristics(plantList: plantList, index: index),
        ]);
  }
}

class MyPlantCaracteristics extends StatelessWidget {
  const MyPlantCaracteristics({required this.plantList, required this.index, super.key});
  final List<Plant> plantList;
  final int index;

  @override
  Widget build(BuildContext context) {
    //preparation contenu
    String scientificName = plantList[index].scientificName ?? "";
    String type = plantList[index].type ?? "";
    String sizeAsText;
    if (plantList[index].size == null) {
      sizeAsText = "";
    } else {
      sizeAsText = '${plantList[index].size} m';
    }
    String exposure = plantList[index].exposure ?? "";
    String hardiness = plantList[index].hardiness ?? "";
    String ph = plantList[index].ph ?? "";
    String soil = plantList[index].soil ?? "";
    String watering = plantList[index].watering ?? "";
    String area = plantList[index].area ?? "";
    String color = plantList[index].color ?? "";
    String flowerBegin = plantList[index].flowerBegin ?? "";
    String flowerEnd = plantList[index].flowerEnd ?? "";
    String fruitEnd = plantList[index].fruitEnd ?? "";
    String fruitBegin = plantList[index].fruitBegin ?? "";
    String leavesEnd = plantList[index].leavesEnd ?? "";
    String leavesBegin = plantList[index].leavesBegin ?? "";
    String wish = plantList[index].wish ?? "";
    String comment = plantList[index].comment ?? "";
    String persistence = plantList[index].persistence ?? "";
    String leavesDescription = plantList[index].leavesDescription ?? "";
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
    return SliverList(
        delegate: SliverChildListDelegate(<Widget>[
      scientificName == ""
          ? const SizedBox(
              height: 0,
            )
          : ListTile(
              title: Text(
                scientificName,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
      const ListTile(
        title: Text('Description'),
      ),
      ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          type == ""
              ? const SizedBox(
                  height: 0,
                )
              : CaracteristicsTile(
                  caracName: 'Type',
                  caracValue: type,
                  plantList: plantList,
                  index: index,
                  caracIcon: Icons.category,
                ),
          sizeAsText == ""
              ? const SizedBox(
                  height: 0,
                )
              : CaracteristicsTile(
                  caracName: 'Taille',
                  caracValue: sizeAsText,
                  plantList: plantList,
                  index: index,
                  caracIcon: Icons.height,
                ),
          area == ""
              ? const SizedBox(
                  height: 0,
                )
              : CaracteristicsTile(
                  caracName: 'Zone',
                  caracValue: area,
                  plantList: plantList,
                  index: index,
                  caracIcon: Icons.place,
                ),
          color == ""
              ? const SizedBox(
                  height: 0,
                )
              : CaracteristicsTile(
                  caracName: 'Couleur',
                  caracValue: color,
                  plantList: plantList,
                  index: index,
                  caracIcon: Icons.category,
                ),
          leavesDescription == ""
              ? const SizedBox(
                  height: 0,
                )
              : CaracteristicsTile(
                  caracName: 'Feuillage',
                  caracValue: leavesDescription,
                  plantList: plantList,
                  index: index,
                  caracIcon: Icons.category,
                ),
          persistence == ""
              ? const SizedBox(
                  height: 0,
                )
              : CaracteristicsTile(
                  caracName: 'Persistance',
                  caracValue: persistence,
                  plantList: plantList,
                  index: index,
                  caracIcon: Icons.category,
                ),
          wish == ""
              ? const SizedBox(
                  height: 0,
                )
              : CaracteristicsTile(
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
      ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          hardiness == ""
              ? const SizedBox(
                  height: 0,
                )
              : CaracteristicsTile(
                  caracName: 'Rusticité',
                  caracValue: hardiness,
                  plantList: plantList,
                  index: index,
                  caracIcon: Icons.thermostat,
                ),
          exposure == ""
              ? const SizedBox(
                  height: 0,
                )
              : CaracteristicsTile(
                  caracName: 'Exposition',
                  caracValue: exposure,
                  plantList: plantList,
                  index: index,
                  caracIcon: Icons.wb_sunny,
                ),
          soil == ""
              ? const SizedBox(
                  height: 0,
                )
              : CaracteristicsTile(
                  caracName: 'Sol',
                  caracValue: soil,
                  plantList: plantList,
                  index: index,
                  caracIcon: Icons.public),
          watering == ""
              ? const SizedBox(
                  height: 0,
                )
              : CaracteristicsTile(
                  caracName: 'Besoins en eau',
                  caracValue: watering,
                  plantList: plantList,
                  index: index,
                  caracIcon: Icons.water_drop),
          ph == ""
              ? const SizedBox(
                  height: 0,
                )
              : CaracteristicsTile(
                  caracName: 'pH',
                  caracValue: ph,
                  plantList: plantList,
                  index: index,
                  caracIcon: Icons.moving),
        ],
      ),
      comment == ""
          ? const SizedBox(
              height: 0,
            )
          : ListTile(
              title: const Text('Commentaire'),
              subtitle: Text(comment),
            ),
    ]));
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
        child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 80),
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
            )));
  }
}
