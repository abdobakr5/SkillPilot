import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillpilot/core/databases/cache_helper.dart';
import 'package:skillpilot/core/di/service_locator.dart';
import 'package:skillpilot/core/utils/app_strings.dart';
import 'package:skillpilot/main.dart';

void main() {
  testWidgets('Initial app loads successfully', (WidgetTester tester) async {
    // Mock SharedPreferences values for testing environment
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
    await initServiceLocator();

    await tester.pumpWidget(const SkillPilotApp());
    await tester.pump();

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text('Clean Architecture Foundation Ready'), findsOneWidget);
  });
}
