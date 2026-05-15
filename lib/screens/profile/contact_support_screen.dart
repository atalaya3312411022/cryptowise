import 'package:flutter/material.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Contact Support",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [

          /// HEADER
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFB8860B),
                  Color(0xFF5C3B00),
                ],
              ),
            ),
            child: const Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  "CryptoWise Contact Support",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  "Need help? Learn how to use CryptoWise features and understand crypto education.",
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// FAQ TITLE
          const Text(
            "Frequently Asked Questions",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          buildFAQ(
            question:
                "How to use market chart?",
            answer:
                "Open Market → Tap a crypto coin → View detailed chart and market data.",
          ),

          buildFAQ(
            question:
                "How to earn XP?",
            answer:
                "Read crypto news and complete educational activities to gain XP.",
          ),

          buildFAQ(
            question:
                "How does dummy trading work?",
            answer:
                "Dummy trading uses virtual balance and real market data from CoinGecko. No real money is involved.",
          ),

          buildFAQ(
            question:
                "How to level up?",
            answer:
                "Earn XP by reading articles, watching educational content, and using app features.",
          ),

          const SizedBox(height: 26),

          /// CONTACT US
          const Text(
            "Contact Us",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          buildContactCard(
            icon: Icons.email_outlined,
            title: "Email Support",
            subtitle:
                "chairunnisa135077@gmail.com",
          ),

          buildContactCard(
            icon: Icons.phone_outlined,
            title: "WhatsApp Support",
            subtitle:
                "+62 815-6717-312",
          ),

          const SizedBox(height: 26),

          /// FEEDBACK BUTTON
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFFB8860B),
              padding:
                  const EdgeInsets.symmetric(
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(14),
              ),
            ),

            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor:
                      const Color(0xFF1A1A1A),

                  title: const Text(
                    "Feedback",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  content: const Text(
                    "Thank you for your feedback! We appreciate your support.",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      child: const Text(
                        "OK",
                      ),
                    ),
                  ],
                ),
              );
            },

            child: const Text(
              "Send Feedback",
              style: TextStyle(
                color: Colors.black,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 30),

          /// ABOUT APP
          Container(
            padding:
                const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color:
                  const Color(0xFF151515),
              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: const Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  "About CryptoWise",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "CryptoWise is an educational crypto literacy platform designed to help users understand digital assets through real-time market data, educational content, and gamification.",
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFAQ({
    required String question,
    required String answer,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      decoration: BoxDecoration(
        color:
            const Color(0xFF151515),
        borderRadius:
            BorderRadius.circular(18),
      ),

      child: ExpansionTile(
        iconColor:
            const Color(0xFFB8860B),
        collapsedIconColor:
            Colors.white,

        title: Text(
          question,
          style: const TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.w600,
          ),
        ),

        children: [
          Padding(
            padding:
                const EdgeInsets.all(
                    16),
            child: Text(
              answer,
              style: const TextStyle(
                color:
                    Colors.white70,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      padding:
          const EdgeInsets.all(
        16,
      ),

      decoration: BoxDecoration(
        color:
            const Color(0xFF151515),
        borderRadius:
            BorderRadius.circular(
                18),
      ),

      child: Row(
        children: [

          CircleAvatar(
            backgroundColor:
                const Color(
                    0xFFB8860B),

            child: Icon(
              icon,
              color:
                  Colors.black,
            ),
          ),

          const SizedBox(
              width: 14),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [

              Text(
                title,
                style:
                    const TextStyle(
                  color:
                      Colors.white,
                  fontWeight:
                      FontWeight
                          .bold,
                ),
              ),

              const SizedBox(
                  height: 4),

              Text(
                subtitle,
                style:
                    const TextStyle(
                  color:
                      Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}