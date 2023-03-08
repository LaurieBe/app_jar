import 'dart:math';

import 'package:app_jar/homepage.dart';
import 'package:app_jar/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

Future<void> main() async {
  var appDirectory = Directory.current.path;
  runApp(ChangeNotifierProvider(
      create: (context) => AppModel(),
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: const ColorScheme(
                brightness: Brightness.light,
                primary: Color(0xFF476800),
                onPrimary: Color(0xFFFFFFFF),
                primaryContainer: Color(0xFFC3F275),
                onPrimaryContainer: Color(0xFF121F00),
                secondary: Color(0xFF596248),
                onSecondary: Color(0xFFFFFFFF),
                secondaryContainer: Color(0xFFDDE6C6),
                onSecondaryContainer: Color(0xFF171E0A),
                tertiary: Color(0xFF396661),
                onTertiary: Color(0xFFFFFFFF),
                tertiaryContainer: Color(0xFFBCECE5),
                onTertiaryContainer: Color(0xFF00201D),
                error: Color(0xFFBA1A1A),
                errorContainer: Color(0xFFFFDAD6),
                onError: Color(0xFFFFFFFF),
                onErrorContainer: Color(0xFF410002),
                background: Color(0xFFFEFCF4),
                onBackground: Color(0xFF1B1C18),
                surface: Color(0xFFFEFCF4),
                onSurface: Color(0xFF1B1C18),
                surfaceVariant: Color(0xFFE2E4D4),
                onSurfaceVariant: Color(0xFF45483D),
                outline: Color(0xFF75786C),
                onInverseSurface: Color(0xFFF2F1E9),
                inverseSurface: Color(0xFF30312C),
                inversePrimary: Color(0xFFA8D55C),
                shadow: Color(0xFF000000),
                surfaceTint: Color(0xFF476800),
              )),
          title: 'Home', // used by the OS task switcher
          home: HomePage(appDirectory: appDirectory),
        );
      }));
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key, required this.name});
  final dynamic name;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      scrolledUnderElevation: 2,
      shadowColor: Theme.of(context).shadowColor,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.close),
      ),
      pinned: true,
      expandedHeight: 150.0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          name,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

/*
--------------------------------------------------------------------------------------------------
----------------------------------------------------------tests-----------------------------------
--------------------------------------------------------------------------------------------------
*/


/* -------------------- EXAMPLE COUNTER -------------------------------

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Reading and Writing Files',
      home: FlutterDemo(storage: CounterStorage()),
    ),
  );
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class FlutterDemo extends StatefulWidget {
  const FlutterDemo({super.key, required this.storage});

  final CounterStorage storage;

  @override
  State<FlutterDemo> createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _incrementCounter() {
    setState(() {
      _counter++;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading and Writing Files'),
      ),
      body: Center(
        child: Text(
          'Button tapped $_counter time${_counter == 1 ? '' : 's'}.',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
} */