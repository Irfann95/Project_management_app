import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:treko/routes/trello_card.dart';

class CreateCard extends StatelessWidget {
  final String listId;

  const CreateCard({Key? key, required this.listId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String cardName = "";
    String cardDescription = "";

    return ElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                    child: AlertDialog(
                  title: Text("Création d'un carte"),
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nom de la carte :"),
                        const SizedBox(height: 2.0),
                        TextField(
                          onChanged: (value) {
                            cardName = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter le nom de votre carte',
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text("Description de la carte :"),
                        const SizedBox(height: 2.0),
                        Flexible(
                          child: TextField(
                            minLines: 3,
                            maxLines: null,
                            onChanged: (value) {
                              cardDescription = value;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter la description de votre carte ',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text("Assigner la carte"),
                        const SizedBox(height: 2.0),
                        Row(
                          children: [
                            Icon(Icons.person_add),
                          ],
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Annuler")),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<CardModel>(context, listen: false)
                            .createCard(cardName, cardDescription, listId);
                        Navigator.of(context).pop();
                      },
                      child: Text("Créer"),
                    ),
                  ],
                ));
              });
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_card_outlined),
            SizedBox(width: 5.0),
            Text("Ajouter une carte")
          ],
        ));
  }
}
