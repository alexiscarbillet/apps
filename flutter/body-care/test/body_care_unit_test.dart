import 'package:flutter_test/flutter_test.dart';
import 'package:body_care/data/models/user_profile_model.dart';
import 'package:body_care/data/models/habit_log_model.dart';
import 'package:body_care/data/models/uv_data_model.dart';
import 'package:body_care/data/models/screening_model.dart';
import 'package:body_care/data/models/mole_record_model.dart';
import 'package:body_care/logic/movement_timer_controller.dart';

void main() {
  group('UserProfile & Risk Baseline Tests', () {
    test('Calculates BMI accurately', () {
      final profile = UserProfile(
        fullName: 'Test User',
        age: 30,
        biologicalSex: 'Male',
        heightCm: 180.0,
        weightKg: 72.9,
        bloodType: 'O+',
        restingHeartRate: 60,
        bloodPressureSystolic: 120,
        bloodPressureDiastolic: 80,
        personalWhy: 'Healthspan',
        riskFactors: [],
        baselineLabs: [],
      );

      // BMI = 72.9 / (1.8 * 1.8) = 72.9 / 3.24 = 22.5
      expect(profile.bmi, closeTo(22.5, 0.1));
    });

    test('Serializes and deserializes UserProfile correctly', () {
      final defaultProf = UserProfile.defaultProfile();
      final json = defaultProf.toJson();
      final parsed = UserProfile.fromJson(json);

      expect(parsed.fullName, equals(defaultProf.fullName));
      expect(parsed.riskFactors.length, equals(defaultProf.riskFactors.length));
      expect(parsed.baselineLabs.length, equals(defaultProf.baselineLabs.length));
    });
  });

  group('DailyHabitLog Adherence Scoring Tests', () {
    test('Computes 100% adherence score when all goals met', () {
      const log = DailyHabitLog(
        dateKey: '2026-09-25',
        leafyGreensServings: 3,
        noUpfMeals: 3,
        alcoholUnits: 0.0,
        waterGlasses: 8,
        standingBreaks: 6,
        sunscreenApplied: true,
      );

      expect(log.adherenceScore, equals(100.0));
    });

    test('Computes partial adherence score accurately', () {
      const log = DailyHabitLog(
        dateKey: '2026-09-25',
        leafyGreensServings: 0,
        noUpfMeals: 0,
        alcoholUnits: 3.0,
        waterGlasses: 0,
        standingBreaks: 0,
        sunscreenApplied: false,
      );

      expect(log.adherenceScore, equals(0.0));
    });
  });

  group('UV Environment Tests', () {
    test('Categorizes UV index correctly', () {
      final lowUv = UvEnvironmentData.mockDefault().copyWith(currentUv: 2.0);
      expect(lowUv.uvCategory, equals(UvCategory.low));

      final modUv = UvEnvironmentData.mockDefault().copyWith(currentUv: 4.5);
      expect(modUv.uvCategory, equals(UvCategory.moderate));

      final highUv = UvEnvironmentData.mockDefault().copyWith(currentUv: 7.2);
      expect(highUv.uvCategory, equals(UvCategory.high));

      final veryHighUv = UvEnvironmentData.mockDefault().copyWith(currentUv: 9.5);
      expect(veryHighUv.uvCategory, equals(UvCategory.veryHigh));

      final extremeUv = UvEnvironmentData.mockDefault().copyWith(currentUv: 12.0);
      expect(extremeUv.uvCategory, equals(UvCategory.extreme));
    });
  });

  group('MedicalScreening Tests', () {
    test('Identifies overdue vs upcoming screenings', () {
      final now = DateTime.now();
      final overdueScreening = MedicalScreening(
        id: 'test-1',
        title: 'Overdue Blood Test',
        category: 'Metabolic',
        frequencyMonths: 12,
        nextDueDate: now.subtract(const Duration(days: 10)),
        providerName: 'Clinic',
        facility: 'Hospital',
        status: ScreeningStatus.upcoming,
        whyImportant: 'Check markers',
      );

      expect(overdueScreening.isOverdue, isTrue);

      final upcomingScreening = MedicalScreening(
        id: 'test-2',
        title: 'Upcoming Scan',
        category: 'Dermatology',
        frequencyMonths: 12,
        nextDueDate: now.add(const Duration(days: 30)),
        providerName: 'Dr. Derm',
        facility: 'Skin Center',
        status: ScreeningStatus.upcoming,
        whyImportant: 'Check moles',
      );

      expect(upcomingScreening.isOverdue, isFalse);
    });
  });

  group('MoleRecord & ABCDE Criteria Tests', () {
    test('Calculates ABCDE risk score', () {
      final now = DateTime.now();
      final mole = MoleRecord(
        id: 'm-1',
        label: 'Atypical Nevus',
        bodyRegion: 'Upper Back',
        isBackView: true,
        xPercent: 0.5,
        yPercent: 0.5,
        currentSizeMm: 6.5,
        baseColorHex: '#332211',
        isAsymmetrical: true,
        hasIrregularBorder: true,
        hasMultipleColors: true,
        isDiameterOver6mm: true,
        isEvolving: false,
        riskRating: MoleRiskRating.monitor,
        lastCheckedDate: now,
        clinicalNotes: 'Check borders',
        history: [],
      );

      // A (1) + B (1) + C (1) + D (1) + E (0) = 4
      expect(mole.abcdeRiskScore, equals(4));
    });
  });

  group('MovementTimerController Tests', () {
    test('Initializes timer and formats time correctly', () {
      final controller = MovementTimerController();
      controller.setIntervalMinutes(45);

      expect(controller.formattedTime, equals('45:00'));
      expect(controller.isRunning, isFalse);
      expect(controller.breaksCompletedToday, equals(0));
    });
  });
}
