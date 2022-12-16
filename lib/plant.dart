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

//------------------------PlantList page------------------------

class MyPlantListPage extends StatelessWidget {
  const MyPlantListPage({required this.plantList, super.key});
  final List<Plant> plantList;
  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece of paper on which the UI appears.
    return Scaffold(
      appBar: AppBar(title: const Text('Plantes'),),
      body: Container(child: MyPlantList(plantList: plantList),),
      //drawer: MyDrawer(plantlist: plantlist),
/*    floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ), */
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
        if (plantList[index].size == null) {
          trailingText = '';
        } else {
          trailingText = '${plantList[index].size} m';
        }
        return ListTile(
          title: Text(plantList[index].name),
          subtitle: Text(plantList[index].scientificName ?? ''),
          trailing: Text(trailingText),
          onTap: () {
            Navigator.push(context,MaterialPageRoute(
              builder: (context) => MyPlantPage(plantList: plantList, index:index)));
          },
          //...plantlist.map((e) => MyPlantTile(plant:e)),
        );
      },
    );
  }
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