import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treko/routes/trello_card.dart';
import 'package:treko/widgets/card_assigned_widget.dart';
import 'package:treko/widgets/card_detail_widget.dart';
// import 'package:treko/widgets/card_widget.dart';

class CardDisplay extends StatelessWidget {
  final BuildContext context;
  final Map<String, dynamic> card;
  const CardDisplay({Key? key, required this.card, required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> membersCard = card["idMembers"];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CardDetail(card: card, child: Text(card["name"])),
            SizedBox(height: 8),
            Row(
              children: [
                Row(children: [
                  if (membersCard.isEmpty)
                    ShowMembersDialog(card: card, context: context),
                  if (membersCard.isNotEmpty)
                    ...membersCard.map((member) => Icon(Icons.person)),
                ]),
                Spacer(),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: AlertDialog(
                              title: Text("Suppression : ${card["name"]}"),
                              content: Text(
                                  "Voulez vous vraimant supprimer cette carte\nToute suppression est définitive"),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Annuler")),
                                Spacer(),
                                ElevatedButton(
                                    onPressed: () {
                                      Provider.of<CardModel>(context,
                                              listen: false)
                                          .deleteCard(card["id"]);
                                      Navigator.of(context).pop();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                    ),
                                    child: Text("Supprimer")),
                              ],
                            ),
                          );
                        });
                  },
                  child: Icon(Icons.delete_forever_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
