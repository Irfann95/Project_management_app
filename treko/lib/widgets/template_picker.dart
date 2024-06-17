import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treko/routes/trello_board.dart';

class TemplatePicker extends StatefulWidget {
  final String workspaceId;
  final BuildContext contextOrigin;

  const TemplatePicker(
      {Key? key, required this.workspaceId, required this.contextOrigin})
      : super(key: key);

  @override
  _TemplatePickerState createState() => _TemplatePickerState();
}

class _TemplatePickerState extends State<TemplatePicker> {
  String newBoardName = '';
  bool keepCards = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(widget.contextOrigin).pop();
          showDialog(
            context: context,
            builder: (BuildContext contextAlert) {
              return Center(
                child: AlertDialog(
                  title: Text("Choisir un modèle"),
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Consumer<ApiModel>(
                      builder: (context, api, child) {
                        return FutureBuilder(
                          future: api.fetchBoardTemplate(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Erreur: ${snapshot.error}'));
                            } else {
                              final List<dynamic> templateData = snapshot.data!;
                              return ListView.builder(
                                itemCount: templateData.length,
                                itemBuilder: (context, index) {
                                  final template = templateData[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(contextAlert).pop();
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (BuildContext context,
                                                StateSetter setState) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Entrer le nom de votre tableau'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      onChanged: (value) {
                                                        newBoardName = value;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Nom du tableau',
                                                      ),
                                                    ),
                                                    CheckboxListTile(
                                                      title: Text(
                                                          "Garder les cartes du modèle"),
                                                      value: keepCards,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          keepCards = value!;
                                                          print(
                                                              "The value of the keepCard is :");
                                                          print(keepCards);
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Annuler'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Provider.of<ApiModel>(
                                                              context,
                                                              listen: false)
                                                          .createBoardWithTemplate(
                                                              newBoardName,
                                                              widget
                                                                  .workspaceId,
                                                              template["id"],
                                                              keepCards)
                                                          .then((value) {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }).catchError((error) {
                                                        print(
                                                            'Erreur lors de la création du tableau: $error');
                                                      });
                                                    },
                                                    child: Text('Créer'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Card(
                                      child: ListTile(
                                        leading: Image.network(
                                          template["prefs"]["backgroundImage"],
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            }
                                          },
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Text(
                                              '',
                                            );
                                          },
                                        ),
                                        title: Text(template["name"]),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Annuler'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Text("Utiliser un modèle"),
      ),
    );
  }
}
