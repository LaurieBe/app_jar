import 'package:animations/animations.dart';
import 'package:app_jar/plant.dart';
import 'package:app_jar/plantpage.dart';
import 'package:flutter/material.dart';
// /!\ unsupported by web app

class PlantListPage extends StatelessWidget {
  const PlantListPage({super.key, required this.plantList});
  final List<Plant> plantList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantes'),
      ),
      body: MyPlantList(plantList: plantList),
    );
  }
}

class MyPlantList extends StatelessWidget {
  const MyPlantList({required this.plantList, super.key});
  final List<Plant> plantList;

  @override
  Widget build(BuildContext context) {
    List<Plant> filteredPlantList = plantList.where((Plant element) {
      return element.name.toLowerCase().contains('ab');
    }).toList();

    return ListView.separated(
      itemCount: filteredPlantList.length,
      itemBuilder: (context, index) {
        String sizeAsText;
        filteredPlantList[index].size == null
            ? sizeAsText = ''
            : sizeAsText = '${filteredPlantList[index].size} m';
        return _OpenContainerWrapper(
            plantList: filteredPlantList,
            index: index,
            closedChild: ListTile(
              title: Text(filteredPlantList[index].name),
              subtitle: Text(filteredPlantList[index].scientificName ?? ''),
              trailing: Text(sizeAsText),
            ));
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 1,
      ),
    );
  }
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper(
      {required this.plantList,
      required this.index,
      required this.closedChild});
  final List<Plant> plantList;
  final int index;
  final Widget closedChild;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OpenContainer(
      openBuilder: (context, closedContainer) {
        return MyPlantPage(plantList: plantList, index: index);
      },
      openColor: theme.cardColor,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      closedElevation: 0,
      closedColor: theme.cardColor,
      closedBuilder: (context, openContainer) {
        return InkWell(
          onTap: () {
            openContainer();
          },
          child: closedChild,
        );
      },
    );
  }
}
