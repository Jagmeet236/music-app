/// Contract for managing local data operations specific to the home feature.
abstract class HomeLocalDatasource {
  /// Returns the stored authentication token.
  String? getToken();

  /// Asynchronously retrieves the stored authentication token.
  Future<String?> getTokenAsync();
}
