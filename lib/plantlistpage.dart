import 'package:animations/animations.dart';
import 'package:app_jar/plant.dart';
import 'package:app_jar/plantpage.dart';
import 'package:flutter/material.dart'; // /!\ unsupported by web app

class PlantListPage extends StatelessWidget {
  PlantListPage({super.key, required this.plantList});
  final List<Plant> plantList;
  final name = const Text('Plantes').toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantes'),
        scrolledUnderElevation: 2,
        shadowColor: Theme.of(context).shadowColor,
      ),
      body: MyPlantList(plantList: plantList),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: const Text('showModalBottomSheet'),
          onPressed: () {
            showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SearchZone(
                      filteredPlantList: filteredPlantList,
                      plantList: plantList);
                });
          },
        ),
        Expanded(
          child: filteredPlantList.isNotEmpty
              ? PlantList(
                  filteredPlantList: filteredPlantList, plantList: plantList)
              : const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Pas de résultat',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
        ),
      ],
    );
  }
}

class SearchZone extends StatefulWidget {
  SearchZone(
      {super.key, required this.plantList, required this.filteredPlantList});
  final List<Plant> plantList;
  List<Plant> filteredPlantList = [];

  @override
  State<SearchZone> createState() => _SearchZoneState(plantList: plantList);
  // This function is called whenever the text field changes
}

class _SearchZoneState extends State<SearchZone> {
  _SearchZoneState({required this.plantList});
  final List<Plant> plantList;
  List<Plant> filteredPlantList = [];
  @override
  initState() {
    filteredPlantList = plantList;
    super.initState();
  }

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
    return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                    onChanged: (value) => _runFilter(value),
                    decoration: const InputDecoration(
                        labelText: 'Search', suffixIcon: Icon(Icons.search))),
              ),
              const Text('Modal BottomSheet'),
              ElevatedButton(
                child: const Text('Close BottomSheet'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ));
  }
}

class PlantList extends StatelessWidget {
  PlantList(
      {super.key, required this.plantList, required this.filteredPlantList});
  final List<Plant> plantList;
  final List<Plant> filteredPlantList;
  var scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        controller: scrollController,
        child: ListView.separated(
          controller: scrollController,
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
          separatorBuilder: (BuildContext context, int index) => Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
            indent: 5,
            endIndent: 5,
          ),
        ));
  }
}
