import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:app_jar/plant.dart';
import 'dart:developer';

class DatabaseHelper {
  //Crée une instance unique de DatabaseHelper au démarrage, stockée dans _instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  //Accès à la base de données, stockée dans _database
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Chemin de la base de données
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'plantes.db');

    // Vérifier si la base existe, sinon la copier depuis les assets
    final exists = await databaseExists(path);
    if (!exists) {
      log('Base de données non trouvée, copie depuis assets...');
      try {
        await Directory(dirname(path)).create(recursive: true);
        // Copier depuis assets (assure-toi que plantes.db est dans pubspec.yaml)
        final data = await File('assets/plantes.db').readAsBytes();
        await File(path).writeAsBytes(data);
      } catch (e) {
        log('Erreur copie base : $e');
      }
    }

    return await openDatabase(path, readOnly: true);
  }

  /// Charger toutes les plantes depuis la base SQLite
  Future<List<Plant>> loadPlantsFromDB() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('plantes');

      List<Plant> plants = [];
      for (var map in maps) {
        plants.add(Plant(
          name: map['nom_complet'] ?? '',
          scientificName: map['nom_latin'],
          size: _parseDouble(map['hauteur']),
          exposure: map['exposition'],
          soil: map['type_sol'],
          ph: null, // À adapter selon tes colonnes
          watering: map['arrosage'],
          hardiness: map['rusticite'],
          type: map['type_plante'],
          area: null, // À adapter
          color: map['couleur_fleur'],
          flowerBegin: null, // À adapter
          flowerEnd: null, // À adapter
          fruitBegin: null, // À adapter
          fruitEnd: null, // À adapter
          leavesBegin: null, // À adapter
          leavesEnd: null, // À adapter
          leavesDescription: map['feuillage'],
          persistence: null, // À adapter
          wish: null, // À adapter
          comment: map['description'],
        ));
      }
      log('${plants.length} plantes chargées depuis SQLite');
      return plants;
    } catch (e) {
      log('Erreur lecture SQLite : $e');
      return [];
    }
  }

  /// Helper pour parser les doubles depuis la base
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
