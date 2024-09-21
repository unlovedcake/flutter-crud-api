import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class PostRepository {
  static const String baseUrl = 'https://api.nstack.in/v1/todos';
  //'https://jsonplaceholder.typicode.com';

  static Future<List<dynamic>> get(String endpoint) async {

    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
        log('Posts:'+ json.decode(response.body)['meta']['has_more_page'].toString());
      return json.decode(response.body)['items'];
     
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<dynamic> post(dynamic data) async {
    final response = await http.post(Uri.parse('$baseUrl/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));
    if (response.statusCode == 201) {
      print('Post Added');

      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to create data');
    }
  }

  static Future<dynamic> put(String id, dynamic data) async {
    final response =
        await http.put(Uri.parse('https://api.nstack.in/v1/todos/$id'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(data));

    if (response.statusCode == 200) {
      print('Post Updated');
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to update data');
    }
  }

  static Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['items'];
    } else {
      throw Exception('Failed to delete data');
    }
  }
}
