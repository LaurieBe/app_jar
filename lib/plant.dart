import 'package:flutter/material.dart';

class Plant {
  const Plant({required this.name, this.scientificName, this.type, this.size});
  final String name;
  final String? scientificName;
  final String? type;
  final double? size;
}

//------------------------Plants page------------------------

class MyPlantListPage extends StatelessWidget {
  const MyPlantListPage({required this.plantList, super.key});
  final List<Plant> plantList;
  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece of paper on which the UI appears.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantes'),
      ),
      body: Container(
        child: MyPlantList(plantList: plantList),
      ),
      //drawer: MyDrawer(plantlist: plantlist),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyPlantPage(
                          plantList: plantList,
                        )));
          },
          //...plantlist.map((e) => MyPlantTile(plant:e)),
        );
      },
    );
  }
}

class MyPlantPage extends StatelessWidget {
  const MyPlantPage({required this.plantList, super.key});
  final List<Plant> plantList;
  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece of paper on which the UI appears.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantes'),
      ),
      body: Container(
        child: MyPlantList(plantList: plantList),
      ),
      //drawer: MyDrawer(plantlist: plantlist),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}