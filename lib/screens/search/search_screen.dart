import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import 'coin_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isSearching = false;
  String _query = '';

  List<dynamic> _allCoins = [];
  List<dynamic> _filteredCoins = [];
  bool _isLoading = false;

  final List<String> _recentSearches = ['Bitcoin', 'Ethereum'];

  @override
  void initState() {
    super.initState();
    _fetchCoins();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && !_isSearching) {
        setState(() => _isSearching = true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchCoins() async {
    setState(() => _isLoading = true);
    try {
      final res = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets'
        '?vs_currency=usd&order=market_cap_desc&per_page=100&page=1',
      ));
      if (res.statusCode == 200) {
        setState(() => _allCoins = List<dynamic>.from(json.decode(res.body)));
      }
    } catch (e) {
      debugPrint('fetchCoins error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onQueryChanged(String value) {
    setState(() {
      _query = value;
      _filteredCoins = value.isEmpty
          ? []
          : _allCoins.where((c) {
              final name = (c['name'] ?? '').toString().toLowerCase();
              final symbol = (c['symbol'] ?? '').toString().toLowerCase();
              return name.contains(value.toLowerCase()) ||
                  symbol.contains(value.toLowerCase());
            }).toList();
    });
  }

  void _cancelSearch() {
    _focusNode.unfocus();
    _controller.clear();
    setState(() {
      _isSearching = false;
      _query = '';
      _filteredCoins = [];
    });
  }

  void _selectRecent(String name) {
    _controller.text = name;
    _onQueryChanged(name);
  }

  void _removeRecent(String name) =>
      setState(() => _recentSearches.remove(name));

  void _saveRecent(String name) {
    if (!_recentSearches.contains(name)) {
      setState(() => _recentSearches.insert(0, name));
    }
  }

  void _onCoinTap(dynamic coin) {
    _saveRecent(coin['name']);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CoinDetailScreen(coin: coin)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          Expanded(
            child: _isSearching ? _buildSearchContent() : _buildTrending(),
          ),
        ],
      ),
    );
  }

  // ── Search Bar ──
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.search_rounded,
                      color: AppColors.grey, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      onChanged: _onQueryChanged,
                      style: GoogleFonts.lato(
                          color: AppColors.white, fontSize: 16),
                      cursorColor: AppColors.goldLight,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: GoogleFonts.lato(
                            color: AppColors.grey, fontSize: 16),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _controller.clear();
                        _onQueryChanged('');
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child:
                            Icon(Icons.cancel, color: AppColors.grey, size: 18),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_isSearching) ...[
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _cancelSearch,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF636366),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Cancel',
                    style:
                        GoogleFonts.lato(color: AppColors.white, fontSize: 15)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Default: Trending ──
  Widget _buildTrending() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.goldLight));
    }
    final trending = _allCoins.take(10).toList();
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 8),
        Text('Trending', style: AppTextStyles.headline2),
        const SizedBox(height: 12),
        ...trending.map((coin) => _TrendingCard(
              coin: coin,
              onTap: () => _onCoinTap(coin),
            )),
      ],
    );
  }

  // ── Konten saat search aktif ──
  Widget _buildSearchContent() {
    if (_query.isEmpty) return _buildRecent();
    if (_filteredCoins.isEmpty) return _buildEmpty();
    return _buildResults();
  }

  // ── Recent searches ──
  Widget _buildRecent() {
    if (_recentSearches.isEmpty) {
      return Center(
        child: Text('No recent searches',
            style: GoogleFonts.lato(color: AppColors.grey, fontSize: 15)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: _recentSearches.length,
      itemBuilder: (_, i) {
        final name = _recentSearches[i];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.history, color: AppColors.grey, size: 20),
          title: Text(name,
              style: GoogleFonts.lato(color: AppColors.white, fontSize: 16)),
          trailing: GestureDetector(
            onTap: () => _removeRecent(name),
            child: const Icon(Icons.close, color: AppColors.grey, size: 18),
          ),
          onTap: () => _selectRecent(name),
        );
      },
    );
  }

  // ── Hasil pencarian ──
  Widget _buildResults() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: _filteredCoins.length,
      itemBuilder: (_, i) {
        final coin = _filteredCoins[i];
        final change =
            (coin['price_change_percentage_24h'] ?? 0.0) as double;
        final isPositive = change >= 0;
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              coin['image'] ?? '',
              width: 40,
              height: 40,
              errorBuilder: (_, __, ___) => Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.currency_bitcoin,
                    color: AppColors.grey),
              ),
            ),
          ),
          title: Text(coin['name'] ?? '',
              style: GoogleFonts.lato(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          subtitle: Text(
              (coin['symbol'] ?? '').toString().toUpperCase(),
              style: GoogleFonts.lato(color: AppColors.grey, fontSize: 13)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${(coin['current_price'] ?? 0).toStringAsFixed(2)}',
                style: GoogleFonts.lato(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}%',
                style: GoogleFonts.lato(
                    color: isPositive
                        ? AppColors.successGreen
                        : AppColors.errorRed,
                    fontSize: 13),
              ),
            ],
          ),
          onTap: () => _onCoinTap(coin),
        );
      },
    );
  }

  // ── Empty state ──
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off, color: AppColors.grey, size: 48),
          const SizedBox(height: 12),
          Text('No results for "$_query"',
              style: GoogleFonts.lato(color: AppColors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TRENDING CARD
// ─────────────────────────────────────────────────────────────────────────────

class _TrendingCard extends StatelessWidget {
  final dynamic coin;
  final VoidCallback onTap;
  const _TrendingCard({required this.coin, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final change = (coin['price_change_percentage_24h'] ?? 0.0) as double;
    final isPositive = change >= 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider, width: 0.8),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                coin['image'] ?? '',
                width: 44,
                height: 44,
                errorBuilder: (_, __, ___) => Container(
                  width: 44,
                  height: 44,
                  color: AppColors.surface,
                  child: const Icon(Icons.currency_bitcoin,
                      color: AppColors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coin['name'] ?? '',
                      style: GoogleFonts.lato(
                          color: AppColors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(
                      (coin['symbol'] ?? '').toString().toUpperCase(),
                      style: GoogleFonts.lato(
                          color: AppColors.grey, fontSize: 13)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${(coin['current_price'] ?? 0).toStringAsFixed(2)}',
                  style: GoogleFonts.lato(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? AppColors.successGreen.withOpacity(0.15)
                        : AppColors.errorRed.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}%',
                    style: GoogleFonts.lato(
                        color: isPositive
                            ? AppColors.successGreen
                            : AppColors.errorRed,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}