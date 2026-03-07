import 'dart:io';
import 'package:http/http.dart' as http;

/// Contract for making HTTP and multipart API requests.
abstract class WebApiService {
  /// Sends an HTTP request with the given [method] to the specified [url].
  Future<http.Response> request({
    required String url,
    required String method,
    Map<String, String>? headers,
    Object? body,
  });

  /// Sends a multipart POST request with [fields] and [files]
  ///  to the given [url].
  Future<http.StreamedResponse> multipartPost({
    required String url,
    required Map<String, String> fields,
    required Map<String, File> files,
    Map<String, String>? headers,
  });
}
