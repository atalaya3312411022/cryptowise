import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class CoinDetailScreen extends StatelessWidget {
  final dynamic coin;
  const CoinDetailScreen({super.key, required this.coin});

  String _fmt(dynamic val) {
    if (val == null) return '-';
    final n = (val as num).toDouble();
    if (n >= 1e9) return '${(n / 1e9).toStringAsFixed(2)}B';
    if (n >= 1e6) return '${(n / 1e6).toStringAsFixed(2)}M';
    return n.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final change =
        (coin['price_change_percentage_24h'] ?? 0.0) as double;
    final isPositive = change >= 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
        title: Text(coin['name'] ?? '', style: AppTextStyles.headline2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ── Icon ──
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                coin['image'] ?? '',
                width: 80,
                height: 80,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.currency_bitcoin,
                  color: AppColors.goldLight,
                  size: 80,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Harga ──
            Text(
              '\$${(coin['current_price'] ?? 0).toStringAsFixed(2)}',
              style: GoogleFonts.playfairDisplay(
                color: AppColors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // ── Perubahan 24h ──
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isPositive
                    ? AppColors.successGreen.withOpacity(0.15)
                    : AppColors.errorRed.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}% (24h)',
                style: GoogleFonts.lato(
                  color: isPositive
                      ? AppColors.successGreen
                      : AppColors.errorRed,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ── Info ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider, width: 0.8),
              ),
              child: Column(
                children: [
                  _Row('Market Cap', '\$${_fmt(coin['market_cap'])}'),
                  const Divider(color: AppColors.divider, height: 20),
                  _Row('Volume (24h)', '\$${_fmt(coin['total_volume'])}'),
                  const Divider(color: AppColors.divider, height: 20),
                  _Row('Circulating Supply',
                      _fmt(coin['circulating_supply'])),
                  const Divider(color: AppColors.divider, height: 20),
                  _Row('Market Rank',
                      '#${coin['market_cap_rank'] ?? '-'}'),
                  const Divider(color: AppColors.divider, height: 20),
                  _Row('All Time High',
                      '\$${(coin['ath'] ?? 0).toStringAsFixed(2)}'),
                  const Divider(color: AppColors.divider, height: 20),
                  _Row('All Time Low',
                      '\$${(coin['atl'] ?? 0).toStringAsFixed(4)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyGrey),
        Text(
          value,
          style: GoogleFonts.lato(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}