import 'package:flutter_test/flutter_test.dart';
import 'package:treko/routes/trello_workspace.dart';

void main() {
  group('WorkspaceModel', () {
    test('createWorkspace() should create a new workspace', () async {
      final workspaceModel = WorkspaceModel();
      const workspaceName = 'Test Workspace';
      await workspaceModel.createWorkspace(workspaceName);

      // Assertion: Fetch workspaces and check if the newly created workspace exists
      final workspaces = await workspaceModel.fetchWorkspaces();
      final workspaceExists = workspaces.any((workspace) => workspace['displayName'] == workspaceName);

      expect(workspaceExists, true);
    });

    test('fetchWorkspaces() should read the workspaces', () async {
      final workspaceModel = WorkspaceModel();
      final workspaces = await workspaceModel.fetchWorkspaces();

      expect(workspaces, isA<List<dynamic>>());
    });
  });

  test('editWorkspace() should edit the workspace name', () async {
    final workspaceModel = WorkspaceModel();
    const workspaceId = '660021bb5b22760632228e59';
    const newName = 'New Workspace Name';

    await workspaceModel.editWorkspace(workspaceId, newName);


  });

  test('deleteWorkspace() should delete the workspace', () async {
    final workspaceModel = WorkspaceModel();
    const workspaceId = '660021bb5b22760632228e59';
    await workspaceModel.deleteWorkspace(workspaceId);


  });

}


