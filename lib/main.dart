import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CatImagePage(),
    );
  }
}

class CatImagePage extends StatefulWidget {
  const CatImagePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CatImagePageState createState() => _CatImagePageState();
}

class _CatImagePageState extends State<CatImagePage> {
  String? catImageUrl;
  String? catId;

  @override
  void initState() {
    super.initState();
    fetchCatImage();
  }

  Future<void> fetchCatImage() async {
    setState(() {
      catImageUrl = null;
      catId = null;
    });

    final response =
        await http.get(Uri.parse('https://api.thecatapi.com/v1/images/search'));
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final catData = data[0];
        setState(() {
          catImageUrl = catData['url'];
          catId = catData['id'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Cat Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello World',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            if (catImageUrl != null)
              Image.network(
                catImageUrl!,
                height: 300,
                width: 300,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const CircularProgressIndicator();
                },
              )
            else
              const CircularProgressIndicator(),
            const SizedBox(height: 10),
            if (catId != null)
              Text('Cat ID: $catId', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchCatImage,
              child: const Text('Get New Cat'),
            ),
          ],
        ),
      ),
    );
  }
}
