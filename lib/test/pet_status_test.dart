import 'package:flutter_test/flutter_test.dart';

bool isPetAvailable(String status) {
  return status.toLowerCase() == 'available';
}

void main() {
  test('Pet should be available if status is "available"', () {
    expect(isPetAvailable('available'), true);
    expect(isPetAvailable('adopted'), false);
    expect(isPetAvailable('Available'), true);
  });
}
