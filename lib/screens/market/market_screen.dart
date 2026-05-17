import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'buy_sell_screen.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  List coins = [];
  List<FlSpot> chartData = [];
  bool isLoading = true;

  String selectedCoin = "bitcoin";

  Timer? timer;

  @override
  void initState() {
    super.initState();

    fetchAll(); // 🔥 first load

    timer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (!mounted) return;
      fetchCoins(); // 🔥 update market aja (biar gak rusak UI)
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchAll() async {
    await fetchCoins();
    await fetchChart(selectedCoin);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  /// 🔥 FETCH MARKET
  Future<void> fetchCoins() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (!mounted) return;

        setState(() {
          coins = data;
        });
      }
    } catch (e) {
      debugPrint("ERROR COINS: $e");
    }
  }

  /// 🔥 FETCH CHART
  Future<void> fetchChart(String coinId) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/coins/$coinId/market_chart?vs_currency=usd&days=7',
        ),
      );

      if (response.statusCode != 200) return;

      final data = json.decode(response.body);
      final prices = data['prices'];

      if (prices == null) return;

      double x = 0;

      final newChart = prices.map<FlSpot>((point) {
        x += 1;

        return FlSpot(
          x.toDouble(),
          (point[1] as num).toDouble(), // 🔥 FIX int/double
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        chartData = newChart;
      });
    } catch (e) {
      debugPrint("ERROR CHART: $e");
    }
  }

  /// 🔥 SELECT COIN
  void selectCoin(String coinId) async {
    setState(() {
      selectedCoin = coinId;
    });

    await fetchChart(coinId);
  }

  /// 🔥 TOTAL BALANCE
  double get totalBalance {
    if (coins.isEmpty) return 0;

    final coin = coins.firstWhere(
      (c) => c['id'] == selectedCoin,
      orElse: () => coins[0],
    );

    return (coin['current_price'] ?? 0).toDouble();
  }

  double get minY => chartData.isEmpty
      ? 0
      : chartData.map((e) => e.y).reduce((a, b) => a < b ? a : b) * 0.98;

  double get maxY => chartData.isEmpty
      ? 0
      : chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.02;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [

                  /// 🔥 BALANCE
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "All Portfolios",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "\$${totalBalance.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        "+1.2% (24h)",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const SizedBox(height: 20),

                  /// 🔥 CHART
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        minY: minY,
                        maxY: maxY,
                        titlesData: FlTitlesData(show: false),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: chartData,
                            isCurved: true,
                            barWidth: 3,
                            dotData: FlDotData(show: false),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.greenAccent,
                                Colors.green,
                              ],
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green.withValues(alpha: 0.3),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔥 LIST COIN
                  ...coins.take(10).map((coin) {
                    final price = (coin['current_price'] ?? 0).toDouble();
                    final change =
                        (coin['price_change_percentage_24h'] ?? 0).toDouble();
                    final id = coin['id'];

                    final isSelected = id == selectedCoin;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BuySellScreen(
                              coinId: coin['id'],
                              coinName: coin['name'],
                              coinImage: coin['image'],
                            ),
                          ),
                        );
                      },

                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Image.network(
                            coin['image'],
                            width: 35,
                          ),
                          title: Text(
                            coin['name'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            coin['symbol'].toUpperCase(),
                            style:
                                const TextStyle(color: Colors.grey),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "\$${price.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    color: Colors.white),
                              ),
                              Text(
                                "${change.toStringAsFixed(2)}%",
                                style: TextStyle(
                                  color: change >= 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
      )
    );
  }
}