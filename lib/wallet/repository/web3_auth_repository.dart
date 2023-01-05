import 'package:ax_dapp/wallet/javascript_calls/web3_auth.dart';
import 'package:ax_dapp/wallet/models/models.dart';
import 'package:flutter/foundation.dart';

class Web3AuthRepository {
  Web3AuthRepository({required Web3Auth web3auth}) : _web3Auth = web3Auth;
  final Web3Auth _web3Auth;

  /// [connect] will allow the user to connect with a provider using web3Auth
  /// It will return a [User] if the connection is successful
  /// Otherwise, it will return an empty [User] if the connection fails
  Future<dynamic> connect() async {
    try {
      await _web3Auth.connect();
      var user = getUserInfo();
      return user;
    } catch (e) {
      debugPrint('user cannot connect to the app');
      return user.empty();
    }
  }

  /// [logout] will sign the [User] out of the profile
  void logout() {
    _web3Auth.logout();
  }

  /// [getUserInfo] will retrieve the user information when the user logs in 
  /// using web3. It will return a [User].
  dynamic getUserInfo() {
    return _web3Auth.getUserInfo();
  }
}
