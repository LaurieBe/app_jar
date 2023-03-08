import 'package:animations/animations.dart';
import 'package:app_jar/plant.dart';
import 'package:app_jar/plantpage.dart';
import 'package:flutter/material.dart';

class PlantListPage extends StatefulWidget {
  const PlantListPage({required this.plantList, super.key});
  final List<Plant> plantList;
  @override
  State<PlantListPage> createState() => _PlantListPageState();
}

class _PlantListPageState extends State<PlantListPage> {
  late List<Plant> plantList = [];
  late List<Plant> filteredPlantList;
  bool wishlistPressed = false;
  bool hardinessPressed = false;
  final String name = 'Plantes';

  @override
  initState() {
    filteredPlantList = widget.plantList;
    plantList = widget.plantList;
    super.initState();
  }

  void _runSearch(String enteredKeyword) {
    List<Plant> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all items
      results = widget.plantList;
    } else {
      results = widget.plantList.where((Plant element) {
        return element.name
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase());
      }).toList();
    }
    // Refresh the UI
    setState(() {
      filteredPlantList = results;
      hardinessPressed = false;
      wishlistPressed = false;
    });
  }

  void _wishlistFilter() {
    List<Plant> results = [];
    wishlistPressed
        ? results = widget.plantList.where((Plant element) {
            return element.wish!.toLowerCase().contains('x'.toLowerCase());
          }).toList()
        : results = widget.plantList;

    // Refresh the UI
    setState(() {
      filteredPlantList = results;
      hardinessPressed = false;
    });
  }

  void _hardinessFilter() {
    List<Plant> results = [];
    List<Plant> listeFiltree = widget.plantList.where((Plant element) {
      return element.hardiness!.contains('!');
    }).toList();
    hardinessPressed ? results = listeFiltree : results = widget.plantList;
    // Refresh the UI
    setState(() {
      filteredPlantList = results;
      wishlistPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
          scrolledUnderElevation: 2,
        ),
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
              // Make the initial height of the SliverAppBar larger than normal.
              expandedHeight: 150,
              scrolledUnderElevation: 2,
              shadowColor: Theme.of(context).shadowColor,
              automaticallyImplyLeading: false,
              snap: true,
              pinned: false,
              floating: true,
              title: TextField(
                  onChanged: (value) => _runSearch(value),
                  decoration: const InputDecoration(hintText: 'Recherche')),
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Wrap(
                            spacing: 5,
                            children: [
                              FilterChip(
                                visualDensity: const VisualDensity(
                                    horizontal: -3, vertical: -3),
                                selected: wishlistPressed,
                                showCheckmark: true,
                                label: const Text('Wishlist'),
                                onSelected: (bool value) {
                                  setState(() {
                                    wishlistPressed = value;
                                  });
                                  _wishlistFilter();
                                },
                              ),
                              FilterChip(
                                visualDensity: const VisualDensity(
                                    horizontal: -3, vertical: -3),
                                selected: hardinessPressed,
                                showCheckmark: true,
                                label: const Text('Rusticité'),
                                onSelected: (bool value) {
                                  setState(() {
                                    hardinessPressed = value;
                                  });
                                  _hardinessFilter();
                                },
                              )
                            ],
                          ),
                          Text(
                              "${filteredPlantList.length.toString()} résultats"),
                        ])),
              )),
          filteredPlantList.isNotEmpty
              ? PlantList(filteredPlantList: filteredPlantList)
              : SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Pas de résultat',
                      style: TextStyle(fontSize: 24),
                    ),
                  )
                ])),
        ]));
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

class PlantList extends StatelessWidget {
  PlantList({super.key, required this.filteredPlantList});
  final List<Plant> filteredPlantList;
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return /* Scrollbar(
        controller: scrollController,
        child:  */
        SliverList(
            delegate: SliverChildBuilderDelegate(
      childCount: filteredPlantList.length,
      (context, index) {
        String sizeAsText;
        filteredPlantList[index].size == null
            ? sizeAsText = ''
            : sizeAsText = '${filteredPlantList[index].size} m';
        return _OpenContainerWrapper(
            plantList: filteredPlantList,
            index: index,
            closedChild: ListTile(
              title: Text(filteredPlantList[index].name),
              trailing: Text(sizeAsText),
            ));
      },
    ));
  }
}
