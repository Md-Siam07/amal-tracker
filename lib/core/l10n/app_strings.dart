import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Lightweight localization (English + Bangla). No code generation needed.
/// Add a key to BOTH maps; a unit test guards against missing translations.
class AppStrings {
  AppStrings(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('bn')];
  static const LocalizationsDelegate<AppStrings> delegate =
      _AppStringsDelegate();

  static AppStrings of(BuildContext context) =>
      Localizations.of<AppStrings>(context, AppStrings)!;

  /// Keys present in English but missing in Bangla (used by tests).
  static Set<String> missingInBangla() =>
      _en.keys.toSet().difference(_bn.keys.toSet());

  String t(String key) {
    final table = locale.languageCode == 'bn' ? _bn : _en;
    return table[key] ?? _en[key] ?? key;
  }

  /// Replaces {placeholders} in a translated string.
  String fmt(String key, Map<String, String> args) {
    var out = t(key);
    args.forEach((k, v) => out = out.replaceAll('{$k}', v));
    return out;
  }

  String get appName => t('appName');
  String get home => t('home');
  String get amal => t('amal');
  String get duas => t('duas');
  String get reminders => t('reminders');
  String get profile => t('profile');
  String get greeting => t('greeting');
  String get todaysGoals => t('todaysGoals');
  String get previewNote => t('previewNote');
  String get quickActions => t('quickActions');
  String get nextReminder => t('nextReminder');
  String get noReminders => t('noReminders');
  String get logPrayer => t('logPrayer');
  String get tasbeeh => t('tasbeeh');
  String get bookmark => t('bookmark');
  String get addDua => t('addDua');
  String get prayer => t('prayer');
  String get quran => t('quran');
  String get comingSoon => t('comingSoon');
  String get prayerBody => t('prayerBody');
  String get quranBody => t('quranBody');
  String get tasbeehBody => t('tasbeehBody');
  String get duasBody => t('duasBody');
  String get remindersBody => t('remindersBody');
  String get appearance => t('appearance');
  String get theme => t('theme');
  String get language => t('language');
  String get light => t('light');
  String get dark => t('dark');
  String get system => t('system');
  String get account => t('account');
  String get signInSoon => t('signInSoon');
  String get about => t('about');
  String get version => t('version');
  String get tapToLog => t('tapToLog');
  String get customChip => t('customChip');
  String get statToday => t('statToday');
  String get statRakats => t('statRakats');
  String get statLast7 => t('statLast7');
  String get statPrayers => t('statPrayers');
  String get history => t('history');
  String get noHistory => t('noHistory');
  String get undo => t('undo');
  String get deleted => t('deleted');
  String get addCustomPrayer => t('addCustomPrayer');
  String get name => t('name');
  String get defaultRakats => t('defaultRakats');
  String get cancel => t('cancel');
  String get save => t('save');
  String get add => t('add');
  String get dateTime => t('dateTime');
  String get note => t('note');
  String get customPrayerFallback => t('customPrayerFallback');
  String get tapToCount => t('tapToCount');
  String get target => t('target');
  String get targetReached => t('targetReached');
  String get saveSession => t('saveSession');
  String get reset => t('reset');
  String get sessionSaved => t('sessionSaved');
  String get tasbeehTotal => t('tasbeehTotal');
  String get newDhikr => t('newDhikr');
  String get dhikrText => t('dhikrText');
  String get targetCount => t('targetCount');
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppStrings.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) =>
      SynchronousFuture<AppStrings>(AppStrings(locale));

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}

