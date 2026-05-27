class AppData {

  // PROFILE
  static String? profileImagePath;
  
  // Trading
  static double virtualBalance =
      10000;

  // XP SYSTEM
  static int xp = 0;

  static int level = 1;

  // ACHIEVEMENT
  static List<String>
      achievements = [];


  // GAMIFICATION
  static int watchedVideos =
      0;

  static int readNews =
      0;

  static int totalTrades =
      0;

  // ADD XP
  static void addXP(
      int amount) {

    xp += amount;

    level =
        (xp ~/ 100) + 1;

    checkAchievement();
  }

  // CHECK BADGE
  static void
      checkAchievement() {

    /// WATCH VIDEO
    if (watchedVideos >= 1 &&
        !achievements.contains(
            "Learning Enthusiast")) {

      achievements.add(
          "Learning Enthusiast");
    }

    /// READ NEWS
    if (readNews >= 5 &&
        !achievements.contains(
            "News Reader")) {

      achievements.add(
          "News Reader");
    }

    /// FIRST TRADE
    if (totalTrades >= 1 &&
        !achievements.contains(
            "Bronze Trader")) {

      achievements.add(
          "Bronze Trader");
    }

    /// XP BASED
    if (xp >= 150 &&
        !achievements.contains(
            "Market Explorer")) {

      achievements.add(
          "Market Explorer");
    }

    if (xp >= 250 &&
        !achievements.contains(
            "Crypto Scholar")) {

      achievements.add(
          "Crypto Scholar");
    }

    if (xp >= 399 &&
        !achievements.contains(
            "Crypto Master")) {

      achievements.add(
          "Crypto Master");
    }
  }
}