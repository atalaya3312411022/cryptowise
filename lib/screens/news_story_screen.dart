import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'webview_screen.dart';

class NewsStoryScreen extends StatelessWidget {
  final Map article;

  const NewsStoryScreen({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    final title =
        article['title'] ?? '';

    final desc =
        article['description'] ?? '';

    final image =
        article['image'];

    final source =
        article['source']
                ?['name'] ??
            '';

    final url =
        article['url'];

    /// BIAR PANJANG
    final content = desc.isNotEmpty
        ? desc
        : "No detailed article available.";
        
    return Scaffold(
      backgroundColor:
          Colors.black,

      appBar: AppBar(
        title:
            const Text(
          "News",
        ),

        backgroundColor:
            Colors.black,
      ),

      body:
          SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,

          children: [

            /// IMAGE
            if (image != null)
              Image.network(
                image,
                width:
                    double.infinity,
                height: 250,
                fit:
                    BoxFit.cover,
              ),

            Padding(
              padding:
                  const EdgeInsets
                      .all(16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  /// TITLE
                  Text(
                    title,

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize: 20,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                      height: 10),

                  /// SOURCE
                  Text(
                    source,

                    style:
                        const TextStyle(
                      color:
                          Colors.grey,
                    ),
                  ),

                  const SizedBox(
                      height: 20),

                  /// 🔥 KEY INSIGHTS
                  buildCard(
                    icon:
                        Icons.auto_awesome,
                    title:
                        "Key Insights",

                    child: Column(
                      children: [

                        buildBullet(
                          "Major crypto market movement detected",
                        ),

                        buildBullet(
                          "This news may affect short-term market sentiment",
                        ),

                        buildBullet(
                          "Always verify before making investment decisions",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                      height: 20),

                  /// 🔥 TRADING LESSON
                  buildCard(
                    icon:
                        Icons.school,
                    title:
                        "Trading Lesson",

                    iconColor:
                        const Color(
                      0xFFB8860B,
                    ),

                    child:
                        const Text(
                      "Avoid emotional trading and FOMO.\n\n"
                      "Before investing:\n"
                      "• Analyze the trend\n"
                      "• Understand market risk\n"
                      "• Never invest blindly\n\n"
                      "Crypto education is more important than fast profit.",

                      style:
                          TextStyle(
                        color: Colors
                            .white70,
                        height:
                            1.7,
                      ),
                    ),
                  ),

                  const SizedBox(
                      height: 20),

                  /// FULL ARTICLE
                  const Text(
                    "Description",

                    style:
                        TextStyle(
                      color:
                          Colors.white,
                      fontSize: 18,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                      height: 14),

                  Text(
                    content,

                    style:
                        const TextStyle(
                      color: Colors
                          .white70,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(
                      height: 24),

                  /// 🔥 WATCH & LEARN
                  buildCard(
                    icon: Icons
                        .play_circle_fill,
                    title:
                        "Watch & Learn",

                    iconColor:
                        Colors.red,

                    child: Column(
                      children: [

                        buildVideoCard(
                          title:
                              "How to Read Crypto Charts",

                          subtitle:
                              "Beginner Trading Guide",

                          url:
                              "https://youtu.be/eynxyoKgpng?si=3eUvw_6G0Kv7xR4x",
                        ),

                        buildVideoCard(
                          title:
                              "Risk Management in Crypto",

                          subtitle:
                              "Avoid Big Losses",

                          url:
                              "https://youtu.be/6fjD6lg7z1Y?si=2t7mQvIY3kQ8wJMa",
                        ),

                        buildVideoCard(
                          title:
                              "Crypto Trading for Beginners",

                          subtitle:
                              "Learn Safely",

                          url:
                              "https://youtu.be/41JCpzvnn_0?si=fQArWnEFV6Gm7W1R",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                      height: 30),

                  /// FULL ARTICLE BUTTON
                  if (url != null)
                    SizedBox(
                      width:
                          double.infinity,

                      child:
                          ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xFFB8860B,
                          ),

                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical:
                                16,
                          ),
                        ),

                        onPressed:
                            () {
                          Navigator
                              .push(
                            context,

                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      WebViewScreen(
                                url:
                                    url,
                                title:
                                    "Full Article",
                              ),
                            ),
                          );
                        },

                        child:
                            const Text(
                          "Read Full Article",
                          style:
                              TextStyle(
                            color:
                                Colors
                                    .white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// CARD UI
Widget buildCard({
  required IconData icon,
  required String title,
  required Widget child,
  Color iconColor =
      Colors.amber,
}) {
  return Container(
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
              18),
    ),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment
              .start,

      children: [

        Row(
          children: [

            Icon(
              icon,
              color:
                  iconColor,
            ),

            const SizedBox(
                width: 8),

            Text(
              title,

              style:
                  const TextStyle(
                color:
                    Colors.white,
                fontSize: 18,
                fontWeight:
                    FontWeight
                        .bold,
              ),
            ),
          ],
        ),

        const SizedBox(
            height: 14),

        child,
      ],
    ),
  );
}

/// BULLET
Widget buildBullet(
  String text,
) {
  return Padding(
    padding:
        const EdgeInsets.only(
            bottom: 10),

    child: Row(
      crossAxisAlignment:
          CrossAxisAlignment
              .start,

      children: [

        const Text(
          "• ",
          style: TextStyle(
            color:
                Colors.amber,
            fontSize: 18,
          ),
        ),

        Expanded(
          child: Text(
            text,

            style:
                const TextStyle(
              color:
                  Colors
                      .white70,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}

/// VIDEO CARD
Widget buildVideoCard({
  required String title,
  required String subtitle,
  required String url,
}) {
  return InkWell(
    borderRadius:
        BorderRadius.circular(
            16),

    onTap: () async {

      final Uri uri =
          Uri.parse(url);

      await launchUrl(
        uri,
        mode: LaunchMode
            .externalApplication,
      );
    },

    child: Container(
      margin:
          const EdgeInsets.only(
              bottom: 12),

      padding:
          const EdgeInsets.all(
              14),

      decoration:
          BoxDecoration(
        color:
            const Color(
                0xFF1A1A1A),

        borderRadius:
            BorderRadius.circular(
                16),
      ),

      child: Row(
        children: [

          Container(
            height: 52,
            width: 52,

            decoration:
                BoxDecoration(
              color:
                  Colors.red
                      .withValues(
                alpha: 0.2,
              ),

              borderRadius:
                  BorderRadius
                      .circular(
                          14),
            ),

            child:
                const Icon(
              Icons.play_arrow,
              color:
                  Colors.red,
              size: 30,
            ),
          ),

          const SizedBox(
              width: 14),

          Expanded(
            child: Column(
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
          ),

          const Icon(
            Icons.open_in_new,
            color:
                Colors.white54,
          ),
        ],
      ),
    ),
  );
}