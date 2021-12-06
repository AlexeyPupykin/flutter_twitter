import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  Future<http.Response> addComment(String comment, int idPost) {
    return http.post(
      Uri.parse(
          'https://jsonplaceholder.typicode.com/albums'), //here url for add comment
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'comment': comment, 'idPost': idPost.toString()}),
    );
  }
}
