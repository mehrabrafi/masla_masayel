import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App সম্পর্কে', style: TextStyle(fontFamily: 'HindSiliguri')),centerTitle: true,
        backgroundColor: Colors.teal,iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo1.png',
                    height: 120,
                  ),
            const Text(
              'মাসলা মাসায়েল একটি নির্ভরযোগ্য ও গবেষণাভিত্তিক ইসলামী অ্যাপ, যেখানে আপনি প্রতিদিনকার জীবনে প্রয়োজনীয় গুরুত্বপূর্ণ ধর্মীয় প্রশ্নের নির্ভরযোগ্য উত্তর পাবেন কুরআন ও সহিহ হাদীসের আলোকে।',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                fontFamily: 'HindSiliguri',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'আমরা চেষ্টা করি সাধারণ মানুষের মাঝে বিশুদ্ধ ইসলামী জ্ঞান সহজ ভাষায় তুলে ধরতে, যেন তারা সঠিক আক্বীদা ও আমলের উপর প্রতিষ্ঠিত থাকতে পারে।',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                fontFamily: 'HindSiliguri',
              ),
            ),
            const SizedBox(height: 20),
            // Features Section
            _buildSectionTitle('আমাদের সেবাসমূহ'),
            _buildFeatureItem(Icons.mosque, 'নামাজ, রোযা, হজ্জ, যাকাতসহ মৌলিক ইবাদত সম্পর্কিত মাসায়েল'),
            _buildFeatureItem(Icons.family_restroom, 'পারিবারিক, সামাজিক ও আধুনিক জীবনের জটিল প্রশ্নের সমাধান'),
            _buildFeatureItem(Icons.eco, 'হালাল-হারাম বিষয়ক নির্দেশনা'),
            _buildFeatureItem(Icons.work, 'চিকিৎসা, ব্যবসা ও চাকরির ইসলামসম্মত দিকনির্দেশনা'),
            _buildFeatureItem(Icons.verified_user, 'নির্ভরযোগ্য আলেমদের মাধ্যমে প্রমাণসহ উত্তর'),
            const SizedBox(height: 30),

            // Methodology Section
            _buildSectionTitle('আমাদের পদ্ধতি'),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'আমরা কোনো বিভ্রান্তিকর মতবাদ বা উগ্র চিন্তা ধারাকে সমর্থন করি না। শুধুমাত্র কুরআন, সহিহ হাদীস এবং সালাফে সালেহীনের মানহাজ অনুসরণ করে প্রামাণ্য দলিলভিত্তিক মাসআলা-মাসায়েল তুলে ধরাই আমাদের মূল লক্ষ্য।',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  fontFamily: 'HindSiliguri',
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Mission Section
            _buildSectionTitle('আমাদের লক্ষ্য'),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• সবার কাছে সহিহ ইসলামি জ্ঞান পৌঁছে দেওয়া',
                    style: TextStyle(fontSize: 16, fontFamily: 'HindSiliguri'),
                  ),
                  Text(
                    '• মুসলিম সমাজকে শিরক, বিদআত ও কুসংস্কার থেকে দূরে রাখা',
                    style: TextStyle(fontSize: 16, fontFamily: 'HindSiliguri'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Final Message
            const Center(
              child: Text(
                'আমাদের সাথে থাকুন, সহিহ দ্বীনের পথে চলুন।\nআল্লাহ আমাদের সবাইকে দ্বীনের উপর অটল রাখুন। আমিন।',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'HindSiliguri',
                  color: Colors.teal,
                ),
              ),
            ),
          ],
        ),
      ),
    ])));
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
          fontFamily: 'HindSiliguri',
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.teal),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'HindSiliguri',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 30),
          color: Colors.teal,
          onPressed: onPressed,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'HindSiliguri',
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}