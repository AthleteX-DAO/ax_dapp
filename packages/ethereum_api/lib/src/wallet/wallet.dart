export './wallet_api_client/unsupported.dart'
    if (dart.library.html) './wallet_api_client/web.dart'
    if (dart.library.io) './wallet_api_client/mobile.dart';
export 'failures/failures.dart';
export 'models/models.dart' hide ChainConfigX;
export 'wallet_api_client/wallet_api_client.dart';
