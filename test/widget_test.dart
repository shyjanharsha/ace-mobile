import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:donkey_card_game/shared/widgets/app_button.dart';

void main() {
  testWidgets('AppButton rendering test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            label: 'Test Button',
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Test Button'), findsOneWidget);
  });
}
