import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';

Future<void> main() async {   
  //récupérer la liste de plantes à partir du fichier CSV
    final input = File('C:\\LBE_Flutter\\app_JAR\\app_jar\\assets\\caracteristiques.csv').openRead();
    final fields = await input.transform(utf8.decoder).transform(const CsvToListConverter(fieldDelimiter: ';')).toList();
  //stdout.writeln(fields);
  runApp(
    MaterialApp(
      title: 'Plants', // used by the OS task switcher
      home: MyHomePage(plantlist: fields,),
    ),
  );
}

  class MyHomePage extends StatelessWidget {
    const MyHomePage({required this.plantlist, super.key});
    final List<List<dynamic>> plantlist;
    @override
    Widget build(BuildContext context) {
      // Material is a conceptual piece of paper on which the UI appears.
      return Scaffold(
        appBar: AppBar(title: const Text('Home'),),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(//PLANTES
              flex:1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(40, 40, 40, 20),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.local_florist),
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => MyPlantListPage(plantlist: plantlist,))
                      );
                  },
                  label: const Text('PLANTES',textScaleFactor: 1.5,),
                ),
              ),
            ),
            Expanded(//ZONES
              flex:1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(40, 20, 40, 40),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.map),
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => MyAreaPage(plantlist: plantlist,))
                      );
                  },
                  label: const Text('ZONES',textScaleFactor: 1.5,),
                ),
              ),
            ),
          ],
        ),
        //drawer: MyDrawer(plantlist: plantlist),
      );
    }
  }

 /*class MyDrawer extends StatelessWidget {
    const MyDrawer({required this.plantlist, super.key});
    final List<List<dynamic>> plantlist;
    @override
    Widget build(BuildContext context) {
      return Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.blue,),
                child: Text('Menu',style: Theme.of(context).textTheme.headline4,),
              ),
              ListTile(title: const Text('Home'),
                leading: const Icon(Icons.home),
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => MyHomePage(plantlist: plantlist,))
                  );
                },
              ),
              ListTile(title: const Text('Plantes'),
                leading: const Icon(Icons.local_florist),
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => MyPlantListPage(plantlist: plantlist,))
                    );
                  // Then close the drawer
                  //Navigator.pop(context);
                },
              ),
              ListTile(title: const Text('Zones'),
                leading: const Icon(Icons.map),
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => MyAreaPage(plantlist: plantlist,))
                    );
                  // Then close the drawer
                  //Navigator.pop(context);
                },
              ),
            ],
          ),
      );
    }
  }
  */

  /* class MyTable extends StatelessWidget {
    const MyTable({required this.plantlist, super.key});
    final List<List<dynamic>> plantlist;
    @override
    Widget build(BuildContext context) {
      return DataTable(
          columns: const <DataColumn>[
            DataColumn(label: Text('Nom'),),
            DataColumn(label: Text('Nom latin'),),
          ],
          rows: List<DataRow>.generate(
            plantlist.length,
            (int index) => DataRow(
              cells: <DataCell>[
                DataCell(Text(plantlist[index][0])),
                DataCell(Text(plantlist[index][2]))
              ],
            ),
          ),
      );
    }
  }
  */

  /* class MyAppBar extends StatelessWidget {
    const MyAppBar({required this.title, super.key});
    // Fields in a Widget subclass are always marked "final".
    final Widget title;

    @override
    Widget build(BuildContext context) {
      return Container(
        height: 56.0, // in logical pixels
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(color: Colors.blue[500]),
        // Row is a horizontal, linear layout.
        child: Row(
          children: [
            const IconButton(
              icon: Icon(
                  Icons.local_florist,
                  color: Colors.white ,
                  ),
              tooltip: 'plantes',
              onPressed: null, // null disables the button
            ),
            // Expanded expands its child
            // to fill the available space.
            Expanded(
              child: title,
            ),
            const IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Search',
              onPressed: null,
            ),
          ],
        ),
      );
    }
  }

  */


//------------------------Plants page------------------------

  class MyPlantListPage extends StatelessWidget {
    const MyPlantListPage({required this.plantlist, super.key});
    final List<List<dynamic>> plantlist;
    @override
    Widget build(BuildContext context) {
      // Material is a conceptual piece of paper on which the UI appears.
      return Scaffold(
        appBar: AppBar(title: const Text('Plantes'),),
        body : Container(child: MyPlantList(plantlist: plantlist),),
        //drawer: MyDrawer(plantlist: plantlist),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      );
    }
  }

  class MyPlantList extends StatelessWidget {
    const MyPlantList({required this.plantlist, super.key});
    final List<List<dynamic>> plantlist;
    
    @override
    Widget build(BuildContext context) {
      return ListView.builder(
          itemCount: plantlist.length,
          itemBuilder: (context, index) {
            String trailingText ;
            if (plantlist[index][20] == '' ) {
              trailingText = '';
            } else {
              trailingText = '${plantlist[index][20]} m';
              }
            return ListTile(
              title: Text(plantlist[index][0]),
              subtitle: Text(plantlist[index][1]),
              trailing:  Text(trailingText),
              onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => MyPlantPage(plantlist: plantlist,))
                      );
                  },
              //...plantlist.map((e) => MyPlantTile(plant:e)),
            );
          },
      );
    }
  }

  class MyPlantPage extends StatelessWidget {
  const MyPlantPage({required this.plantlist, super.key});
  final List<List<dynamic>> plantlist;
  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece of paper on which the UI appears.
    return Scaffold(
      appBar: AppBar(title: const Text('Plantes'),),
      body : Container(child: MyPlantList(plantlist: plantlist),),
      //drawer: MyDrawer(plantlist: plantlist),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

//------------------------Areas Page------------------------

  class MyAreaPage extends StatelessWidget {
    const MyAreaPage({required this.plantlist, super.key});
    final List<List<dynamic>> plantlist;
    @override
    Widget build(BuildContext context) {
      // Material is a conceptual piece of paper on which the UI appears.
      return Scaffold(
        appBar: AppBar(title: const Text('Zones'),),
        body : Container(
            child: const Text('liste des zones'),
        ),
        //drawer: MyDrawer(plantlist: plantlist),
      );
    }
  }