import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('hello world test', (WidgetTester tester) async {
    // Your test code here
    expect(true, isTrue);
  });
}