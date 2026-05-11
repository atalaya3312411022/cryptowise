import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoinDetailScreen extends StatefulWidget {
  final String coinId;
  final String coinName;
  final String coinImage;

  const CoinDetailScreen({
    super.key,
    required this.coinId,
    required this.coinName,
    required this.coinImage,
  });

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  bool isLoading = true;

  Map coinData = {};
  List<FlSpot> chartData = [];

  @override
  void initState() {
    super.initState();
    fetchCoin();
  }

  Future<void> fetchCoin() async {
    try {

      /// 🔥 DETAIL COIN
      final detailResponse = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/coins/${widget.coinId}',
        ),
      );

      /// 🔥 CHART
      final chartResponse = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/coins/${widget.coinId}/market_chart?vs_currency=usd&days=7',
        ),
      );

      final detailData = json.decode(detailResponse.body);
      final chartJson = json.decode(chartResponse.body);

      final prices = chartJson['prices'];

      double x = 0;

      final spots = prices.map<FlSpot>((point) {
        x += 1;

        return FlSpot(
          x,
          (point[1] as num).toDouble(),
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        coinData = detailData;
        chartData = spots;
        isLoading = false;
      });

    } catch (e) {
      debugPrint("ERROR DETAIL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    final marketData = coinData['market_data'];

    final price =
        marketData?['current_price']?['usd']?.toDouble() ?? 0;

    final change =
        marketData?['price_change_percentage_24h']
            ?.toDouble() ??
        0;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          widget.coinName,
          style: const TextStyle(color: Colors.white),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [

                  /// 🔥 HEADER
                  Row(
                    children: [

                      Image.network(
                        widget.coinImage,
                        width: 45,
                      ),

                      const SizedBox(width: 12),

                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            widget.coinName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            coinData['symbol']
                                .toString()
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// 🔥 PRICE
                  Text(
                    "\$${price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "${change.toStringAsFixed(2)}%",
                    style: TextStyle(
                      color:
                          change >= 0
                              ? Colors.green
                              : Colors.red,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 🔥 CHART
                  SizedBox(
                    height: 260,
                    child: LineChart(
                      LineChartData(
                        minY: chartData
                                .map((e) => e.y)
                                .reduce(
                                  (a, b) =>
                                      a < b ? a : b,
                                ) *
                            0.98,

                        maxY: chartData
                                .map((e) => e.y)
                                .reduce(
                                  (a, b) =>
                                      a > b ? a : b,
                                ) *
                            1.02,

                        gridData:
                            FlGridData(show: false),

                        borderData:
                            FlBorderData(show: false),

                        titlesData:
                            FlTitlesData(show: false),

                        lineBarsData: [

                          LineChartBarData(
                            spots: chartData,

                            isCurved: true,

                            curveSmoothness: 0.35,

                            barWidth: 3,

                            dotData:
                                FlDotData(show: false),

                            gradient:
                                const LinearGradient(
                              colors: [
                                Colors.greenAccent,
                                Colors.green,
                              ],
                            ),

                            belowBarData:
                                BarAreaData(
                              show: true,

                              gradient:
                                  LinearGradient(
                                colors: [
                                  Colors.green
                                      .withValues(
                                        alpha: 0.3,
                                      ),

                                  Colors.transparent,
                                ],
                                begin:
                                    Alignment.topCenter,
                                end: Alignment
                                    .bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 🔥 MARKET INFO
                  Container(
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius:
                          BorderRadius.circular(16),
                    ),

                    child: Column(
                      children: [

                        buildInfoRow(
                          "Market Cap",
                          "\$${marketData?['market_cap']?['usd']}",
                        ),

                        const SizedBox(height: 16),

                        buildInfoRow(
                          "24H Volume",
                          "\$${marketData?['total_volume']?['usd']}",
                        ),

                        const SizedBox(height: 16),

                        buildInfoRow(
                          "Rank",
                          "#${coinData['market_cap_rank']}",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}