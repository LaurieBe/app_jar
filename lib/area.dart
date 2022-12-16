//------------------------Areas Page------------------------

import 'package:app_jar/plant.dart';
import 'package:flutter/material.dart';

class MyAreaPage extends StatelessWidget {
  const MyAreaPage({required this.plantList, super.key});
  final List<Plant> plantList;
  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece of paper on which the UI appears.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zones'),
      ),
      body: Container(
        child: const Text('liste des zones'),
      ),
    );
  }
}
