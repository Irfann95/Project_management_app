import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:treko/routes/trello_board.dart';
import 'package:provider/provider.dart';
import 'package:treko/routes/trello_workspace.dart';

class SlidableWidget<T> extends StatelessWidget {
  final Widget child;
  final String id;
  final String type;

  const SlidableWidget(
      {required this.child, Key? key, required this.id, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Slidable(
        // key: ValueKey(board['id']),
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: update,
              backgroundColor: Color(0xFFFFA726),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: delete,
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),

        child: child,
      );

  void delete(BuildContext context) {
    print("the id is ${id}");
    switch (type) {
      case "workspace":
        Provider.of<WorkspaceModel>(context, listen: false).deleteWorkspace(id);
        break;
      case "board":
        Provider.of<ApiModel>(context, listen: false).deleteBoard(id);
        break;
      default:
        print("Type undefined");
    }
  }

  void update(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newName = '';
        return AlertDialog(
          title: Text('Modifier le nom'),
          content: TextField(
            onChanged: (value) {
              newName = value;
            },
            decoration: const InputDecoration(
              hintText: 'Nouveau nom',
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
                switch (type) {
                  case "workspace":
                    Provider.of<WorkspaceModel>(context, listen: false)
                        .editWorkspace(id, newName)
                        .then((_) {
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      print('Erreur lors de la modification du nom: $error');
                    });
                    break;
                  case "board":
                    Provider.of<ApiModel>(context, listen: false)
                        .editBoard(id, newName)
                        .then((_) {
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      print('Erreur lors de la modification du nom: $error');
                    });
                    break;
                  default:
                    print("Type undefined");
                }
              },
              child: Text('Modifier'),
            ),
          ],
        );
      },
    );
  }
}
