import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:brain_care/data/services/local_storage_service.dart';
import 'package:brain_care/main.dart';

void main() {
  testWidgets('BrainCare app loads the dashboard shell', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const BrainCareApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  test('new user starts with empty history and zero CRI', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService();

    final profile = await storage.loadProfile();
    final sessions = await storage.loadSessions();
    final lifestyleLogs = await storage.loadLifestyleLogs();

    expect(profile.cognitiveReserveIndex, 0.0);
    expect(profile.domainMastery.values.every((value) => value == 0.0), isTrue);
    expect(sessions, isEmpty);
    expect(lifestyleLogs, isEmpty);
  });
}
