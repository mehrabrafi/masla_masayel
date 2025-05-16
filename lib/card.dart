import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'QuestionDetailScreen.dart';

class QuestionCard extends StatelessWidget {
  final String question;
  final String scholar;
  final String answer;
  final Timestamp? timestamp;

  const QuestionCard({
    super.key,
    required this.question,
    required this.scholar,
    required this.answer,
    this.timestamp,
  });

  String _getFirstWords(String text, {int wordCount = 12}) {
    final words = text.split(' ');
    if (words.length > wordCount) {
      return '${words.take(wordCount).join(' ')}...';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final timeText = timestamp != null
        ? timeago.format(timestamp!.toDate(), locale: 'bn')
        : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          ),
        ),
        elevation: isDarkMode ? 0 : 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuestionDetailScreen(
                  question: question,
                  scholar: scholar,
                  answer: answer,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'প্রশ্ন: ${_getFirstWords(question)}',
                  style: TextStyle(
                    fontFamily: 'NotoSansBengali',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'উত্তর: ${_getFirstWords(answer)}',
                  style: TextStyle(
                    fontFamily: 'NotoSansBengali',
                    fontSize: 13,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                if (scholar.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    '— $scholar',
                    style: TextStyle(
                      fontFamily: 'NotoSansBengali',
                      fontSize: 12,
                      color: isDarkMode ? Colors.teal[300] : Colors.teal[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                if (timeText.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '🕓 $timeText',
                    style: TextStyle(
                      fontFamily: 'NotoSansBengali',
                      fontSize: 12,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}class CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Color color;
  final VoidCallback onTap;
  final Color? textColor;

  const CategoryCard({
    required this.title,
    required this.imageUrl,
    required this.color,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = isDarkMode ? color.withOpacity(0.8) : color;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      splashColor: Colors.transparent, // Disables splash effect
      highlightColor: Colors.transparent, // Disables highlight effect
      child: Container(
        width: 110,
        margin: EdgeInsets.symmetric(horizontal: 6),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: effectiveColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isDarkMode
              ? null
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              imageUrl,
              width: 100,
              height: 55,
              color: Colors.white,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.broken_image,
                size: 32,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'NotoSansBengali',
                fontSize: 15,
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}