import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treko/pages/board.dart';
import 'package:treko/widgets/slidable_widgets.dart';

void main() {
  testWidgets('HomePage UI Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: HomePage(workspaceId: 'testWorkspaceId'),
    ));

    // Verify that HomePage contains a title text widget.
    expect(find.text('Treko'), findsOneWidget);

    // Tap the add button and verify if it navigates to InviterMembreWidget.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Envoyer une invitation'), findsOneWidget);

    // Verify if CircularProgressIndicator is displayed while loading data.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Verify if SlidableWidget is displayed after data is loaded.
    await tester.pump(Duration(seconds: 3)); // Simulating data loading time
    expect(find.byType(SlidableWidget), findsWidgets);
  });
}
