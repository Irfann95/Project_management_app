// trello_list_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:treko/routes/trello_list.dart';

void main() {
  group('ListModel', () {
    test('createList() should create a new list', () async {
      final listModel = ListModel();
      final boardId = '660021fe5caadf04d4b54abc';
      final listName = 'Test List';

      await listModel.createList(listName, boardId);


    });

    test('editList() should edit the name of an existing list', () async {
      final listModel = ListModel();
      final listId = '660022101afdc5ae21b6ef4d';
      final newName = 'New List Name';

      await listModel.editList(newName, listId);


    });

    test('deleteList() should delete an existing list', () async {
      final listModel = ListModel();
      final listId = '660022101afdc5ae21b6ef4d'; // Remplacez par un identifiant de liste valide

      await listModel.deleteList(listId);


    });
  });
}
