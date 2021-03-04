import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('StreamState App', () {
    final nonStreamName = find.byValueKey("nonStreamName"); // 'Unknown'

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Starts with "Unknown" name', () async {
      expect(await driver.getText(nonStreamName), 'Name is Unknown');
    });
  });
}
