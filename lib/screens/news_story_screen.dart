import 'package:flutter/material.dart';
import 'webview_screen.dart';

class NewsStoryScreen extends StatelessWidget {
  final Map article;

  const NewsStoryScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final title = article['title'] ?? '';
    final desc = article['description'] ?? '';
    final image = article['image'];
    final source = article['source']['name'] ?? '';
    final url = article['url'];

    // 🔥 BIKIN "FAKE DETAIL" BIAR PANJANG
    final content = desc + "\n\n" + desc + "\n\n" + desc;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("News Detail"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            if (image != null)
              Image.network(
                image,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// SOURCE
                  Text(
                    source,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  /// ISI (DIBUAT PANJANG)
                  Text(
                    content,
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 🔥 BUTTON KE FULL ARTIKEL / VIDEO
                  if (url != null)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WebViewScreen(
                              url: url,
                              title: "Full Article",
                            ),
                          ),
                        );
                      },
                      child: const Text("Baca / Tonton Selengkapnya"),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}