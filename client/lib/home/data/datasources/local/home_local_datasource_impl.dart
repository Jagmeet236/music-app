import 'package:client/home/data/datasources/local/home_local_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_local_datasource_impl.g.dart';

/// Riverpod provider for [HomeLocalDatasource].
@Riverpod(keepAlive: true)
HomeLocalDatasource homeLocalDatasource(HomeLocalDatasourceRef ref) {
  return HomeLocalDatasourceImpl();
}

/// Implementation of [HomeLocalDatasource] using SharedPreferences.
class HomeLocalDatasourceImpl implements HomeLocalDatasource {
  late SharedPreferences _sharedPreferences;
  bool _isInitialized = false;

  /// Ensures SharedPreferences is initialized before fetching the token
  Future<void> _init() async {
    if (!_isInitialized) {
      _sharedPreferences = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  /// Retrieves stored authentication token.
  @override
  String? getToken() {
    if (!_isInitialized) {
      // SharedPreferences should ideally be synchronously available 
      // if already initialized upstream, but just in case, this is an 
      // abstraction layer. The real token must be fetched cleanly.
      return null;
    }
    return _sharedPreferences.getString('x-auth-token');
  }

  /// Asynchronously retrieves stored authentication token (safe wrapper).
  @override
  Future<String?> getTokenAsync() async {
    await _init();
    return _sharedPreferences.getString('x-auth-token');
  }
}
