@JS()
library web3auth;

// The above two lines are required
import 'package:js/js.dart';

@JS()
class Web3Auth {
  external Web3Auth(String name);
  external dynamic initModal();
  external dynamic connect();
  external dynamic logout();
  external dynamic getUserInfo();
}
