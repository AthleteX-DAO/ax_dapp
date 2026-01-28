import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ax_dapp/perps/models/perps_order_model.dart';

/// Service for persisting and retrieving orders from local cache
/// Uses SharedPreferences for client-side storage of order history
class PerpsOrderCacheService {
  static const String _openOrdersKey = 'perps_open_orders';
  static const String _orderHistoryKey = 'perps_order_history';
  static const String _tradeHistoryKey = 'perps_trade_history';

  final SharedPreferences _preferences;

  PerpsOrderCacheService(this._preferences);

  /// Save an open order to cache
  Future<void> saveOpenOrder(PerpsOrderModel order) async {
    final orders = await getOpenOrders();
    orders.add(order);
    await _preferences.setString(
      _openOrdersKey,
      jsonEncode(orders.map((o) => o.toJson()).toList()),
    );
  }

  /// Save multiple open orders
  Future<void> saveOpenOrders(List<PerpsOrderModel> orders) async {
    await _preferences.setString(
      _openOrdersKey,
      jsonEncode(orders.map((o) => o.toJson()).toList()),
    );
  }

  /// Retrieve all open orders from cache
  Future<List<PerpsOrderModel>> getOpenOrders() async {
    final json = _preferences.getString(_openOrdersKey);
    if (json == null) return [];

    try {
      final List<dynamic> decoded = (jsonDecode(json) as List<dynamic>);
      return decoded
          .map((item) => PerpsOrderModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error decoding open orders: $e');
      return [];
    }
  }

  /// Remove a specific open order by orderId
  Future<void> removeOpenOrder(String orderId) async {
    final orders = await getOpenOrders();
    orders.removeWhere((o) => o.orderId == orderId);
    await _preferences.setString(
      _openOrdersKey,
      jsonEncode(orders.map((o) => o.toJson()).toList()),
    );
  }

  /// Clear all open orders
  Future<void> clearOpenOrders() async {
    await _preferences.remove(_openOrdersKey);
  }

  /// Save a trade to order history (persists closed/settled trades)
  Future<void> saveTradeToHistory(PerpsOrderModel trade) async {
    final history = await getOrderHistory();
    history.add(trade);
    // Keep only last 1000 trades to avoid excessive storage
    if (history.length > 1000) {
      history.removeRange(0, history.length - 1000);
    }
    await _preferences.setString(
      _orderHistoryKey,
      jsonEncode(history.map((t) => t.toJson()).toList()),
    );
  }

  /// Retrieve order history with pagination
  Future<List<PerpsOrderModel>> getOrderHistory({
    int offset = 0,
    int limit = 25,
  }) async {
    final json = _preferences.getString(_orderHistoryKey);
    if (json == null) return [];

    try {
      final List<dynamic> decoded = (jsonDecode(json) as List<dynamic>);
      final orders = decoded
          .map((item) => PerpsOrderModel.fromJson(item as Map<String, dynamic>))
          .toList();

      // Return paginated results (most recent first)
      final reversed = orders.reversed.toList();
      final endIndex = (offset + limit).clamp(0, reversed.length);
      return reversed.sublist(offset, endIndex);
    } catch (e) {
      print('Error decoding order history: $e');
      return [];
    }
  }

  /// Get total count of order history (for pagination)
  Future<int> getOrderHistoryCount() async {
    final json = _preferences.getString(_orderHistoryKey);
    if (json == null) return 0;

    try {
      final List<dynamic> decoded = (jsonDecode(json) as List<dynamic>);
      return decoded.length;
    } catch (e) {
      print('Error getting order history count: $e');
      return 0;
    }
  }

  /// Retrieve trade history with pagination
  Future<List<PerpsOrderModel>> getTradeHistory({
    int offset = 0,
    int limit = 25,
  }) async {
    final json = _preferences.getString(_tradeHistoryKey);
    if (json == null) return [];

    try {
      final List<dynamic> decoded = (jsonDecode(json) as List<dynamic>);
      final trades = decoded
          .map((item) => PerpsOrderModel.fromJson(item as Map<String, dynamic>))
          .toList();

      // Return paginated results (most recent first)
      final reversed = trades.reversed.toList();
      final endIndex = (offset + limit).clamp(0, reversed.length);
      return reversed.sublist(offset, endIndex);
    } catch (e) {
      print('Error decoding trade history: $e');
      return [];
    }
  }

  /// Get total count of trade history (for pagination)
  Future<int> getTradeHistoryCount() async {
    final json = _preferences.getString(_tradeHistoryKey);
    if (json == null) return 0;

    try {
      final List<dynamic> decoded = (jsonDecode(json) as List<dynamic>);
      return decoded.length;
    } catch (e) {
      print('Error getting trade history count: $e');
      return 0;
    }
  }

  /// Save a trade to trade history
  Future<void> saveTradeToTradeHistory(PerpsOrderModel trade) async {
    final history = await getTradeHistory();
    history.add(trade);
    // Keep only last 500 trades
    if (history.length > 500) {
      history.removeRange(0, history.length - 500);
    }
    await _preferences.setString(
      _tradeHistoryKey,
      jsonEncode(history.map((t) => t.toJson()).toList()),
    );
  }

  /// Clear all cached data
  Future<void> clearAllCache() async {
    await Future.wait([
      _preferences.remove(_openOrdersKey),
      _preferences.remove(_orderHistoryKey),
      _preferences.remove(_tradeHistoryKey),
    ]);
  }
}
