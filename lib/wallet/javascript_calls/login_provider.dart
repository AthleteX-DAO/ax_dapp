@JS()
library loginprovider;

import 'package:js/js.dart';

@anonymous
@JS()
abstract class LoginProvider {
  external factory LoginProvider({
    String loginProvider,
  });
  external String get loginProvider;
  external set loginProvider(String value);
}
