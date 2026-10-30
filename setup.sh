#!/usr/bin/env bash
# One-time project bootstrap: generates android/ios folders around our lib/ code.
set -e
if [ ! -d android ]; then
  flutter create --org com.amaltracker --project-name amal_tracker --platforms=android,ios .
fi
rm -f test/widget_test.dart
sed -i.bak 's/android:label="[^"]*"/android:label="Amal Tracker"/' android/app/src/main/AndroidManifest.xml
rm -f android/app/src/main/AndroidManifest.xml.bak
flutter pub get
