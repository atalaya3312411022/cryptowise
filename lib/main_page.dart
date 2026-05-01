import 'package:flutter/material.dart';
import 'screens/news_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/market/market_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'widgets/bottom_nav.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final pages = [
    const NewsScreen(),
    const SearchScreen(),
    const MarketScreen(),
    const ProfileScreen(),
  ];

  void onNavTap(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex,
        onTap: onNavTap,
      ),
    );
  }
}