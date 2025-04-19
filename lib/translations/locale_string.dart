import 'package:get/get.dart';
import 'en.dart';
import 'ar.dart';

class LocaleString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en,
        'ar_SA': ar,
      };
}
