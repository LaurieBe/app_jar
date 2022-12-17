import 'package:animations/animations.dart';
import 'package:app_jar/plant.dart';
import 'package:app_jar/plantpage.dart';
import 'package:flutter/material.dart';

class MyPlantListPage extends StatelessWidget {
  const MyPlantListPage({required this.plantList, super.key});
  final List<Plant> plantList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plantes'),),
      body: MyPlantList(plantList: plantList),
    );
  }
}

class MyPlantList extends StatelessWidget {
  const MyPlantList({required this.plantList, super.key});
  final List<Plant> plantList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: plantList.length,
      itemBuilder: (context, index) {
        String trailingText;
        if (plantList[index].size == null) {trailingText = '';} 
        else {trailingText = '${plantList[index].size} m';}
        return Card(
          child : _OpenContainerWrapper(
            plantList: plantList, 
            index: index, 
            closedChild: ListTile(
              title: Text(plantList[index].name),
              subtitle: Text(plantList[index].scientificName ?? ''),
              trailing: Text(trailingText),
              // onTap: () {
              //   Navigator.push(context,MaterialPageRoute(
              //     builder: (context) => MyPlantPage(plantList: plantList, index:index)
              //   ));
              // },
            )
          )
        );
      },
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
         onTap: () {
           openContainer();
         },
         child: closedChild,
       );
     },
   );
  }
}