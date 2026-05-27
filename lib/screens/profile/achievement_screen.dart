import 'package:flutter/material.dart';
import '../../data/app_data.dart';

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

      body: ListView.builder(
        padding:
            const EdgeInsets.all(16),

        itemCount:
            AppData
                .achievements
                .length +

                1,

        itemBuilder:
            (context, index) {

          /// 🔥 LEVEL CARD
          if (index == 0) {
            return Container(
              margin:
                  const EdgeInsets.only(
                      bottom: 20),

              padding:
                  const EdgeInsets.all(
                      18),

              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius.circular(
                        18),

                gradient:
                    const LinearGradient(
                  colors: [
                    Color(0xFFB8860B),
                    Color(0xFF6A3E00),
                  ],
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  const Text(
                    "Current Level",
                    style: TextStyle(
                      color:
                          Colors.white70,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                      height: 8),

                  Text(
                    "Level ${AppData.level}",

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                      height: 10),

                  LinearProgressIndicator(
                    value:
                        (AppData.xp %
                                100) /
                            100,

                    backgroundColor:
                        Colors.white24,

                    color:
                        Colors.amber,
                  ),

                  const SizedBox(
                      height: 8),

                  Text(
                    "${AppData.xp} XP",

                    style:
                        const TextStyle(
                      color:
                          Colors.white70,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          final achievement =
              AppData
                  .achievements[
                      index -
                          1];

          return Container(
            margin:
                const EdgeInsets.only(
                    bottom: 14),

            padding:
                const EdgeInsets.all(
                    16),

            decoration:
                BoxDecoration(
              color:
                  const Color(
                      0xFF1A1A1A),

              borderRadius:
                  BorderRadius.circular(
                      18),
            ),

            child: Row(
              children: [

                const CircleAvatar(
                  radius: 24,
                  backgroundColor:
                      Colors.amber,

                  child: Icon(
                    Icons
                        .emoji_events,
                    color:
                        Colors.black,
                  ),
                ),

                const SizedBox(
                    width: 14),

                Expanded(
                  child: Text(
                    achievement,

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                const Icon(
                  Icons.check_circle,
                  color:
                      Colors.green,
                ),
              ],
            ),
          );
        },
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