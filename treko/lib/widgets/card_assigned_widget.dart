import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treko/routes/trello_card.dart';
import 'package:treko/routes/trello_membre.dart';

class ShowMembersDialog extends StatelessWidget {
  final BuildContext context;
  final Map<String, dynamic> card;
  const ShowMembersDialog({Key? key, required this.card, required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Membres du tableau'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<List<dynamic>>(
                      future: Provider.of<MembreModel>(context, listen: false)
                          .boardMembers(card["idBoard"]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Erreur: ${snapshot.error}');
                        } else {
                          final List<dynamic> boardMembers = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: boardMembers.map((member) {
                              return ListTile(
                                title: Text(member['fullName']),
                                onTap: () {
                                  Provider.of<CardModel>(context, listen: false)
                                      .assignMemberToCard(
                                          card["id"], member['id']);
                                  Navigator.pop(context);
                                },
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: const Icon(Icons.person_add),
    );
  }
}
