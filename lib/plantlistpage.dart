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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.file_upload,
          semanticLabel: 'Pick a file',
        ),
      ),
    );
  }
}

class MyPlantList extends StatelessWidget {
  const MyPlantList({required this.plantList, super.key});
  final List<Plant> plantList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: plantList.length,
      itemBuilder: (context, index) {
        String sizeAsText;
        if (plantList[index].size == null) {sizeAsText = '';} 
        else {sizeAsText = '${plantList[index].size} m';}
        return  _OpenContainerWrapper(
            plantList: plantList, 
            index: index, 
            closedChild: ListTile(
              title: Text(plantList[index].name),
              subtitle: Text(plantList[index].scientificName ?? ''),
              trailing: Text(sizeAsText),
            )
          )
        ;
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(height: 1,),
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
         onTap: () {openContainer();},
         child: closedChild,
       );
     },
   );
  }
}