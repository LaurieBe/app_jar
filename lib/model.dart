import 'package:app_jar/plant.dart';
import 'package:flutter/foundation.dart';
// /!\ unsupported by web app

class AppModel extends ChangeNotifier {
  List<Plant> plantList = [];

  void notify() {
    notifyListeners();
  }

}
