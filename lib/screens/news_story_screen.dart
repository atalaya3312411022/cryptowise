import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/news_model.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/news_image.dart';

class NewsStoryScreen extends StatelessWidget {
  final NewsArticle article;
  final int navIndex;
  final Function(int) onNavTap;

  const NewsStoryScreen({
    super.key,
    required this.article,
    required this.navIndex,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Status bar spacer
                SliverToBoxAdapter(
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.chevron_left,
                              color: AppColors.goldLight,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'News',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Hero image
                        NewsImagePlaceholder(
                          type: article.imagePlaceholder,
                          height: 210,
                          showDuration: article.videoDuration != null,
                          duration: article.videoDuration,
                        ),

                        const SizedBox(height: 14),

                        // Author + time
                        Text(
                          '${article.author} · ${article.timeAgo}',
                          style: AppTextStyles.bodyGrey.copyWith(fontSize: 12),
                        ),

                        const SizedBox(height: 20),

                        // Article sections
                        ...article.sections.map((section) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    section.heading,
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    section.body,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: const Color(0xFFCCCCCC),
                                      height: 1.7,
                                    ),
                                  ),
                                ],
                              ),
                            )),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom nav
          AppBottomNav(currentIndex: navIndex, onTap: onNavTap),
        ],
      ),
    );
  }
}
