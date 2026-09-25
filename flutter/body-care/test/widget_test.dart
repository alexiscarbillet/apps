import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:body_care/main.dart';
import 'package:body_care/data/models/uv_data_model.dart';
import 'package:body_care/data/services/local_storage_service.dart';
import 'package:body_care/data/services/uv_api_service.dart';
import 'package:body_care/data/repositories/health_repository.dart';
import 'package:body_care/logic/health_dashboard_controller.dart';
import 'package:body_care/logic/movement_timer_controller.dart';

class MockUvApiService extends UvApiService {
  @override
  Future<UvEnvironmentData> fetchUvData({
    required double latitude,
    required double longitude,
    required String locationName,
  }) async {
    return UvEnvironmentData.mockDefault();
  }
}

void main() {
  testWidgets('BodyCare app builds and renders navigation', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = await LocalStorageService.init();
    final repository = HealthRepository(
      storageService: storage,
      uvApiService: MockUvApiService(),
    );
    final healthController = HealthDashboardController(repository);
    final movementController = MovementTimerController();

    await tester.pumpWidget(BodyCareApp(
      healthController: healthController,
      movementController: movementController,
    ));

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verify app title and main navigation tabs are rendered
    expect(find.text('BodyCare Longevity'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Habits'), findsOneWidget);
    expect(find.text('UV & Sun'), findsOneWidget);
    expect(find.text('Vault'), findsOneWidget);
    expect(find.text('Movement'), findsOneWidget);
    expect(find.text('Skin Map'), findsOneWidget);
  });
}
