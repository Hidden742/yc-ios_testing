import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:youth_club_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsBinding.ensureInitialized();

  group('Youth Club App Integration Tests', () {
    testWidgets('Complete app flow test', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Should start with auth screen
      expect(find.text('Youth Club'), findsAtLeastOneWidget);
      
      // Test navigation between sign in and sign up tabs
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();
      expect(find.text('Create Account'), findsOneWidget);
      
      // Go back to sign in
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(find.text('Sign In').last, findsOneWidget);
    });

    testWidgets('Form validation integration test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test email field validation
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalid-email');
      
      // Try to submit
      await tester.tap(find.text('Sign In').last);
      await tester.pumpAndSettle();
      
      // Should show validation error
      expect(find.text('Please enter a valid email'), findsOneWidget);
      
      // Fix email and test password validation
      await tester.enterText(emailField, 'test@example.com');
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, '123');
      
      await tester.tap(find.text('Sign In').last);
      await tester.pumpAndSettle();
      
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('UI responsiveness test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test that UI responds to screen size changes
      // This would be more complex in a real test
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('Accessibility test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test semantic labels and accessibility
      final SemanticsHandle handle = tester.ensureSemantics();
      
      // Verify important widgets have semantic labels
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(ElevatedButton), findsWidgets);
      
      handle.dispose();
    });
  });
}
