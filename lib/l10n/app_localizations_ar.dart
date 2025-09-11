// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'نيني صحة';

  @override
  String helloDoctor(Object firstName) {
    return 'مرحباً د. $firstName';
  }

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get patients => 'المرضى';

  @override
  String get ai => 'الذكاء الاصطناعي';

  @override
  String get alerts => 'التنبيهات';

  @override
  String get reports => 'التقارير';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get darkTheme => 'الوضع الداكن';

  @override
  String get notifications => 'تفعيل الإشعارات';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get logoutAction => 'تسجيل الخروج';
}
