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

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Recipes worth keeping'), findsNothing);
    });

    testWidgets('onboarding continues to the login screen', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(
        tester,
        dependencies: buildTestDependencies(showOnboarding: true),
      );

      expect(find.text('Recipes from all over your family'), findsOneWidget);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Every recipe has a story'), findsOneWidget);

      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome back'), findsOneWidget);
    });

    testWidgets('auth continue navigates to recipe list', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(
        tester,
        dependencies: buildTestDependencies(signedIn: false),
      );

      await tester.ensureVisible(find.text('Log in'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Log in'));
      await tester.pumpAndSettle();

      expect(find.text('Recipes worth keeping'), findsOneWidget);
      expect(find.text('Aloo Paratha'), findsOneWidget);
    });

    testWidgets('sign-up requires a full name', (WidgetTester tester) async {
      await pumpTestApp(
        tester,
        dependencies: buildTestDependencies(signedIn: false),
      );

      await tester.ensureVisible(find.text('New here? Create an account'));
      await tester.tap(find.text('New here? Create an account'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Sign up'));
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your name'), findsOneWidget);
    });

    testWidgets('switching auth modes clears validation errors', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(
        tester,
        dependencies: buildTestDependencies(signedIn: false),
      );

      await tester.ensureVisible(find.text('New here? Create an account'));
      await tester.tap(find.text('New here? Create an account'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Sign up'));
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter your name'), findsOneWidget);

      await tester.ensureVisible(find.text('Already have an account? Log in'));
      await tester.tap(find.text('Already have an account? Log in'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your name'), findsNothing);
    });

    testWidgets('restores authenticated session and loads recipe list', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(
        tester,
        dependencies: buildTestDependencies(signedIn: true),
      );

      expect(find.text('Recipes worth keeping'), findsOneWidget);
      expect(find.text('Aloo Paratha'), findsOneWidget);
    });

    testWidgets('profile opens the settings screen', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(
        tester,
        dependencies: buildTestDependencies(signedIn: true),
      );

      await tester.tap(find.byIcon(Icons.account_circle_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Recipe privacy'), findsOneWidget);
      expect(find.text('3 recipes saved'), findsOneWidget);
      expect(find.text('Version 1.0.0'), findsOneWidget);
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

      await tester.ensureVisible(find.text('Log in'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Log in'));
      await tester.pumpAndSettle();

      expect(find.text('Invalid email or password.'), findsOneWidget);
      expect(find.text('Recipes worth keeping'), findsNothing);
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
      expect(find.text('Welcome back'), findsOneWidget);
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

    testWidgets('collection filters recipes on the home screen', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(
        tester,
        dependencies: buildTestDependencies(signedIn: true),
      );

      final collectionChip = find.widgetWithText(
        ChoiceChip,
        'Coastal classics',
      );
      await tester.ensureVisible(collectionChip);
      await tester.tap(collectionChip);
      await tester.pumpAndSettle();

      expect(find.text('Coconut Fish Curry'), findsOneWidget);
      expect(find.text('Aloo Paratha'), findsNothing);
      expect(find.text('1 recipe in Coastal classics'), findsOneWidget);
    });

    testWidgets('empty search shows the no-results state', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(
        tester,
        dependencies: buildTestDependencies(signedIn: true),
      );

      await tester.enterText(find.byType(TextField), 'biryani');
      await tester.pumpAndSettle();

      expect(find.text('No recipes found'), findsOneWidget);
      expect(find.text('No recipes saved yet'), findsNothing);
      expect(find.text('Add Recipe'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Aloo Paratha'), findsOneWidget);
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
      await tester.enterText(fields.at(3), '1 cup yogurt\n1 mango\nSugar');
      await tester.enterText(fields.at(4), 'Blend everything\nServe chilled');

      await tester.tap(find.text('Save Recipe'));
      await tester.pumpAndSettle();

      expect(find.text('Mango Lassi'), findsOneWidget);
      expect(find.text('Recipe saved'), findsOneWidget);
    });

    testWidgets('recipe numbers must be positive whole numbers', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(
        tester,
        dependencies: buildTestDependencies(signedIn: true),
      );

      await tester.tap(find.text('Add Recipe'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Mango Lassi');
      await tester.enterText(fields.at(3), '1 cup yogurt');
      await tester.enterText(fields.at(4), 'Blend everything');
      await tester.enterText(fields.at(5), '0');

      await tester.tap(find.text('Save Recipe'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a whole number of 1 or more'), findsOneWidget);
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

      expect(find.text('Recipes worth keeping'), findsOneWidget);
      expect(find.text('Aloo Paratha'), findsNothing);
    });
  });
}
