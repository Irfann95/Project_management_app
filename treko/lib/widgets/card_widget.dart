import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treko/routes/trello_card.dart';
import 'package:treko/widgets/card_display_widget.dart';

class CardLists extends StatelessWidget {
  final String listId;
  final double maxHeight;
  final BuildContext context;

  const CardLists(
      {Key? key,
      required this.listId,
      required this.context,
      this.maxHeight = double.infinity})
      : super(key: key);

  double heightBoxCard(int cardsDataLength, context) {
    if (cardsDataLength * 100.0 < MediaQuery.of(context).size.height * 0.4) {
      return cardsDataLength * 100.0;
    } else {
      return MediaQuery.of(context).size.height * 0.4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CardModel>(
      builder: (context, card, child) {
        return FutureBuilder<List<dynamic>>(
          future: card.fetchCards(listId),
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
              final List<dynamic> cardsData = snapshot.data!;
              // print("the list $listId as : ");
              // print("the lenght of the card ${cardsData.length}");
              return Container(
                height: heightBoxCard(cardsData.length, context),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    for (var card in cardsData)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xFFF0FFFF),
                          ),
                          child: CardDisplay(card: card, context: context),
                        ),
                      ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }
}