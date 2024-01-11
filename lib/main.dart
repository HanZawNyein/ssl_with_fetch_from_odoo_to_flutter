import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class NewsApiService {
  final http.Client client;

  NewsApiService(this.client);

  Future<void> fetchArticle() async {
    try {
      final uri = Uri.parse('https://yourdomain.com/login');
      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "jsonrpc": "2.0",
          "params": {"phone": "xxx", "password": "xxx"}
        }),
      );

      if (response.statusCode == 200) {
        print("Successful response:");
        print(json.decode(response.body));
        // Handle success (e.g., navigate to the next screen)
      } else {
        print("Failed response: ${response.statusCode}");
        print(response.body);
        // Handle the error accordingly (e.g., show an error message)
      }
    } catch (error) {
      print("Error during HTTP request: $error");
      // Handle the error accordingly (e.g., show an error message)
    }
  }
}

Future<SecurityContext> get globalContext async {
  final sslCert = await rootBundle.load('assets/odoo_ycfitness_xyz.cer');
  SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
  securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
  return securityContext;
}

Future<http.Client> getSSLPinningClient() async {
  HttpClient client = HttpClient(context: await globalContext);
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => false;
  IOClient ioClient = IOClient(client);
  return ioClient;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = await getSSLPinningClient();
  final apiService = NewsApiService(client);

  runApp(MyApp(apiService: apiService));
}

class MyApp extends StatelessWidget {
  final NewsApiService apiService;

  const MyApp({Key? key, required this.apiService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App SSL Pinning',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('News App SSL Pinning'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              apiService.fetchArticle();
            },
            child: Text("Login"),
          ),
        ),
      ),
    );
  }
}
