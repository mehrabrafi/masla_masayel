import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final iconColor = isDarkMode ? Colors.teal[300]! : Colors.teal;
    final highlightColor = isDarkMode ? Colors.teal[800]! : Colors.teal[50]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('App সম্পর্কে', style: TextStyle(fontFamily: 'HindSiliguri')),
        centerTitle: true,
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '"ইসলামিক Query" একটি নির্ভরযোগ্য ও গবেষণাভিত্তিক ইসলামী অ্যাপ, যেখানে আপনি প্রতিদিনকার জীবনে প্রয়োজনীয় গুরুত্বপূর্ণ ধর্মীয় প্রশ্নের নির্ভরযোগ্য উত্তর পাবেন কুরআন ও সহিহ হাদীসের আলোকে।',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: textColor,
                fontFamily: 'HindSiliguri',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'আমরা চেষ্টা করি সাধারণ মানুষের মাঝে বিশুদ্ধ ইসলামী জ্ঞান সহজ ভাষায় তুলে ধরতে, যেন তারা সঠিক আক্বীদা ও আমলের উপর প্রতিষ্ঠিত থাকতে পারে।',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: textColor,
                fontFamily: 'HindSiliguri',
              ),
            ),
            const SizedBox(height: 20),

            // Features Section
            _buildSectionTitle('আমাদের সেবাসমূহ', iconColor),
            _buildFeatureItem(Icons.mosque, 'নামাজ, রোযা, হজ্জ, যাকাতসহ মৌলিক ইবাদত সম্পর্কিত মাসায়েল', iconColor, textColor),
            _buildFeatureItem(Icons.family_restroom, 'পারিবারিক, সামাজিক ও আধুনিক জীবনের জটিল প্রশ্নের সমাধান', iconColor, textColor),
            _buildFeatureItem(Icons.eco, 'হালাল-হারাম বিষয়ক নির্দেশনা', iconColor, textColor),
            _buildFeatureItem(Icons.work, 'চিকিৎসা, ব্যবসা ও চাকরির ইসলামসম্মত দিকনির্দেশনা', iconColor, textColor),
            _buildFeatureItem(Icons.verified_user, 'নির্ভরযোগ্য আলেমদের মাধ্যমে প্রমাণসহ উত্তর', iconColor, textColor),
            const SizedBox(height: 30),

            // Methodology Section
            _buildSectionTitle('আমাদের পদ্ধতি', iconColor),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: highlightColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'আমরা কোনো বিভ্রান্তিকর মতবাদ বা উগ্র চিন্তা ধারাকে সমর্থন করি না। শুধুমাত্র কুরআন, সহিহ হাদীস এবং সালাফে সালেহীনের মানহাজ অনুসরণ করে প্রামাণ্য দলিলভিত্তিক মাসআলা-মাসায়েল তুলে ধরাই আমাদের মূল লক্ষ্য।',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: textColor,
                  fontFamily: 'HindSiliguri',
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Mission Section
            _buildSectionTitle('আমাদের লক্ষ্য', iconColor),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: highlightColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• সবার কাছে সহিহ ইসলামি জ্ঞান পৌঁছে দেওয়া',
                    style: TextStyle(fontSize: 16, color: textColor, fontFamily: 'HindSiliguri'),
                  ),
                  Text(
                    '• মুসলিম সমাজকে শিরক, বিদআত ও কুসংস্কার থেকে দূরে রাখা',
                    style: TextStyle(fontSize: 16, color: textColor, fontFamily: 'HindSiliguri'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Final Message
            Center(
              child: Text(
                'আমাদের সাথে থাকুন, সহিহ দ্বীনের পথে চলুন।\nআল্লাহ আমাদের সবাইকে দ্বীনের উপর অটল রাখুন। আমিন।',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'HindSiliguri',
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: 'HindSiliguri',
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text, Color iconColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontFamily: 'HindSiliguri',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}