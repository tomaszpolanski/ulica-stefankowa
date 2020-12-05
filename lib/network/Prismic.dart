import 'dart:convert';

import 'package:http/http.dart' as http;

const String _kEndpoint = "https://ulicastefankowa.prismic.io/api/v2";
const String _kYesIKnow_willChange =
    "MC5XZ1hlYWlnQUFGb0stWmZr.77-9Vi1_Du-_ve-_ve-_ve-_vUkO77-977-9Ou-_ve-_ve-_vWPvv73vv73vv73vv73vv71777-9dSbvv71ube-_ve-_vQ";

abstract class Prismic {
  Future<dynamic> getPosts();
}

class PrismicImpl extends Prismic {
  Future<dynamic> _get(String path) {
    print('QQQ ${"$_kEndpoint$path&access_token=$_kYesIKnow_willChange"}');
    print('QQQ2 ${path}');
    return http.get("$_kEndpoint$path&access_token=$_kYesIKnow_willChange",
        headers: {"access_token": _kYesIKnow_willChange});
  }

  @override
  Future<dynamic> getPosts() async {
    final ref = _getMasterReference();
    final response = await _get("/documents/search?ref=$ref#format=json");
    return json.decode(response.body);
  }

  Future<String> _getMasterReference() async {
    final it = await http.get("$_kEndpoint/v2");
    print('QQQ3 ${it.body}');
    return json.decode(it.body)["refs"].first["ref"];
  }
}
