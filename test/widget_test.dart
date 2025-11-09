import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:youth_club_app/main.dart';
import 'mock_firebase.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('Youth Club App Widget Tests', () {
    testWidgets('App starts with auth wrapper', (WidgetTester tester) async {
      await tester.pumpWidget(const YouthClubApp());
      
      // Wait for the auth state to be determined
      await tester.pumpAndSettle();
      
      // Should show auth screen when not logged in
      expect(find.byType(AuthWrapper), findsOneWidget);
    });

    testWidgets('Auth screen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const YouthClubApp());
      await tester.pumpAndSettle();
      
      // Should show sign in form
      expect(find.text('Youth Club'), findsWidgets);
      expect(find.text('Connect, Inspire, Grow Together'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('Sign in form validation works', (WidgetTester tester) async {
      await tester.pumpWidget(const YouthClubApp());
      await tester.pumpAndSettle();
      
      // Try to sign in without email
      final signInButton = find.text('Sign In').last;
      await tester.tap(signInButton);
      await tester.pumpAndSettle();
      
      // Should show validation error
      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('Tab navigation works in auth screen', (WidgetTester tester) async {
      await tester.pumpWidget(const YouthClubApp());
      await tester.pumpAndSettle();
      
      // Tap on Sign Up tab
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();
      
      // Should show create account button
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('Email validation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const YouthClubApp());
      await tester.pumpAndSettle();
      
      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      
      // Try to sign in
      final signInButton = find.text('Sign In').last;
      await tester.tap(signInButton);
      await tester.pumpAndSettle();
      
      // Should show email validation error
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('Password validation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const YouthClubApp());
      await tester.pumpAndSettle();
      
      // Enter valid email but short password
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;
      
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, '123');
      
      // Try to sign in
      final signInButton = find.text('Sign In').last;
      await tester.tap(signInButton);
      await tester.pumpAndSettle();
      
      // Should show password validation error
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });
  });

  group('Inspiration Content Tests', () {
    testWidgets('Inspiration card displays correctly', (WidgetTester tester) async {
      // Test inspiration card widget separately
      const testContent = InspirationContent(
        title: 'Test Title',
        subtitle: 'Test Subtitle',
        imagePath: 'assets/images/test.jpg',
        description: 'Test Description',
        category: 'Test Category',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InspirationCard(
              content: testContent,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);
      expect(find.text('Test Category'), findsOneWidget);
    });
  });
}
