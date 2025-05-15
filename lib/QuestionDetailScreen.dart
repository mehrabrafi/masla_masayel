import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  Widget build(BuildContext context) {
    final bookmarks = ref.watch(bookmarkProvider);
    final isBookmarked = bookmarks.any((b) => b['question'] == widget.question);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('প্রশ্নের উত্তর', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.zoom_out, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _textScaleFactor = (_textScaleFactor - 0.1).clamp(0.8, 2.0);
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.zoom_in, color: Colors.white),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: _textScaleFactor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // প্রশ্ন: টেক্সট
              Text(
                'প্রশ্ন : ${widget.question}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSansBengali',
                ),
              ),
              SizedBox(height: 16),

              // উত্তর: টেক্সট
              Text(
                'উত্তর : ${widget.answer}',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'NotoSansBengali',
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16),

              // স্কলার টেক্সট
              if (widget.scholar.isNotEmpty)
                Text(
                  '— ${widget.scholar}',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.teal,
                    fontFamily: 'NotoSansBengali',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
