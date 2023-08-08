import 'dart:developer';
// /!\ unsupported by web app
import 'package:app_jar/area.dart';
import 'package:app_jar/model.dart';
import 'package:app_jar/plantlistpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    log('Build screen');

    return Consumer<AppModel>(builder: (context, model, child) {
      /*  var snackbarKO = SnackBar(
        content: Row(children: [
          Text(
            model.errMsg,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          Expanded(child: Container()),
          TextButton(
            style: ButtonStyle(
                overlayColor: MaterialStatePropertyAll<Color>(
                    Theme.of(context).colorScheme.error.withOpacity(0.2))),
            child: Text('Télécharger la liste',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            onPressed: () {
              model.pickFile();
            },
          )
        ]),
        showCloseIcon: true,
        closeIconColor: Theme.of(context).colorScheme.error,
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      );
      var snackbarOK = const SnackBar(content: Text('Liste téléchargée !')); */

      return Scaffold(
        appBar: AppBar(
          title: const Text('Accueil'),
          actions: <Widget>[
            TextButton.icon(
              onPressed: () {
                model.pickFile();
              },
              icon: const Icon(Icons.file_upload),
              label: const Text('Télécharger un fichier'),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //PLANTES
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(40, 40, 40, 20),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.local_florist),
                  onHover: null,
                  onPressed: () {
                    if (model.plantList.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>PlantListPage(plantList: model.plantList)));
                    } else {
                      log('plantList empty, go populate plantlist');
                      model.populatePlantList().then((value) {Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>PlantListPage(plantList: model.plantList)));});
                      
                    }
                  },
                  label: const Text(
                    'PLANTES',
                    textScaleFactor: 1.5,
                  ),
                ),
              ),
            ),
            //ZONES
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(40, 20, 40, 40),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.map),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyAreaPage(
                                  plantList: model.plantList,
                                  index: 1,
                                  storage: WritingStorage(),
                                )));
                  },
                  label: const Text(
                    'ZONES',
                    textScaleFactor: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
