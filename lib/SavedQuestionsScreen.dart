import 'package:alemer_jobab/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'QuestionDetailScreen.dart';

class SavedScreen extends ConsumerStatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends ConsumerState<SavedScreen> {
  bool _isSelecting = false;
  List<int> _selectedIndices = [];

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
        if (_selectedIndices.isEmpty) {
          _isSelecting = false;
        }
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  Future<void> _showDeleteDialog({bool deleteAll = false}) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(deleteAll ? 'সমস্ত বুকমার্ক মুছে ফেলুন?' : 'নির্বাচিত বুকমার্ক মুছে ফেলুন?'),
        content: Text(deleteAll
            ? 'আপনি কি নিশ্চিত যে আপনি সব সেভ করা প্রশ্ন মুছে ফেলতে চান?'
            : 'আপনি কি নিশ্চিত যে নির্বাচিত প্রশ্নগুলি মুছে ফেলতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('না'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('হ্যাঁ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if (shouldDelete) {
      if (deleteAll) {
        await ref.read(bookmarkProvider.notifier).clear();
      } else {
        _selectedIndices.sort((a, b) => b.compareTo(a));
        for (final index in _selectedIndices) {
          await ref.read(bookmarkProvider.notifier).removeBookmark(index);
        }
      }
      setState(() {
        _selectedIndices = [];
        _isSelecting = false;
      });
    }
  }

  String _getFirstWords(String text, {int wordCount = 12}) {
    final words = text.split(' ');
    if (words.length > wordCount) {
      return '${words.take(wordCount).join(' ')}...';
    }
    return text;
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dateTime = DateTime.parse(timestamp);
      return timeago.format(dateTime, locale: 'bn');
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarks = ref.watch(bookmarkProvider);
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == AppThemeMode.dark;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.white),
        title: _isSelecting
            ? Text('${_selectedIndices.length} টি নির্বাচিত',
            style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.white,
                fontFamily: 'NotoSansBengali'))
            : Text('সেভ করা প্রশ্ন',
            style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.white,
                fontFamily: 'NotoSansBengali')),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.teal[800] : Colors.teal,
        leading: _isSelecting
            ? IconButton(
          icon: Icon(Icons.close,
              color: isDarkMode ? Colors.white : Colors.white),
          onPressed: () {
            setState(() {
              _selectedIndices = [];
              _isSelecting = false;
            });
          },
        )
            : null,
        actions: [
          if (bookmarks.isNotEmpty && !_isSelecting)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert,
                  color: isDarkMode ? Colors.white : Colors.white),
              onSelected: (value) {
                if (value == 'delete_all') {
                  _showDeleteDialog(deleteAll: true);
                } else if (value == 'select_to_delete') {
                  setState(() {
                    _isSelecting = true;
                  });
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'select_to_delete',
                  child: Row(
                    children: [
                      Icon(Icons.check_box,
                          color: isDarkMode ? Colors.teal[300] : Colors.teal),
                      const SizedBox(width: 8),
                      Text('বাছাই করে মুছুন',
                          style: TextStyle(
                              fontFamily: 'NotoSansBengali',
                              color: isDarkMode ? Colors.white : Colors.black)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete_all',
                  child: Row(
                    children: [
                      Icon(Icons.delete_forever, color: Colors.red),
                      const SizedBox(width: 8),
                      Text('সমস্ত মুছুন',
                          style: TextStyle(
                              fontFamily: 'NotoSansBengali',
                              color: isDarkMode ? Colors.white : Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          if (_isSelecting && _selectedIndices.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete,
                  color: isDarkMode ? Colors.white : Colors.white),
              onPressed: () => _showDeleteDialog(),
            ),
        ],
      ),
      body: bookmarks.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border,
                size: 50,
                color: isDarkMode ? Colors.grey[500] : Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'কোন সেভ করা প্রশ্ন নেই',
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontFamily: 'NotoSansBengali',
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: bookmarks.length,
        itemBuilder: (context, index) {
          final bookmark = bookmarks[index];
          final timeText = bookmark['timestamp'] != null
              ? _formatTimestamp(bookmark['timestamp'])
              : '';

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Card(
              key: ValueKey(bookmark['question']),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: _selectedIndices.contains(index)
                  ? isDarkMode
                  ? Colors.teal[900]!.withOpacity(0.5)
                  : Colors.teal[50]
                  : isDarkMode
                  ? Colors.grey[850]
                  : Colors.white,
              elevation: isDarkMode ? 0 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  if (_isSelecting) {
                    _toggleSelection(index);
                  } else {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            QuestionDetailScreen(
                              question: bookmark['question']!,
                              scholar: bookmark['scholar']!,
                              answer: bookmark['answer']!,
                            ),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 0.5);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end).chain(
                            CurveTween(curve: curve),
                          );

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
                onLongPress: () {
                  setState(() {
                    _isSelecting = true;
                    _toggleSelection(index);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (_isSelecting)
                            Checkbox(
                              value: _selectedIndices.contains(index),
                              onChanged: (_) => _toggleSelection(index),
                              fillColor: MaterialStateProperty.resolveWith(
                                      (states) {
                                    if (states.contains(MaterialState.selected)) {
                                      return isDarkMode
                                          ? Colors.teal[300]
                                          : Colors.teal;
                                    }
                                    return null;
                                  }),
                            ),
                          Expanded(
                            child: Text(
                              'প্রশ্ন: ${_getFirstWords(bookmark['question']!)}',
                              style: TextStyle(
                                fontFamily: 'NotoSansBengali',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.black87,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'উত্তর: ${_getFirstWords(bookmark['answer']!)}',
                        style: TextStyle(
                          fontFamily: 'NotoSansBengali',
                          fontSize: 14,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (bookmark['scholar']!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          '— ${bookmark['scholar']!}',
                          style: TextStyle(
                            fontFamily: 'NotoSansBengali',
                            fontSize: 12,
                            color: isDarkMode
                                ? Colors.teal[300]
                                : Colors.teal[700],
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
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}