import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treko/routes/trello_list.dart';

class CreateListWidget extends StatefulWidget {
  final String boardId;

  const CreateListWidget({Key? key, required this.boardId}) : super(key: key);

  @override
  CreateListWidgetState createState() => CreateListWidgetState();
}

class CreateListWidgetState extends State<CreateListWidget> {
  late TextEditingController listNameController;

  @override
  void initState() {
    super.initState();
    listNameController = TextEditingController();
  }

  @override
  void dispose() {
    listNameController.dispose();
    super.dispose();
  }

  Future<void> createList(String name, String boardId) async {
    try {
      await Provider.of<ListModel>(context, listen: false)
          .createList(name, boardId);
      Navigator.of(context).pop();
    } catch (error) {
      print('Erreur lors de la création de la liste: $error');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Échec de la création de la liste: $error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer une nouvelle liste'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: listNameController,
              decoration: InputDecoration(labelText: 'Nom de la liste'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String listName = listNameController.text.trim();
                if (listName.isNotEmpty) {
                  createList(listName, widget.boardId);
                }
              },
              child: Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }
}
