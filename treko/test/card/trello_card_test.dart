import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:treko/routes/trello_card.dart';

class MockCardModel extends Mock implements CardModel {}

void main() {
  group('CardModel Test', () {
    late MockCardModel mockCardModel;

    setUp(() {
      mockCardModel = MockCardModel();
    });

    test('Test de la récupération des cartes depuis une liste',
            () async {
          final String listId = 'mockListId';
          final List<dynamic> mockCardsData = [
            {'id': '1', 'name': 'Card 1'},
            {'id': '2', 'name': 'Card 2'},
          ];

          when(mockCardModel.fetchCards(listId))
              .thenAnswer((_) async => mockCardsData);

          final cardsData = await mockCardModel.fetchCards(listId);

          expect(cardsData, equals(mockCardsData));
        });

    test('Test de création d\'une nouvelle carte', () async {
      final String cardName = 'New Card';
      final String listId = 'mockListId';

      when(mockCardModel.createCard(cardName, listId))
          .thenAnswer((_) async => {});

      await mockCardModel.createCard(cardName, listId);

      verify(mockCardModel.createCard(cardName, listId)).called(1);
    });

    test('Test de l\'assignation d\'un membre à une carte', () async {
      final String cardId = 'mockCardId';
      final String memberId = 'mockMemberId';

      when(mockCardModel.assignMemberToCard(cardId, memberId))
          .thenAnswer((_) async => {});

      await mockCardModel.assignMemberToCard(cardId, memberId);

      verify(mockCardModel.assignMemberToCard(cardId, memberId)).called(1);
    });

    test('Test de la suppression d\'une carte', () async {
      final String cardId = 'mockCardId';

      when(mockCardModel.deleteCard(cardId)).thenAnswer((_) async => {});

      await mockCardModel.deleteCard(cardId);

      verify(mockCardModel.deleteCard(cardId)).called(1);
    });
  });
}
