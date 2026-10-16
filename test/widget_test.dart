import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillpilot/core/databases/cache_helper.dart';
import 'package:skillpilot/core/di/service_locator.dart';
import 'package:skillpilot/main.dart';

void main() {
  testWidgets('Initial app loads splash screen successfully', (WidgetTester tester) async {
    // Mock SharedPreferences values for testing environment
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
    await initServiceLocator();

    await tester.pumpWidget(const SkillPilotApp());
    await tester.pump();

    // Verify SkillPilot brand appears on splash screen
    expect(find.text('SkillPilot'), findsOneWidget);
    expect(find.text('Navigate Your Code Journey'), findsOneWidget);
  });
}
