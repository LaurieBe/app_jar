//import 'dart:html';
//import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:app_jar/plant.dart';
import 'package:app_jar/plantpage.dart';
import 'package:flutter/material.dart'; // /!\ unsupported by web app

class PlantListPage extends StatelessWidget {
  const PlantListPage({super.key, required this.plantList});
  final List<Plant> plantList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plantes'),
          scrolledUnderElevation: 2,
          shadowColor: Theme.of(context).shadowColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Recherche',
              onPressed: () {
              },
            ),
          ],
        ),
        body: 
          MyPlantList(plantList: plantList),
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
          onTap: () {openContainer();},
          child: closedChild,
        );
      },
    );
  }
}

class MyPlantList extends StatefulWidget {
  const MyPlantList({required this.plantList, super.key});
  final List<Plant> plantList;
  @override
  State<MyPlantList> createState() => _MyPlantListState(plantList: plantList);
}

class _MyPlantListState extends State<MyPlantList> {
  _MyPlantListState({required this.plantList});
  final List<Plant> plantList;
  List<Plant> filteredPlantList = [];
  @override
  initState() {
    filteredPlantList = plantList;
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Plant> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = plantList;
    } else {
      results = plantList.where((Plant element) {
        return element.name
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase());
      }).toList();
    }
    // Refresh the UI
    setState(() {
      filteredPlantList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
            onChanged: (value) => _runFilter(value),
            decoration: const InputDecoration(
                labelText: 'Search', suffixIcon: Icon(Icons.search))),
        Expanded(
          child: filteredPlantList.isNotEmpty
              ? ListView.separated(
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
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(height: 1,),
                )
              : const Text(
                  'No results found',
                  style: TextStyle(fontSize: 24),
                ),
        ),
      ],
    );
  }
}
