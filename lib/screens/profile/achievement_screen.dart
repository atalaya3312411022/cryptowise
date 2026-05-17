import 'package:flutter/material.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Achievements",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [

          /// LEVEL
          Container(
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),

              gradient: const LinearGradient(
                colors: [
                  Color(0xFFB8860B),
                  Color(0xFF6A3E00),
                ],
              ),
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                const Text(
                  "Current Level",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Level 3 Trader",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                LinearProgressIndicator(
                  value: 0.6,
                  backgroundColor:
                      Colors.white24,

                  color: Colors.amber,
                ),

                const SizedBox(height: 8),

                const Text(
                  "120 / 200 XP",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            "Your Achievements",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          buildAchievement(
            icon: Icons.emoji_events,
            title: "Bronze Trader",
            subtitle:
                "Complete 5 dummy trades",
            unlocked: true,
          ),

          buildAchievement(
            icon: Icons.play_circle_fill,
            title: "Learning Enthusiast",
            subtitle:
                "Watch 5 educational videos",
            unlocked: true,
          ),

          buildAchievement(
            icon: Icons.menu_book,
            title: "News Reader",
            subtitle:
                "Read 10 crypto news",
            unlocked: true,
          ),

          buildAchievement(
            icon: Icons.trending_up,
            title: "Market Explorer",
            subtitle:
                "Open market 20 times",
            unlocked: false,
          ),

          buildAchievement(
            icon: Icons.workspace_premium,
            title: "Crypto Master",
            subtitle:
                "Reach Level 10",
            unlocked: false,
          ),

        ],
      ),
    );
  }

  Widget buildAchievement({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool unlocked,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius:
            BorderRadius.circular(18),
      ),

      child: Row(
        children: [

          CircleAvatar(
            radius: 24,
            backgroundColor:
                unlocked
                    ? Colors.amber
                    : Colors.grey.shade800,

            child: Icon(
              icon,
              color:
                  unlocked
                      ? Colors.black
                      : Colors.grey,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            unlocked
                ? Icons.check_circle
                : Icons.lock,
            color:
                unlocked
                    ? Colors.green
                    : Colors.grey,
          ),
        ],
      ),
    );
  }
}