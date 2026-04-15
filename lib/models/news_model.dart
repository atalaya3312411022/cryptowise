class NewsArticle {
  final String id;
  final String title;
  final String subtitle;
  final String author;
  final String timeAgo;
  final String imagePlaceholder; // color code for placeholder
  final String? videoDuration;
  final List<NewsSection> sections;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.timeAgo,
    required this.imagePlaceholder,
    this.videoDuration,
    this.sections = const [],
  });
}

class NewsSection {
  final String heading;
  final String body;

  const NewsSection({required this.heading, required this.body});
}

// Sample data
final List<NewsArticle> sampleNews = [
  NewsArticle(
    id: '1',
    title: 'Forex Trading For Begginers',
    subtitle:
        'Fidelity Updates Ethereum ETF Application To Include ETH Staking',
    author: 'Anthonysworld',
    timeAgo: '10 min ago',
    imagePlaceholder: 'forex',
    videoDuration: '8:56',
    sections: [
      NewsSection(
        heading: 'What is Forex Trading?',
        body:
            'Forex trading is the exchange of one currency for another. It is one of the most actively traded markets in the world, with an average daily trading volume of \$6.6 trillion.\n\nForex is traded 24 hours a day, five days a week across major financial centers — London, New York, Sydney, and Tokyo.',
      ),
      NewsSection(
        heading: 'How To Start?',
        body:
            'To start forex trading, you need to choose a reputable broker, open a trading account, and fund it with capital you can afford to lose.\n\nAlways use risk management tools like stop-loss orders to protect your investment from major losses.',
      ),
    ],
  ),
  NewsArticle(
    id: '2',
    title: "What's bitcoin? How To Use Trading?",
    subtitle:
        "Bitcoin is a digital currency (also called a cryptocurrency) that allows people to send and receive money over the internet without... Learn More",
    author: 'AlyssaViviencee',
    timeAgo: '19 min ago',
    imagePlaceholder: 'bitcoin',
    sections: [
      NewsSection(
        heading: "What's bitcoin?",
        body:
            "Bitcoin is a digital currency (also called a cryptocurrency) that allows people to send and receive money over the internet without needing a bank or central authority.\n\nBitcoin was created in 2009 by an unknown person or group using the name Satoshi Nakamoto. Bitcoin is a type of money that exists only online. It uses a technology called blockchain, which is a public digital ledger that records all transactions securely and transparently.",
      ),
      NewsSection(
        heading: 'How To Use Trading?',
        body:
            'Trading is the activity of buying and selling financial assets (such as stocks, cryptocurrencies, or commodities) in order to make a profit from price changes.\n\nTrading means buying an asset when the price is low and selling it when the price is higher to earn profit.\n\nExample:\nYou Buy Bitcoin at \$30,000\nLater the price rises to \$35,000\nYou sell it and earn \$5,000 profit (before fees)',
      ),
    ],
  ),
];
