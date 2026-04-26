import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'news_story_screen.dart';
import '../widgets/bottom_nav.dart';
import 'market/market_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List articles = [];
  bool isLoading = true;

  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://gnews.io/api/v4/search?q=crypto&lang=en&apikey=f19dfc57928ec979c9acf4d8bdd1aad8',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          articles = data['articles'] ?? [];
          isLoading = false;
        });
      } else {
        throw Exception('Failed load news');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  /// 🔥 NAVBAR TAP (NO NAVIGATOR PUSH)
  void _onNavTap(int index) {
    setState(() {
      _navIndex = index;
    });
  }

  /// 🔥 BODY SWITCH (ANTI BENTROK)
  Widget _buildBody() {
    if (_navIndex == 0) {
      return _buildNews();
    } else if (_navIndex == 2) {
      return const MarketScreen();
    } else {
      return const Center(
        child: Text(
          "Coming Soon",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  /// 🔥 NEWS LIST
  Widget _buildNews() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (articles.isEmpty) {
      return const Center(
        child: Text("No News", style: TextStyle(color: Colors.white)),
      );
    }

    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NewsStoryScreen(article: article),
              ),
            );
          },
          child: Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// IMAGE
                article['image'] != null
                    ? Image.network(
                        article['image'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(height: 200, color: Colors.grey),

                /// TEXT
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['title'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        article['description'] ?? '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        article['source']['name'] ?? '',
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text('Crypto News'),
        backgroundColor: Colors.black,
      ),

      /// 🔥 BODY SWITCH
      body: _buildBody(),

      /// 🔥 NAVBAR KAMU
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}