const Map<String, String> _en = {
  'appName': 'Amal Tracker',
  'home': 'Home',
  'amal': 'Amal',
  'duas': 'Duas',
  'reminders': 'Reminders',
  'profile': 'Profile',
  'greeting': 'Assalamu Alaikum',
  'todaysGoals': "Today's Goals",
  'previewNote': 'Targets are temporary defaults. Custom goals arrive in a later step.',
  'quickActions': 'Quick Actions',
  'nextReminder': 'Next Reminder',
  'noReminders': 'No reminders yet',
  'logPrayer': 'Log Prayer',
  'tasbeeh': 'Tasbeeh',
  'bookmark': 'Bookmark',
  'addDua': 'Add Dua',
  'prayer': 'Prayer',
  'quran': 'Quran',
  'comingSoon': 'Coming soon',
  'prayerBody': 'Log your nafl prayers and see your counts here.',
  'quranBody': 'Save Quran bookmarks and count your khatm.',
  'tasbeehBody': 'A tap counter with goals and history.',
  'duasBody': 'Paste duas in any language and group them for reminders.',
  'remindersBody': 'Hourly, daily or weekly reminders in your own words.',
  'appearance': 'Appearance',
  'theme': 'Theme',
  'language': 'Language',
  'light': 'Light',
  'dark': 'Dark',
  'system': 'System',
  'account': 'Account',
  'signInSoon': 'Email sign-in arrives in a later step.',
  'about': 'About',
  'version': 'Version',
  'tapToLog': 'Tap to log a prayer. Hold for details.',
  'customChip': 'Custom',
  'statToday': 'Today',
  'statRakats': 'Rakats',
  'statLast7': 'Last 7 days',
  'statPrayers': 'Prayers',
  'history': 'History',
  'noHistory': 'Nothing logged yet.',
  'prayerLogged': '{name} logged',
  'undo': 'Undo',
  'deleted': 'Deleted',
  'rakatsCount': '{n} rakats',
  'addCustomPrayer': 'New custom prayer',
  'name': 'Name',
  'defaultRakats': 'Rakats',
  'cancel': 'Cancel',
  'save': 'Save',
  'add': 'Add',
  'dateTime': 'Date & time',
  'note': 'Note (optional)',
  'customPrayerFallback': 'Custom prayer',
  'tapToCount': 'Tap to count',
  'target': 'Target',
  'targetReached': 'Target reached. MashaAllah!',
  'saveSession': 'Save session',
  'reset': 'Reset',
  'sessionSaved': 'Session saved',
  'tasbeehTotal': 'Total count',
  'newDhikr': 'New dhikr',
  'dhikrText': 'Dhikr text (any language)',
  'targetCount': 'Target count',
  'prayer_tahajjud': 'Tahajjud',
  'prayer_ishraq': 'Ishraq',
  'prayer_duha': 'Duha',
  'prayer_awwabin': 'Awwabin',
  'prayer_tahiyyatul_wudu': 'Tahiyyatul Wudu',
  'prayer_tahiyyatul_masjid': 'Tahiyyatul Masjid',
  'prayer_tawbah': 'Salat al-Tawbah',
  'prayer_hajah': 'Salat al-Hajah',
  'prayer_witr': 'Witr',
  'prayer_taraweeh': 'Taraweeh',
  'prayer_sunnah_fajr': 'Sunnah of Fajr',
  'prayer_sunnah_dhuhr': 'Sunnah of Dhuhr',
  'prayer_sunnah_maghrib': 'Sunnah of Maghrib',
  'prayer_sunnah_isha': 'Sunnah of Isha',
  'dhikr_subhanallah': 'SubhanAllah',
  'dhikr_alhamdulillah': 'Alhamdulillah',
  'dhikr_allahuakbar': 'Allahu Akbar',
  'dhikr_la_ilaha': 'La ilaha illallah',
  'dhikr_astaghfirullah': 'Astaghfirullah',
  'dhikr_salawat': 'Salawat',
};

