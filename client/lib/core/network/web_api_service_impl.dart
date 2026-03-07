import 'dart:io';

import 'package:client/core/network/web_api_service.dart';
import 'package:http/http.dart' as http;

/// Concrete implementation of [WebApiService] using the http package.
class WebApiServiceImpl implements WebApiService {
  /// Creates a WebApiServiceImpl with the provided HTTP [client].
  WebApiServiceImpl(this.client);

  /// HTTP client used to perform network requests.
  final http.Client client;

  @override
  Future<http.Response> request({
    required String url,
    required String method,
    Map<String, String>? headers,
    Object? body,
  }) {
    final uri = Uri.parse(url);

    switch (method.toUpperCase()) {
      case 'GET':
        return client.get(uri, headers: headers);

      case 'POST':
        return client.post(uri, headers: headers, body: body);

      case 'PUT':
        return client.put(uri, headers: headers, body: body);

      case 'PATCH':
        return client.patch(uri, headers: headers, body: body);

      case 'DELETE':
        return client.delete(uri, headers: headers, body: body);

      default:
        throw UnsupportedError('HTTP method $method is not supported.');
    }
  }

  @override
  Future<http.StreamedResponse> multipartPost({
    required String url,
    required Map<String, String> fields,
    required Map<String, File> files,
    Map<String, String>? headers,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields.addAll(fields);

    for (final entry in files.entries) {
      request.files.add(
        await http.MultipartFile.fromPath(entry.key, entry.value.path),
      );
    }

    if (headers != null) {
      request.headers.addAll(headers);
    }

    return request.send();
  }
}
