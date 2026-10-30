# Amal Tracker

Flutter app (Android + iOS). **Step 1: foundation** (theme, shell, EN/BN, fonts, settings). **Step 2** (local SQLite storage, nafl prayer tracking, tasbeeh counter, live Home stats).

## Get the APK without installing anything (GitHub Actions)
1. Create a new GitHub repo and push this folder to the `main` branch.
2. Open the repo, then **Actions → Build APK → (latest run)**.
3. Download the `amal-tracker-apk` artifact, unzip, and install `app-release.apk` on your phone.

## Build locally
```bash
# needs Flutter (stable) + Android SDK
bash setup.sh                 # generates android/ios folders, fetches packages
flutter run                   # run on a device/emulator
flutter build apk --release   # build/app/outputs/flutter-apk/app-release.apk
```
(Windows without bash: run the commands inside `setup.sh` one by one.)
