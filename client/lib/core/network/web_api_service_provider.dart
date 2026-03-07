import 'package:client/core/network/web_api_service.dart';
import 'package:client/core/network/web_api_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// Provides a singleton instance of [WebApiService] for dependency injection.
final webApiServiceProvider = Provider<WebApiService>((ref) {
  return WebApiServiceImpl(http.Client());
});
