import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../data/app_data.dart';

class BuySellScreen extends StatefulWidget {
  final String coinId;
  final String coinName;
  final String coinImage;

  const BuySellScreen({
    super.key,
    required this.coinId,
    required this.coinName,
    required this.coinImage,
  });

  @override
  State<BuySellScreen> createState() =>_BuySellScreenState();
}

class _BuySellScreenState extends State<BuySellScreen> {
  bool isLoading = true;

  final TextEditingController amountController =
    TextEditingController();

double get virtualBalance =>
    AppData.virtualBalance;
  int xp = 120;

  String selectedPeriod = "7";

  double high24h = 0;
  double low24h = 0;
  double marketCap = 0;
  double volume = 0;
  double priceChange = 0;

  double ownedCoin = 0.0;
  double profitLoss = 0.0;

  Map coinData = {};
  List<FlSpot> chartData = [];

  @override
  void initState() {
    super.initState();
    fetchCoin();
  }

  Future<void> fetchCoin() async {
    try {

      /// DETAIL COIN
      final detailResponse = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/coins/${widget.coinId}',
        ),
      );

      /// CHART
      final chartResponse = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/coins/${widget.coinId}/market_chart?vs_currency=usd&days=$selectedPeriod',
        ),
      );

      final detailData = json.decode(detailResponse.body);
      final chartJson = json.decode(chartResponse.body);

      /// SAFE MARKET DATA
      final market =
          detailData['market_data'];

      high24h =
          (market?['high_24h']
                      ?['usd']
                  as num?)
              ?.toDouble() ??
          0;

      low24h =
          (market?['low_24h']
                      ?['usd']
                  as num?)
              ?.toDouble() ??
          0;

      marketCap =
          (market?['market_cap']
                      ?['usd']
                  as num?)
              ?.toDouble() ??
          0;

      volume =
          (market?['total_volume']
                      ?['usd']
                  as num?)
              ?.toDouble() ??
          0;

      priceChange =
          (market?[
                  'price_change_percentage_24h']
              as num?)
              ?.toDouble() ??
          0;

      /// SAFE CHART
      final prices =
          chartJson['prices'];

      if (prices == null) {
        return;
      }

      double x = 0;

      final spots =
          prices
              .map<FlSpot>(
                  (point) {
            x += 1;

            return FlSpot(
              x,
              (point[1]
                      as num)
                  .toDouble(),
            );
          })
              .toList();

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

                  /// HEADER
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

                  /// PRICE
                  Text(
                    "\$${price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [

                      Text(
                        priceChange >= 0
                            ? "+${priceChange.toStringAsFixed(2)}%"
                            : "${priceChange.toStringAsFixed(2)}%",

                        style: TextStyle(
                          color:
                              priceChange >= 0
                                  ? Colors.green
                                  : Colors.red,

                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Text(
                        "24h",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// CHART
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
                            FlTitlesData(

                          topTitles:
                              const AxisTitles(
                            sideTitles:
                                SideTitles(
                              showTitles:
                                  false,
                            ),
                          ),

                          bottomTitles:
                              const AxisTitles(
                            sideTitles:
                                SideTitles(
                              showTitles:
                                  false,
                            ),
                          ),

                          leftTitles:
                              const AxisTitles(
                            sideTitles:
                                SideTitles(
                              showTitles:
                                  false,
                            ),
                          ),

                          rightTitles:
                              AxisTitles(
                            sideTitles:
                                SideTitles(
                              showTitles:
                                  true,

                              reservedSize:
                                  55,

                              getTitlesWidget:
                                  (value, meta) {

                                return Text(
                                  "\$${(value / 1000).toStringAsFixed(1)}K",

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.grey,
                                    fontSize:
                                        11,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                          
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

                  /// PERIOD BUTTON
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,

                    children: [

                      periodButton("1"),
                      periodButton("7"),
                      periodButton("30"),
                      periodButton("365"),
                    ],
                  ),

                  const SizedBox(height: 30),


                  /// PREMIUM TRADING SIMULATOR
                  Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(24),

                      border: Border.all(
                        color: const Color(0xFFB8860B)
                            .withValues(alpha: 0.15),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.25,
                          ),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        /// HEADER
                        Row(
                          children: [

                            const Icon(
                              Icons.candlestick_chart,
                              color: Color(0xFFB8860B),
                              size: 26,
                            ),

                            const SizedBox(width: 10),

                            const Text(
                              "Trading Simulator",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const Spacer(),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.amber
                                    .withValues(
                                  alpha: 0.15,
                                ),

                                borderRadius:
                                    BorderRadius.circular(
                                  30,
                                ),
                              ),

                              child: Text(
                                "XP: $xp",
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// BALANCE
                        Container(
                          padding:
                              const EdgeInsets.all(18),

                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF1A1A1A),
                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              Text(
                                "Virtual Balance",
                                style: TextStyle(
                                  color:
                                      Colors.grey.shade400,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "\$${virtualBalance.toStringAsFixed(2)}",
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.greenAccent,
                                  fontSize: 30,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// AMOUNT
                        const Text(
                          "Trade Amount",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller:
                              amountController,

                          keyboardType:
                              TextInputType.number,

                          style: const TextStyle(
                            color: Colors.white,
                          ),

                          decoration:
                              InputDecoration(
                            hintText:
                                "Enter amount",

                            hintStyle:
                                const TextStyle(
                              color: Colors.grey,
                            ),

                            prefixIcon:
                                const Icon(
                              Icons.currency_bitcoin,
                              color:
                                  Color(0xFFB8860B),
                            ),

                            filled: true,
                            fillColor:
                                const Color(
                                    0xFF1A1A1A),

                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      18),
                              borderSide:
                                  BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// ESTIMATION
                        Container(
                          padding:
                              const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF1A1A1A),
                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),

                          child: Column(
                            children: [

                              buildTradeInfo(
                                "Estimated Price",
                                "\$${price.toStringAsFixed(2)}",
                              ),

                              const SizedBox(height: 14),

                              buildTradeInfo(
                                "You Receive",
                                "${amountController.text.isEmpty ? "0.0" : amountController.text} ${coinData['symbol']?.toString().toUpperCase() ?? ""}",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        /// BUY SELL BUTTON
                        Row(
                          children: [

                            Expanded(
                              child:
                                  ElevatedButton(
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.green,
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    vertical: 18,
                                  ),

                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                18),
                                  ),
                                ),

                                onPressed: () {

                                  final amount =
                                      double.tryParse(
                                        amountController.text,
                                      ) ??
                                      0;

                                  final totalCost =
                                      amount * price;

                                  if (amount <= 0) {
                                    successDialog(
                                      "Invalid Amount",
                                      "Please enter amount",
                                    );
                                    return;
                                  }

                                  if (totalCost >
                                      virtualBalance) {

                                    successDialog(
                                      "Insufficient Balance",
                                      "Your virtual balance is not enough",
                                    );

                                    return;
                                  }

                                  setState(() {

                                    // BALANCE
                                    AppData.virtualBalance -=
                                        totalCost;

                                    /// PORTFOLIO
                                    ownedCoin += amount;

                                    /// XP
                                    xp += 15;
                                    AppData.totalTrades++;
                                    AppData.addXP(15);
                                    AppData.checkAchievement();

                                    /// DUMMY PROFIT
                                    profitLoss += 12.5;
                                  });

                                  successDialog(
                                    "Successfully bought ${widget.coinName}",
                                    "+15 XP earned",
                                  );
                                },

                                child:
                                    const Text(
                                  "BUY",
                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child:
                                  ElevatedButton(
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(
                                          0xFFB71C1C),

                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    vertical: 18,
                                  ),

                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                18),
                                  ),
                                ),

                                onPressed: () {

                                  final amount =
                                      double.tryParse(
                                        amountController.text,
                                      ) ??
                                      0;

                                  final totalSell =
                                      amount * price;

                                  if (amount <= 0) {
                                    successDialog(
                                      "Invalid Amount",
                                      "Please enter amount",
                                    );
                                    return;
                                  }

                                  setState(() {

                                    /// BALANCE
                                    AppData.virtualBalance +=
                                        totalSell;

                                    /// PORTFOLIO
                                    ownedCoin -= amount;

                                    /// XP
                                    xp += 10;

                                    /// DUMMY PROFIT
                                    profitLoss -= 8.5;
                                  });

                                  successDialog(
                                    "Successfully sold ${widget.coinName}",
                                    "+10 XP earned",
                                  );
                                },

                                child:
                                    const Text(
                                  "SELL",
                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        /// PORTFOLIO
                        Container(
                          padding:
                              const EdgeInsets.all(
                                  18),

                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF1A1A1A),
                            borderRadius:
                                BorderRadius.circular(
                                    20),
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              const Text(
                                "Your Portfolio",
                                style: TextStyle(
                                  color:
                                      Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 14),

                              buildTradeInfo(
                                widget.coinName,
                                "${ownedCoin.toStringAsFixed(4)} ${coinData['symbol']?.toString().toUpperCase() ?? ""}",
                              ),

                              const SizedBox(height: 12),

                              buildTradeInfo(
                                "Profit/Loss",
                                profitLoss >= 0
                                    ? "+\$${profitLoss.toStringAsFixed(2)}"
                                    : "-\$${profitLoss.abs().toStringAsFixed(2)}",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                 
                  /// MARKET PERFORMANCE
                  Container(
                    padding:
                        const EdgeInsets.all(
                            18),

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                              0xFF121212),

                      borderRadius:
                          BorderRadius.circular(
                              20),
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        const Text(
                          "Market Performance",
                          style: TextStyle(
                            color:
                                Colors.white,
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 18),

                        buildTradeInfo(
                          "24h High",
                          "\$${high24h.toStringAsFixed(2)}",
                        ),

                        const SizedBox(height: 12),

                        buildTradeInfo(
                          "24h Low",
                          "\$${low24h.toStringAsFixed(2)}",
                        ),

                        const SizedBox(height: 12),

                        buildTradeInfo(
                          "Volume",
                          "\$${(volume / 1000000000).toStringAsFixed(2)}B",
                        ),

                        const SizedBox(height: 12),

                        buildTradeInfo(
                          "Market Cap",
                          "\$${(marketCap / 1000000000).toStringAsFixed(2)}B",
                        ),

                        const SizedBox(height: 12),

                        buildTradeInfo(
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

  Widget buildInfoRow(
  String title,
  String value,
) {
  return Row(
    mainAxisAlignment:
        MainAxisAlignment
            .spaceBetween,

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
          fontWeight:
              FontWeight.bold,
        ),
      ),
    ],
  );
}

/// QUICK BUTTON
Widget quickButton(
  String text,
) {
  return Expanded(
    child: Padding(
      padding:
          const EdgeInsets.only(
              right: 8),

      child: Container(
        height: 42,

        decoration:
            BoxDecoration(
          color:
              const Color(
                  0xFF1A1A1A),

          borderRadius:
              BorderRadius.circular(
                  14),
        ),

        child: Center(
          child: Text(
            text,
            style:
                const TextStyle(
              color:
                  Colors.white,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),
      ),
    ),
  );
}

/// TRADE INFO
Widget buildTradeInfo(
  String title,
  String value,
) {
  return Row(
    mainAxisAlignment:
        MainAxisAlignment
            .spaceBetween,

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
          fontWeight:
              FontWeight.bold,
        ),
      ),
    ],
  );
}

/// SUCCESS DIALOG
void successDialog(
  String title,
  String subtitle,
) {
  showDialog(
    context: context,

    builder: (_) =>
        AlertDialog(
      backgroundColor:
          const Color(
              0xFF1A1A1A),

      title: Text(
        title,
        style:
            const TextStyle(
          color:
              Colors.white,
        ),
      ),

      content: Text(
        subtitle,
        style:
            const TextStyle(
          color:
              Colors.white70,
        ),
      ),

      actions: [

        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },

          child:
              const Text(
            "OK",
          ),
        ),
      ],
    ),
  );
}
Widget periodButton(
  String days,
) {
  final selected =
      selectedPeriod ==
          days;

  return GestureDetector(
    onTap: () async {

      setState(() {
        selectedPeriod =
            days;
      });

      await fetchCoin();
    },

    child: Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),

      decoration:
          BoxDecoration(
        color: selected
            ? const Color(
                0xFFB8860B)
            : const Color(
                0xFF1A1A1A),

        borderRadius:
            BorderRadius.circular(
                14),
      ),

      child: Text(
        days == "1"
            ? "1D"
            : days == "7"
                ? "7D"
                : days == "30"
                    ? "30D"
                    : "1Y",

        style: TextStyle(
          color: selected
              ? Colors.black
              : Colors.white,

          fontWeight:
              FontWeight.bold,
        ),
      ),
    ),
  );
}
}

