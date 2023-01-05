import 'package:flutter/foundation.dart';
import 'package:ax_dapp/web/libraries/web3auth.dart';

// TODO(kevin): create a User class that will store user information

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

  /// [logout] will allow the user to signout from their web2 profile
  void logout() {
    _web3Auth.logOut();
  }

  /// [getUserInfo] will retrieve the user information when the user logs in 
  /// using web3. It will return a [User].
  dynamic getUserInfo() {
    return _web3Auth.getUserInfo();
  }
}
