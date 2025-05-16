import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'providers.dart';

class QuestionDetailScreen extends ConsumerStatefulWidget {
  final String question;
  final String scholar;
  final String answer;

  const QuestionDetailScreen({
    required this.question,
    required this.scholar,
    required this.answer,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<QuestionDetailScreen> createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends ConsumerState<QuestionDetailScreen> {
  double _textScaleFactor = 1.0;

  Future<void> _launchTelegram() async {
    final url = 'https://t.me/masla_masayel';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarks = ref.watch(bookmarkProvider);
    final isBookmarked = bookmarks.any((b) => b['question'] == widget.question);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('প্রশ্নের উত্তর', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.zoom_out, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _textScaleFactor = (_textScaleFactor - 0.1).clamp(0.8, 2.0);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.zoom_in, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _textScaleFactor = (_textScaleFactor + 0.1).clamp(0.8, 2.0);
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  ref.read(bookmarkProvider.notifier).toggleBookmark({
                    'question': widget.question,
                    'scholar': widget.scholar,
                    'answer': widget.answer,
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: _textScaleFactor),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'প্রশ্ন : ${widget.question}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NotoSansBengali',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'উত্তর : ${widget.answer}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'NotoSansBengali',
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (widget.scholar.isNotEmpty)
                            Text(
                              '— ${widget.scholar}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.teal,
                                fontFamily: 'NotoSansBengali',
                              ),
                            ),
                          const SizedBox(height: 60), // নিচে কিছু স্পেস রাখলাম যেন আইকনের সাথে overlap না হয়
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Positioned Telegram Icon Button on Right Center
              Positioned(
                right: -1, // ডান দিক থেকে ভিতরে ঢুকানো
                top: constraints.maxHeight / 2 - 25,
                child: GestureDetector(
                  onTap: _launchTelegram,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.teal, // Telegram Blue
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.telegram, color: Colors.white, size: 20),
                        SizedBox(width: 6),
                        Text(
                          'Join',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
,
            ],
          );
        },
      ),
    );
  }
}
