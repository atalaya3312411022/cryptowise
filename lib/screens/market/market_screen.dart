import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  List coins = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCoins();
  }

  Future<void> fetchCoins() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=false',
        ),
        headers: {
          'x-cg-demo-api-key': 'CG-FCHSimmmvVqrFGMhbV1cL4kV',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          coins = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed load market');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Crypto Market"),
        backgroundColor: Colors.black,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: coins.length,
              itemBuilder: (context, index) {
                final coin = coins[index];

                final price = coin['current_price'];
                final change = coin['price_change_percentage_24h'];

                return ListTile(
                  leading: Image.network(
                    coin['image'],
                    width: 35,
                    height: 35,
                  ),
                  title: Text(
                    coin['name'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    coin['symbol'].toUpperCase(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "\$${price.toString()}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        "${change.toStringAsFixed(2)}%",
                        style: TextStyle(
                          color:
                              change >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}