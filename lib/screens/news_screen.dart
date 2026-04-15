import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/news_model.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/news_image.dart';
import 'news_story_screen.dart';

class NewsScreen extends StatefulWidget {
  final String? userName;

  const NewsScreen({super.key, this.userName});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int _navIndex = 0;
  bool _showWelcomeBanner = true;
  final List<NewsArticle> _articles = sampleNews;

  void _onNavTap(int index) {
    setState(() => _navIndex = index);
    // TODO: navigate to other main screens
  }

  void _openArticle(NewsArticle article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewsStoryScreen(
          article: article,
          navIndex: _navIndex,
          onNavTap: _onNavTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Safe area + header
                SliverToBoxAdapter(
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome banner (only on first load)
                        if (_showWelcomeBanner)
                          _WelcomeBanner(
                            userName: widget.userName ?? 'Alyssa',
                            onDismiss: () =>
                                setState(() => _showWelcomeBanner = false),
                          ),

                        // "News" title
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            'News',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Article list
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final article = _articles[index];
                      return _ArticleCard(
                        article: article,
                        onTap: () => _openArticle(article),
                      );
                    },
                    childCount: _articles.length,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            ),
          ),

          // Bottom navigation bar
          AppBottomNav(currentIndex: _navIndex, onTap: _onNavTap),
        ],
      ),
    );
  }
}

// ─── Welcome Banner ──────────────────────────────────────────────────────────

class _WelcomeBanner extends StatefulWidget {
  final String userName;
  final VoidCallback onDismiss;

  const _WelcomeBanner({required this.userName, required this.onDismiss});

  @override
  State<_WelcomeBanner> createState() => _WelcomeBannerState();
}

class _WelcomeBannerState extends State<_WelcomeBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _slide = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();

    // Auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _dismissBanner();
    });
  }

  void _dismissBanner() {
    _ctrl.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B6914), Color(0xFFD4A017), Color(0xFFB8860B)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Text('👋', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Welcome Back, ${widget.userName}!',
                style: GoogleFonts.lato(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Article Card ─────────────────────────────────────────────────────────────

class _ArticleCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onTap;

  const _ArticleCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            NewsImagePlaceholder(
              type: article.imagePlaceholder,
              height: 195,
              showDuration: article.videoDuration != null,
              duration: article.videoDuration,
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              article.title,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),

            const SizedBox(height: 6),

            // Subtitle
            Text(
              article.subtitle,
              style: GoogleFonts.lato(
                fontSize: 13,
                color: const Color(0xFFAAAAAA),
                height: 1.5,
              ),
              maxLines: article.imagePlaceholder == 'bitcoin' ? 3 : 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Author + time
            Text(
              '${article.author} · ${article.timeAgo}',
              style: GoogleFonts.lato(
                fontSize: 12,
                color: const Color(0xFF777777),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
