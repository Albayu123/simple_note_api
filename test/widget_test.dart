import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note_api/main.dart';
import 'package:simple_note_api/widget/empty_state.dart';
import 'package:simple_note_api/widget/todo_card.dart';

void main() {
  testWidgets('Renders MainApp and loads initial screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    expect(find.text('Simple Note'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('EmptyStateWidget displays title and message', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyStateWidget(
            title: 'Test Empty',
            message: 'No items found',
            buttonText: 'Action',
            onButtonPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Test Empty'), findsOneWidget);
    expect(find.text('No items found'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
  });

  testWidgets('ToDoCard renders item and triggers callbacks', (WidgetTester tester) async {
    bool editCalled = false;
    bool toggleCalled = false;

    final testItem = {
      'id': '1',
      'title': 'Test Title',
      'description': 'Test Description',
      'is_completed': false,
    };

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: Scaffold(
          body: ToDoCard(
            index: 0,
            item: testItem,
            navigateEdit: (item) {
              editCalled = true;
            },
            deleteById: (id) {},
            onToggleStatus: (id, val) {
              toggleCalled = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
    expect(find.text('#1'), findsOneWidget);
    expect(find.text('Aktif'), findsOneWidget);

    // Tap toggle status
    await tester.tap(find.byTooltip('Tandai selesai'));
    expect(toggleCalled, isTrue);

    // Tap card to edit
    await tester.tap(find.text('Test Title'));
    expect(editCalled, isTrue);
  });
}
