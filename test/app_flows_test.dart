import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:family_recipe_app/src/core/network/api_exception.dart';

import 'helpers/test_app.dart';

void main() {
  group('Family Recipe App flows', () {
    testWidgets('routes unauthenticated user to auth screen', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(
        tester,
        dependencies: buildTestDependencies(signedIn: false),
      );

      expect(find.text('Keep your family recipes close'), findsOneWidget);
      expect(find.text('Saved recipes'), findsNothing);
    });

    testWidgets('auth continue navigates to recipe list', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(
        tester,
        dependencies: buildTestDependencies(signedIn: false),
      );

      await tester.ensureVisible(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Saved recipes'), findsOneWidget);
      expect(find.text('Aloo Paratha'), findsOneWidget);
    });

    testWidgets('restores authenticated session and loads recipe list', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(
        tester,
        dependencies: buildTestDependencies(signedIn: true),
      );

      expect(find.text('Saved recipes'), findsOneWidget);
      expect(find.text('Aloo Paratha'), findsOneWidget);
      expect(find.text('Dal Tadka'), findsOneWidget);
    });

    testWidgets('shows backend auth error on login failure', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(
        tester,
        dependencies: buildCustomTestDependencies(
          authRepository: FakeAuthRepository(
            signInError: ApiException(
              message: 'Invalid email or password.',
              statusCode: 401,
            ),
          ),
        ),
      );

      await tester.ensureVisible(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Invalid email or password.'), findsOneWidget);
      expect(find.text('Saved recipes'), findsNothing);
    });

    testWidgets('shows session restore error on auth screen', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(
        tester,
        dependencies: buildCustomTestDependencies(
          authRepository: FakeAuthRepository(
            restoreSessionError: ApiException(
              message:
                  'We could not reach the server. Check your connection and API base URL.',
            ),
          ),
        ),
      );

      expect(
        find.text(
          'We could not reach the server. Check your connection and API base URL.',
        ),
        findsOneWidget,
      );
      expect(find.text('Keep your family recipes close'), findsOneWidget);
    });

    testWidgets('search filters recipes by title', (WidgetTester tester) async {
      await pumpTestApp(
        tester,
        dependencies: buildTestDependencies(signedIn: true),
      );

      await tester.enterText(find.byType(TextField), 'dal');
      await tester.pumpAndSettle();

      expect(find.text('Dal Tadka'), findsOneWidget);
      expect(find.text('Aloo Paratha'), findsNothing);
    });

    testWidgets('user can add a recipe', (WidgetTester tester) async {
      await pumpTestApp(
        tester,
        dependencies: buildTestDependencies(signedIn: true),
      );

      await tester.tap(find.text('Add Recipe'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Mango Lassi');
      await tester.enterText(fields.at(2), '1 cup yogurt\n1 mango\nSugar');
      await tester.enterText(fields.at(3), 'Blend everything\nServe chilled');

      await tester.tap(find.text('Save Recipe'));
      await tester.pumpAndSettle();

      expect(find.text('Mango Lassi'), findsOneWidget);
      expect(find.text('Recipe saved'), findsOneWidget);
    });

    testWidgets('user can edit a recipe', (WidgetTester tester) async {
      await pumpTestApp(
        tester,
        dependencies: buildTestDependencies(signedIn: true),
      );

      await tester.tap(find.text('Aloo Paratha'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit_rounded));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Aloo Paratha Updated');

      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      expect(find.text('Aloo Paratha Updated'), findsOneWidget);
    });

    testWidgets('user can delete a recipe', (WidgetTester tester) async {
      await pumpTestApp(
        tester,
        dependencies: buildTestDependencies(signedIn: true),
      );

      await tester.tap(find.text('Aloo Paratha'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete recipe'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.text('Saved recipes'), findsOneWidget);
      expect(find.text('Aloo Paratha'), findsNothing);
    });
  });
}
