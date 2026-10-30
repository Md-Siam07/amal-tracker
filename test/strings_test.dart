import 'package:amal_tracker/core/l10n/app_strings.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every English string has a Bangla translation', () {
    expect(AppStrings.missingInBangla(), isEmpty);
  });

  test('locale switches the returned text', () {
    expect(AppStrings(const Locale('en')).home, 'Home');
    expect(AppStrings(const Locale('bn')).home, 'হোম');
  });
}
