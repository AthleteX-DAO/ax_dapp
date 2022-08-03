/// [String] extensions.
extension StringX on String {
  /// Capitalizes a [String].
  String capitalize() =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}
