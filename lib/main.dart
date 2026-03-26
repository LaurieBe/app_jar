import 'package:app_jar/homepage.dart';
import 'package:app_jar/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  // Initialiser sqflite pour Windows/Desktop
  databaseFactory = databaseFactoryFfi;
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
                surface: Color(0xFFFEFCF4),
                onSurface: Color(0xFF1B1C18),
                surfaceContainerHighest: Color(0xFFE2E4D4),
                onSurfaceVariant: Color(0xFF45483D),
                outline: Color(0xFF75786C),
                onInverseSurface: Color(0xFFF2F1E9),
                inverseSurface: Color(0xFF30312C),
                inversePrimary: Color(0xFFA8D55C),
                shadow: Color(0xFF000000),
                surfaceTint: Color(0xFF476800),
              )),
          title: 'Home', // used by the OS task switcher
          home: const HomePage(),
        );
      }));
}  