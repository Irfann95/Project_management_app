import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treko/pages/workspace.dart';
import 'package:treko/routes/trello_workspace.dart';

class CreateWorkspaceWidget extends StatefulWidget {
  const CreateWorkspaceWidget({Key? key}) : super(key: key);

  @override
  _CreateWorkspaceWidgetState createState() => _CreateWorkspaceWidgetState();
}

class _CreateWorkspaceWidgetState extends State<CreateWorkspaceWidget> {
  late String newWorkspaceName;

  @override
  void initState() {
    super.initState();
    newWorkspaceName = '';
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              title: const Text('Créer un nouvel espace de travail'),
              content: TextField(
                onChanged: (value) {
                  setState(() {
                    newWorkspaceName = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Nom de l\'espace de travail',
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<WorkspaceModel>(context, listen: false)
                        .createWorkspace(newWorkspaceName)
                        .then((value) {
                      Navigator.of(context).pop(); // Ferme la bulle
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => EspaceDeTravailPage(),
                        ),
                      );
                    }).catchError((error) {
                      print(
                          'Erreur lors de la création de l\'espace de travail: $error');
                    });
                  },
                  child: Text('Créer'),
                ),
              ],
            );
          },
        );
      },
      tooltip: 'Créer un nouvel espace de travail',
      backgroundColor: Color(0xFF89CFF0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Icon(Icons.add),
    );
  }
}
