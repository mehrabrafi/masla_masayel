// About Me Screen with Dark Mode (Fixed)
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final iconColor = isDarkMode ? Colors.teal[300]! : Colors.teal;
    final progressBg = isDarkMode ? Colors.teal[900]! : Colors.teal[100]!;
    final highlightColor = isDarkMode ? Colors.teal[800]! : Colors.teal[50]!;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('ডেভেলপার সম্পর্কে', style: TextStyle(fontFamily: 'HindSiliguri')),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/developer.jpg'),
              backgroundColor: Colors.tealAccent,
            ),
            const SizedBox(height: 20),
            Text(
              'মেহরাব আল রাফি',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.teal[300]! : Colors.teal[800]!,
                fontFamily: 'HindSiliguri',
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'ফ্লাটার অ্যান্ড্রয়েড ডেভেলপার',
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.teal[200]! : Colors.teal,
                fontFamily: 'HindSiliguri',
              ),
            ),
            const SizedBox(height: 30),

            // About Section
            _buildSectionCard(
              title: 'আমার সম্পর্কে',
              content: 'আমি মেহরাব আল রাফি, একজন প্যাশনেট অ্যান্ড্রয়েড অ্যাপ ডেভেলপার। প্রযুক্তি ও প্রোগ্রামিংয়ের প্রতি ভালোবাসা থেকেই আমার সফটওয়্যার ডেভেলপমেন্ট জগতে পথচলা শুরু। আমি বিশেষভাবে Flutter ফ্রেমওয়ার্ক ব্যবহার করে অ্যান্ড্রয়েড অ্যাপ তৈরি করে থাকি, যেখানে ব্যবহারকারীর প্রয়োজন ও অভিজ্ঞতাকে গুরুত্ব দিয়ে উন্নতমানের অ্যাপ্লিকেশন ডিজাইন ও ডেভেলপ করি।',
              icon: Icons.person,
              cardColor: cardColor,
              iconColor: iconColor,
              textColor: textColor,
            ),
            const SizedBox(height: 20),

            // Mission Section
            _buildSectionCard(
              title: 'আমার লক্ষ্য',
              content: 'আমার লক্ষ্য হলো এমন অ্যাপ তৈরি করা, যা সাধারণ মানুষের দৈনন্দিন জীবনে উপকারে আসে এবং প্রযুক্তিকে সহজ ও উপযোগী করে তোলে। আমি নিয়মিত নতুন কিছু শেখার চেষ্টা করি এবং আমার স্কিল বাড়াতে বিভিন্ন প্রজেক্টে কাজ করি। বর্তমানে আমি ইসলামিক ও এডুকেশনাল অ্যাপ ডেভেলপমেন্টে কাজ করছি, যার মাধ্যমে সমাজে ইতিবাচক প্রভাব ফেলতে চাই।',
              icon: Icons.flag,
              cardColor: cardColor,
              iconColor: iconColor,
              textColor: textColor,
            ),
            const SizedBox(height: 20),

            // Skills Section
            Card(
              elevation: 3,
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.code, color: iconColor),
                        const SizedBox(width: 10),
                        Text(
                          'দক্ষতা ও বিশেষজ্ঞতা',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: iconColor,
                            fontFamily: 'HindSiliguri',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildSkillItem('ফ্লাটার ডেভেলপমেন্ট', 0.85, textColor, iconColor, progressBg),
                    _buildSkillItem('ফায়ারবেজ ইন্টিগ্রেশন', 0.70, textColor, iconColor, progressBg),
                    _buildSkillItem('API ইন্টিগ্রেশন', 0.65, textColor, iconColor, progressBg),
                    _buildSkillItem('স্টেট ম্যানেজমেন্ট', 0.80, textColor, iconColor, progressBg),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Contact Section
            Text(
              'যোগাযোগ করুন',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: iconColor,
                fontFamily: 'HindSiliguri',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'আপনি যদি নিজের বা প্রতিষ্ঠানের জন্য অ্যান্ড্রয়েড অ্যাপ তৈরি করাতে চান, তাহলে আমার সাথে যোগাযোগ করতে পারেন। আমি আন্তরিকতা ও দক্ষতার সঙ্গে আপনার প্রয়োজন অনুযায়ী অ্যাপ তৈরি করে দিতে প্রস্তুত।',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: textColor,
                fontFamily: 'HindSiliguri',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildContactButton(Icons.email, 'ইমেইল', () => _launchUrl('mailto:mehrabalrafipersonal@gmail.com'), highlightColor, iconColor),
                const SizedBox(width: 15),
                _buildContactButton(Icons.link, 'পোর্টফোলিও', () => _launchUrl('https://github.com/mehrabrafi'), highlightColor, iconColor),
                const SizedBox(width: 15),
                _buildContactButton(Icons.telegram, 'টেলিগ্রাম', () => _launchUrl('https://t.me/Mehrab_Al_Rafi'), highlightColor, iconColor),
              ],
            ),
            const SizedBox(height: 20),

            // Dream Message
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: highlightColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'স্বপ্ন দেখি, প্রযুক্তির মাধ্যমে মানুষের জীবনকে আরও সহজ ও অর্থবহ করে তোলার।',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: iconColor,
                  fontFamily: 'HindSiliguri',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String content,
    required IconData icon,
    required Color cardColor,
    required Color iconColor,
    required Color textColor,
  }) {
    return Card(
      elevation: 3,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                    fontFamily: 'HindSiliguri',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: textColor,
                fontFamily: 'HindSiliguri',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillItem(String skill, double level, Color textColor, Color progressColor, Color bgColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            skill,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
              fontFamily: 'HindSiliguri',
            ),
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: level,
            backgroundColor: bgColor,
            color: progressColor,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(IconData icon, String label, VoidCallback onPressed, Color bgColor, Color iconColor) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, size: 30),
            color: iconColor,
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: iconColor,
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