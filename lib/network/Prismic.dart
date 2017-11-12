import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

const String _kEndpoint = "https://ulicastefankowa.prismic.io/api/v2";
const String _kYesIKnow_willChange = "MC5XZ1hlYWlnQUFGb0stWmZr.77-9Vi1_Du-_ve-_ve-_ve-_vUkO77-977-9Ou-_ve-_ve-_vWPvv73vv73vv73vv73vv71777-9dSbvv71ube-_ve-_vQ";

class Prismic {

  http.Client _client;

  Prismic() {
    _client = createHttpClient();
  }

  Observable<dynamic> get(String path) {
    return new Observable.fromFuture(_client.get(
        "$_kEndpoint$path", headers: {
      "accessToken": _kYesIKnow_willChange
    }
    ));
  }

  Observable<dynamic> getPosts() {
    return _getMasterReference().flatMap((ref) =>
        get("/documents/search?ref=$ref#format=json"))
        .map((response) => JSON.decode(response.body));
  }

  Observable<String> _getMasterReference() {
    return get("")
        .map((it)  => JSON.decode(it.body)["refs"].first["ref"]);
  }
}