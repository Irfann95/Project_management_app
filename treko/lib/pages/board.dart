import 'package:flutter/material.dart';
import 'package:treko/pages/list.dart';
import 'package:treko/routes/trello_board.dart';
import 'package:treko/widgets/slidable_widgets.dart';
import 'package:treko/widgets/create_widgets.dart';
import 'package:treko/widgets/invit_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final String workspaceId;

  HomePage({Key? key, required this.workspaceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treko'),
        backgroundColor: Color(0xFF89CFF0),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Envoyer une invitation',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InviterMembreWidget(
                    workspaceId: workspaceId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Consumer<ApiModel>(
          builder: (context, api, child) {
            return FutureBuilder<List<dynamic>>(
              future: api.fetchBoards(workspaceId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erreur: ${snapshot.error}');
                } else {
                  final List<dynamic> boardsData = snapshot.data!;
                  return ListView.builder(
                    itemCount: boardsData.length + 1,
                    itemBuilder: (context, index) {
                      if (index == boardsData.length) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CreateWidgets(workspaceId: workspaceId),
                        );
                      } else {
                        final board = boardsData[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              print("The board['id'] is : ${board['id']}");
                              print("The board['name'] is : ${board['name']}");
                              print(
                                  "The board['prefs']['backgroundImage'] is : ${board['prefs']['backgroundImage']}");
                              print("The board is : ${board}");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BoardPage(
                                    boardId: board['id'],
                                    boardName: board['name'],
                                    board: board,
                                  ),
                                ),
                              );
                            },
                            child: SlidableWidget(
                              id: board['id'],
                              type: "board",
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF89CFF0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: Align(
                                  child: Text(
                                    (board['name']),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
