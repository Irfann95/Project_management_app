import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treko/pages/board.dart';
import 'package:treko/pages/workspace.dart';
import 'package:treko/routes/trello_workspace.dart';
import 'package:treko/widgets/create_workspace_widgets.dart';
import 'package:treko/widgets/slidable_widgets.dart';

void main() {
  testWidgets('EspaceDeTravailPage UI test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => WorkspaceModel(),
          child: EspaceDeTravailPage(),
        ),
      ),
    );

    expect(find.text('Treko - Espaces de travail'), findsOneWidget);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);

    expect(find.byType(ListView), findsOneWidget);

    await tester.tap(find.text('Retest'));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);

    expect(find.byType(CreateWorkspaceWidget), findsOneWidget);
  });
}
