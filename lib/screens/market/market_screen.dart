import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

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

  @override
  void initState() {
    super.initState();
    fetchAll();

    Timer.periodic(const Duration(seconds: 20), (_) {
      fetchAll();
    });
  }

  Future<void> fetchAll() async {
    await Future.wait([
      fetchCoins(),
      fetchChart(selectedCoin),
    ]);

    setState(() {
      isLoading = false;
    });
  }

  /// 🔥 MARKET LIST
  Future<void> fetchCoins() async {
    final response = await http.get(
      Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1',
      ),
    );

    coins = json.decode(response.body);
  }

  /// 🔥 CHART FIXED (INI YANG PALING PENTING)
  Future<void> fetchChart(String coinId) async {
    final response = await http.get(
      Uri.parse(
        'https://api.coingecko.com/api/v3/coins/$coinId/market_chart?vs_currency=usd&days=7',
      ),
    );

    final data = json.decode(response.body);
    final prices = data['prices'];

    /// 🔥 FILTER BIAR GAK PADAT
    final filtered = prices.where((e) {
      return prices.indexOf(e) % 4 == 0;
    }).toList();

    double x = 0;

    chartData = filtered.map<FlSpot>((point) {
      x++;
      return FlSpot(x, point[1].toDouble());
    }).toList();
  }

  /// 🔥 SELECT COIN
  void selectCoin(String coinId) async {
    setState(() {
      isLoading = true;
      selectedCoin = coinId;
    });

    await fetchChart(coinId);

    setState(() {
      isLoading = false;
    });
  }

  double get totalBalance {
    if (coins.isEmpty) return 0;
    return coins.take(5).fold(0.0, (sum, coin) {
      return sum + (coin['current_price'] * 0.1);
    });
  }

  double get minY => chartData.isEmpty
      ? 0
      : chartData.map((e) => e.y).reduce((a, b) => a < b ? a : b) * 0.98;

  double get maxY => chartData.isEmpty
      ? 0
      : chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.02;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [

                /// 🔥 HEADER
                Text(
                  "\$${totalBalance.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔥 CHART FINAL (SUDAH MIRIP FIGMA)
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
                          curveSmoothness: 0.35,
                          barWidth: 3,
                          dotData: FlDotData(show: false),

                          /// 🔥 WARNA GRADIENT
                          gradient: const LinearGradient(
                            colors: [
                              Colors.greenAccent,
                              Colors.green,
                            ],
                          ),

                          /// 🔥 AREA (INI YANG BIKIN KAYAK FIGMA)
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.withOpacity(0.3),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
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
                  final price = coin['current_price'] ?? 0;
                  final change =
                      coin['price_change_percentage_24h'] ?? 0;
                  final id = coin['id'];

                  final isSelected = id == selectedCoin;

                  return GestureDetector(
                    onTap: () => selectCoin(id),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.green.withOpacity(0.2)
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
    );
  }
}