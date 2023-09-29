// Native Wallet
export './native_api_client/unsupported.dart'
    if (dart.library.io) 'native_api_client/mobile.dart'
    if (dart.library.html) 'native_api_client/web.dart';
// Web Wallet
export './wallet_api_client/unsupported.dart'
    if (dart.library.html) './wallet_api_client/web.dart'
    if (dart.library.io) './wallet_api_client/mobile.dart';
export 'failures/failures.dart';
// MagicSDK
export 'magic_api_client/javascript_calls/magic.dart';
// Magic Wallet
export 'magic_api_client/unsupported.dart'
    if (dart.library.io) 'magic_api_client/mobile.dart' //If mobile export mobile
    if (dart.library.html) 'magic_api_client/web.dart'; //If web export web
export 'models/models.dart' hide ChainConfigX;
export 'wallet_api_client/wallet_api_client.dart';
