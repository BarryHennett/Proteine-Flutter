import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:typed_data';

import 'package:proteine_flutter/repository/client/extensions.dart';

const String contentType = "application/json";

class APIClient {
  APIClient._internal(this.baseUrl, this._client, this.basePath, this._https);

  factory APIClient(
      {required String baseUrl, http.BaseClient? client, String? basePath}) {
    final rawClient = client ?? http.Client();

    return APIClient.fromClient(
        baseUrl: baseUrl, client: rawClient as http.BaseClient, basePath: basePath);
  }

  factory APIClient.fromClient(
      {required String baseUrl,
      required http.BaseClient client,
      String? basePath}) {
    bool https = true;
    if (baseUrl.startsWith("https://")) {
      baseUrl = baseUrl.replaceFirst("https://", "");
    } else if (baseUrl.startsWith("http://")) {
      baseUrl = baseUrl.replaceFirst("http://", "");
      https = false;
    }

    if (baseUrl.endsWith("/")) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }

    //Trigger the Uri asserts
    Uri.https(baseUrl, "/");

    String prePath = basePath ?? "";
    if (prePath.isNotEmpty && !prePath.startsWith("/")) {
      prePath = "/$prePath";
    }

    return APIClient._internal(baseUrl, client, prePath, https);
  }

  final http.BaseClient _client;
  final String baseUrl;
  final String basePath;
  final bool _https;

  Future Function(Map<String, String>)? headerInterceptor;

  Future<Map<String, String>> _buildHeaders(
      Map<String, String>? headers) async {
    final result = <String, String>{};
    if (headers != null) {
      result.addAll(headers);
    }
    await headerInterceptor?.call(result);
    return result;
  }

  String _buildPath(String path) {
    if (!path.startsWith("/")) {
      path = "/$path";
    }

    return "$basePath$path";
  }

  Uri _buildUri(String path, [Map<String, dynamic>? params]) {
    if (_https) {
      return Uri.https(baseUrl, _buildPath(path), params);
    } else {
      return Uri.http(baseUrl, _buildPath(path), params);
    }
  }

  Future<ClientResponse> get(String path,
      [Map<String, dynamic>? params, Map<String, String>? headers]) async {
    print("GET $path");
    return _client
        .get(_buildUri(path, params), headers: await _buildHeaders(headers))
        .then((value) => ClientResponse._internal(value))
        .catchError(_onError);
  }

  Future<ClientResponse> delete(String path,
      [Map<String, dynamic>? params, Map<String, String>? headers]) async {
    print("DELETE $path");
    return _client
        .delete(_buildUri(path, params), headers: await _buildHeaders(headers))
        .then((value) => ClientResponse._internal(value))
        .catchError(_onError);
  }

  Future<ClientResponse> put(String path,
      [Map<String, dynamic>? params, Map<String, String>? headers]) async {
    print("PUT $path");
    headers = await _buildHeaders(headers);
    headers['Content-Type'] = contentType;

    return _client
        .put(_buildUri(path), body: jsonEncode(params), headers: headers)
        .then((value) => ClientResponse._internal(value))
        .catchError(_onError);
  }

  Future<ClientResponse> post(String path,
      [Map<String, dynamic>? params, Map<String, String>? headers]) async {
    print("POST $path");

    headers = await _buildHeaders(headers);
    headers['Content-Type'] = contentType;

    return _client
        .post(_buildUri(path),
            body: params == null ? null : jsonEncode(params), headers: headers)
        .then((value) => ClientResponse._internal(value))
        .catchError(_onError);
  }

  Future<ClientResponse> postFiles(String path, List<http.MultipartFile> files,
      [Map<String, String>? headers]) async {
    headers = await _buildHeaders(headers);

    var request = http.MultipartRequest("POST", Uri.https(baseUrl, path));
    request.headers.addAll(headers);
    request.files.addAll(files);
    var streamedResponse = await _client.send(request);
    var response = await http.Response.fromStream(streamedResponse);

    return ClientResponse._internal(response);
  }

  ClientResponse _onError(dynamic error) {
    print("API Error... ${error}");
    final body = json.encode(
        {'success': false, 'message': "Something went wrong", 'data': {}});
    return ClientResponse._internal(http.Response(body, 502));
  }
}

class ClientResponse extends http.BaseResponse {
  ClientResponse._internal(this._base)
      : super(_base.statusCode,
            contentLength: _base.contentLength,
            request: _base.request,
            headers: _base.headers,
            isRedirect: _base.isRedirect,
            persistentConnection: _base.persistentConnection,
            reasonPhrase: _base.reasonPhrase);



  final http.Response _base;

  bool get isSuccess => json.opt("code", statusCode) < 400;

  String get body => _base.body;

  Uint8List get bodyBytes => _base.bodyBytes;

  /// Parses the body to a json [Map]
  Map<String, dynamic> get json {
    try {
      return jsonDecode(body);
    } catch (e) {
      return <String, dynamic>{};
    }
  }

  Map<String, dynamic> get data => json.opt("data", {});

  /// Parses the body to a json [List]
  List<dynamic> get jsonArray {
    try {
      return jsonDecode(body);
    } catch (e) {
      return List.empty();
    }
  }
}