const Map<String, String> _bn = {
  'appName': 'আমল ট্র্যাকার',
  'home': 'হোম',
  'amal': 'আমল',
  'duas': 'দোয়া',
  'reminders': 'রিমাইন্ডার',
  'profile': 'প্রোফাইল',
  'greeting': 'আসসালামু আলাইকুম',
  'todaysGoals': 'আজকের লক্ষ্য',
  'previewNote': 'লক্ষ্যগুলো সাময়িক ডিফল্ট। কাস্টম লক্ষ্য পরবর্তী ধাপে আসছে।',
  'quickActions': 'দ্রুত কাজ',
  'nextReminder': 'পরবর্তী রিমাইন্ডার',
  'noReminders': 'এখনও কোনো রিমাইন্ডার নেই',
  'logPrayer': 'নামাজ লিখুন',
  'tasbeeh': 'তাসবীহ',
  'bookmark': 'বুকমার্ক',
  'addDua': 'দোয়া যোগ',
  'prayer': 'নামাজ',
  'quran': 'কুরআন',
  'comingSoon': 'শীঘ্রই আসছে',
  'prayerBody': 'আপনার নফল নামাজ লিখুন এবং এখানে গণনা দেখুন।',
  'quranBody': 'কুরআনের বুকমার্ক সংরক্ষণ করুন এবং খতম গণনা করুন।',
  'tasbeehBody': 'লক্ষ্য ও ইতিহাসসহ একটি ট্যাপ কাউন্টার।',
  'duasBody': 'যেকোনো ভাষায় দোয়া পেস্ট করুন এবং রিমাইন্ডারের জন্য গ্রুপ করুন।',
  'remindersBody': 'আপনার নিজের কথায় ঘণ্টাভিত্তিক, দৈনিক বা সাপ্তাহিক রিমাইন্ডার।',
  'appearance': 'চেহারা',
  'theme': 'থিম',
  'language': 'ভাষা',
  'light': 'লাইট',
  'dark': 'ডার্ক',
  'system': 'সিস্টেম',
  'account': 'অ্যাকাউন্ট',
  'signInSoon': 'ইমেইল সাইন-ইন পরবর্তী ধাপে আসছে।',
  'about': 'সম্পর্কে',
  'version': 'ভার্সন',
  'tapToLog': 'নামাজ লিখতে ট্যাপ করুন। বিস্তারিত দিতে চেপে ধরুন।',
  'customChip': 'কাস্টম',
  'statToday': 'আজ',
  'statRakats': 'রাকাত',
  'statLast7': 'গত ৭ দিন',
  'statPrayers': 'নামাজ',
  'history': 'ইতিহাস',
  'noHistory': 'এখনও কিছু লেখা হয়নি।',
  'prayerLogged': '{name} লেখা হয়েছে',
  'undo': 'ফিরিয়ে আনুন',
  'deleted': 'মুছে ফেলা হয়েছে',
  'rakatsCount': '{n} রাকাত',
  'addCustomPrayer': 'নতুন কাস্টম নামাজ',
  'name': 'নাম',
  'defaultRakats': 'রাকাত',
  'cancel': 'বাতিল',
  'save': 'সংরক্ষণ',
  'add': 'যোগ করুন',
  'dateTime': 'তারিখ ও সময়',
  'note': 'নোট (ঐচ্ছিক)',
  'customPrayerFallback': 'কাস্টম নামাজ',
  'tapToCount': 'গণনা করতে ট্যাপ করুন',
  'target': 'লক্ষ্য',
  'targetReached': 'লক্ষ্যে পৌঁছেছেন। মাশাআল্লাহ!',
  'saveSession': 'সেশন সংরক্ষণ',
  'reset': 'রিসেট',
  'sessionSaved': 'সেশন সংরক্ষিত হয়েছে',
  'tasbeehTotal': 'মোট গণনা',
  'newDhikr': 'নতুন যিকির',
  'dhikrText': 'যিকিরের লেখা (যেকোনো ভাষা)',
  'targetCount': 'লক্ষ্য সংখ্যা',
  'prayer_tahajjud': 'তাহাজ্জুদ',
  'prayer_ishraq': 'ইশরাক',
  'prayer_duha': 'চাশত',
  'prayer_awwabin': 'আওয়াবীন',
  'prayer_tahiyyatul_wudu': 'তাহিয়্যাতুল ওযু',
  'prayer_tahiyyatul_masjid': 'তাহিয়্যাতুল মসজিদ',
  'prayer_tawbah': 'সালাতুত তাওবা',
  'prayer_hajah': 'সালাতুল হাজত',
  'prayer_witr': 'বিতর',
  'prayer_taraweeh': 'তারাবীহ',
  'prayer_sunnah_fajr': 'ফজরের সুন্নাত',
  'prayer_sunnah_dhuhr': 'যোহরের সুন্নাত',
  'prayer_sunnah_maghrib': 'মাগরিবের সুন্নাত',
  'prayer_sunnah_isha': 'ইশার সুন্নাত',
  'dhikr_subhanallah': 'সুবহানাল্লাহ',
  'dhikr_alhamdulillah': 'আলহামদুলিল্লাহ',
  'dhikr_allahuakbar': 'আল্লাহু আকবার',
  'dhikr_la_ilaha': 'লা ইলাহা ইল্লাল্লাহ',
  'dhikr_astaghfirullah': 'আসতাগফিরুল্লাহ',
  'dhikr_salawat': 'দরূদ',
};
