// trello_board_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:treko/routes/trello_board.dart';

void main() {
  group('ApiModel', () {
    test('createBoard() should create a new board', () async {
      final apiModel = ApiModel();

      final workspaceId = '65faf5fd17c84793d36b8ac4';
      final boardName = 'Test Board';

      await apiModel.createBoard(boardName, workspaceId);
    });

    test('editBoard() should edit the name of an existing board', () async {
      final apiModel = ApiModel();

      final boardId = '660021ec852e352b700fcd0a'; 

      final newName = 'New Board Name';

      await apiModel.editBoard(boardId, newName);


    });

    test('deleteBoard() should delete an existing board', () async {
      final apiModel = ApiModel();

      final boardId = '660021ec852e352b700fcd0a'; 
      await apiModel.deleteBoard(boardId);


    });
  });
}
