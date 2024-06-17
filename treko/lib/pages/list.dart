import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:treko/routes/trello_card.dart';
import 'package:provider/provider.dart';
import 'package:treko/routes/trello_list.dart';
import 'package:treko/widgets/card_widget.dart';
import 'package:treko/widgets/create_card.dart';
import 'package:treko/widgets/create_list_widget.dart';

class BoardPage extends StatelessWidget {
  final Map<String, dynamic> board;
  final String boardId;
  final String boardName;

  BoardPage(
      {required this.boardId, required this.boardName, required this.board});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treko'),
        backgroundColor: Color(0xFF89CFF0),
        actions: <Widget>[],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: board["prefs"]["backgroundImage"] != null
              ? DecorationImage(
                  image: NetworkImage(board["prefs"]["backgroundImage"]),
                  fit: BoxFit.cover,
                )
              : null,
          color: board["prefs"]["backgroundImage"] != null
              ? null
              : Color(int.parse(
                      board["prefs"]["backgroundColor"].substring(1, 7),
                      radix: 16) +
                  0xFF000000),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              boardName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 10.0),
            FutureBuilder<List<dynamic>>(
              future: Provider.of<ListModel>(context).fetchList(boardId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erreur: ${snapshot.error}');
                } else {
                  final List<dynamic> listsData = snapshot.data!;
                  if (listsData.isEmpty) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                CreateListWidget(boardId: boardId),
                          );
                        },

                        child: Text('Ajouter une liste'),
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: listsData.map<Widget>(
                        (list) {
                          return Container(
                            width: 300,
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Card(
                                  color: Color(0xFF89CFF0).withOpacity(0.5),
                                  elevation: 4,
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                list['name'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: () {
                                                edit(context, list['id'],
                                                    list['name']);
                                              },
                                            ),
                                            IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  delete(
                                                    context,
                                                    list['id'],
                                                  );
                                                }),
                                          ],
                                        ),
                                        const SizedBox(height: 10.0),
                                        CardLists(
                                            listId: list["id"],
                                            context: context),
                                        const SizedBox(height: 10.0),
                                        CreateCard(listId: list["id"]),
                                        const SizedBox(height: 10.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CreateListWidget(boardId: boardId),
          );
        },
        tooltip: 'Ajouter une liste',
        child: Icon(Icons.add),
      ),
    );
  }
}

void delete(BuildContext context, String listId) {
  print("the id is ${listId}");

  Provider.of<ListModel>(context, listen: false).deleteList(listId);
}

void edit(BuildContext context, String listId, String name) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String newName = '';
      return AlertDialog(
        title: const Text('Modifier le nom'),
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
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ListModel>(context, listen: false)
                  .editList(newName, listId)
                  .then((_) {
                Navigator.of(context).pop();
              }).catchError((error) {
                print('Erreur lors de la modification du nom: $error');
              });
            },
            child: const Text('Modifier'),
          ),
        ],
      );
    },
  );
}
