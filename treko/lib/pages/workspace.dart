import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treko/pages/board.dart';
import 'package:treko/routes/trello_workspace.dart';
import 'package:treko/widgets/create_workspace_widgets.dart';
import 'package:treko/widgets/slidable_widgets.dart';

class EspaceDeTravailPage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Treko - Espaces de travail",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xFF89CFF0),
        actions: [],
      ),



      body: Center(
        child: Consumer<WorkspaceModel>(builder: (context, api, child) {
          return FutureBuilder<List<dynamic>>(
            future: api.fetchWorkspaces(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Erreur: ${snapshot.error}'),
                );
              } else {
                final List<dynamic> workspacesData = snapshot.data!;
                return ListView.builder(
                  itemCount: workspacesData.length,
                  itemBuilder: (context, index) {
                    final workspace = workspacesData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xFF89CFF0),
                        ),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HomePage(workspaceId: workspace['id']),
                                ),
                              );
                            },
                            child: SlidableWidget(
                              id: workspace['id'],
                              type: "workspace",
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF89CFF0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: Align(
                                  child: Text(
                                    (workspace['displayName']),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    );
                  },
                );
              }
            },
          );
        }),
      ),
      //*************************bouton en bas***************** */
      floatingActionButton: const CreateWorkspaceWidget(),
    );
  }

}
