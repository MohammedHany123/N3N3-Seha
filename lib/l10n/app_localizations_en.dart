// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'N3N3 Seha';

  @override
  String helloDoctor(Object firstName) {
    return 'Hello, Dr. $firstName';
  }

  @override
  String get logout => 'Logout';

  @override
  String get patients => 'Patients';

  @override
  String get ai => 'AI';

  @override
  String get alerts => 'Alerts';

  @override
  String get reports => 'Reports';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get notifications => 'Enable Notifications';

  @override
  String get changePassword => 'Change Password';

  @override
  String get logoutAction => 'Logout';
}
