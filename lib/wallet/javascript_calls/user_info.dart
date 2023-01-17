@JS()
library userinfo;

import 'package:js/js.dart';

@anonymous
@JS()
abstract class UserInfo {
  external factory UserInfo({
    String email,
    String name,
    String profileImage,
    String aggregateVerifier,
    String verifier,
    String verifierId,
    String dappShare,
    String? idToken,
    String? oAuthIdToken,
    String? oAuthAccessToken,
  });
  external String get email;
  external set email(String value);
  external String get name;
  external set name(String value);
  external String get profileImage;
  external set profileImage(String value);
  external String get verifier;
  external set verifier(String value);
  external String get dappShare;
  external set dappShare(String value);
  external String get idToken;
  external set idToken(String value);
  external String get oAuthIdToken;
  external set oAuthIdToken(String value);
  external String get oAuthAccessToken;
  external set oAuthAccessToken(String value);
}
