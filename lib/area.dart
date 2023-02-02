//------------------------Areas Page------------------------

import 'package:app_jar/plant.dart';
import 'package:flutter/material.dart';

class MyAreaPage extends StatelessWidget {
  const MyAreaPage({required this.plantList, super.key, required this.index});
  final List<Plant> plantList;
    final int index;
  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece of paper on which the UI appears.
    return Scaffold(
      /* appBar: AppBar(
        title: const Text('Zones'),
      ), */
      body: CustomScrollView (slivers: <Widget>[
          const SliverAppBar(
            pinned: true,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Demo'),
            ),
          ),
          SliverGrid.count(
            childAspectRatio: 4,
            crossAxisCount: 1,
                  children: [
                    CaracteristicsTile(
                      caracName: 'Type',
                      caracValue: 'type',
                      plantList: plantList,
                      index: index,
                      caracIcon: Icons.category,
                    ),
                    CaracteristicsTile(
                      caracName: 'Taille',
                      caracValue: 'sizeAsText',
                      plantList: plantList,
                      index: index,
                      caracIcon: Icons.height,
                    ),
                    CaracteristicsTile(
                      caracName: 'Zone',
                      caracValue: 'area',
                      plantList: plantList,
                      index: index,
                      caracIcon: Icons.place,
                    ),
                    CaracteristicsTile(
                      caracName: 'Couleur',
                      caracValue: 'color',
                      plantList: plantList,
                      index: index,
                      caracIcon: Icons.category,
                    ),
                    CaracteristicsTile(
                      caracName: 'Feuillage',
                      caracValue: 'leavesDescription',
                      plantList: plantList,
                      index: index,
                      caracIcon: Icons.category,
                    ),
                    CaracteristicsTile(
                      caracName: 'Persistance',
                      caracValue: 'persistence',
                      plantList: plantList,
                      index: index,
                      caracIcon: Icons.category,
                    ),
                    CaracteristicsTile(
                      caracName: 'Wishlist',
                      caracValue: 'wish',
                      plantList: plantList,
                      index: index,
                      caracIcon: Icons.height,
                    ),
                    CaracteristicsTile(
                      caracName: 'Feuillage',
                      caracValue: 'leavesDescription',
                      plantList: plantList,
                      index: index,
                      caracIcon: Icons.category,
                    ),
                    CaracteristicsTile(
                      caracName: 'Persistance',
                      caracValue: 'persistence',
                      plantList: plantList,
                      index: index,
                      caracIcon: Icons.category,
                    ),
                    CaracteristicsTile(
                      caracName: 'Wishlist',
                      caracValue: 'wish',
                      plantList: plantList,
                      index: index,
                      caracIcon: Icons.height,
                    ),
                  ],              
          ),
        ],      
      ),
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
