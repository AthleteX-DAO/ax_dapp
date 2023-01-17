@JS()
library userinfo;

import 'package:ax_dapp/wallet/javascript_calls/login_provider.dart';
import 'package:js/js.dart';

@JS()
class UserInfo {
  external factory UserInfo({
    String email,
    String name,
    String profileImage,
    String aggregateVerifier,
    String verifier,
    String verifierId,
    String dappShare,
    LoginProvider? typeOfLogin,
    String? idToken,
    String? oAuthIdToken,
    String? oAuthAccessToken,
  });
}
