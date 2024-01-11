import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiService {
  final http.Client client;

  NewsApiService(this.client);

  Future<void> fetchArticle() async {
    final uri = Uri.parse('https://odoo.ycfitness.xyz/v2/api/login');
    try {
      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "jsonrpc": "2.0",
          "params": {"phone": "admin", "password": "admin"}
        }),
      );

      if (response.statusCode == 200) {
        print("Successful response:");
        print(json.decode(response.body));
        // return json.decode(response.body);
      } else {
        print("Failed response: ${response.statusCode}");
        print(response.body);
        // Handle the error accordingly
      }
    } catch (error) {
      print("Error during HTTP request: $error");
      // Handle the error accordingly
      throw error;
    }
  }
}
