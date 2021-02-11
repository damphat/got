import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  test('Get is instance', () {
    expect(Get, isA<GetMain>());
  });

  test('Get is singleton', () {
    expect(Get, same(Get));
    expect(Get, same(GetMain()));
  });
}
