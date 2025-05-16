import 'package:alemer_jobab/providers.dart';
import 'package:alemer_jobab/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllQuestionsScreen extends ConsumerStatefulWidget {
  const AllQuestionsScreen({super.key});

  @override
  ConsumerState<AllQuestionsScreen> createState() => _AllQuestionsScreenState();
}

class _AllQuestionsScreenState extends ConsumerState<AllQuestionsScreen> {
  final ScrollController _scrollController = ScrollController();
  final int _batchSize = 15;
  int _displayedItems = 15; // Initialize with first batch
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    final questions = ref.read(questionsProvider).value ?? [];

    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      final newDisplayCount = _displayedItems + _batchSize;
      _displayedItems = newDisplayCount.clamp(0, questions.length);
      _hasMore = _displayedItems < questions.length;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionsProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'সকল প্রশ্ন',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'NotoSansBengali',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: questionsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
        ),
        error: (error, stack) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'ডেটা লোড করতে সমস্যা হয়েছে',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'NotoSansBengali',
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('আবার চেষ্টা করুন'),
                  onPressed: () => ref.refresh(questionsProvider),
                ),
              ],
            ),
          );
        },
        data: (allQuestions) {
          // Get only the questions to display based on pagination
          final questions = allQuestions.take(_displayedItems).toList();

          if (questions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'কোন প্রশ্ন পাওয়া যায়নি',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'NotoSansBengali',
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _displayedItems = _batchSize;
                _hasMore = true;
              });
              return ref.refresh(questionsProvider);
            },
            child: Scrollbar(
              controller: _scrollController,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverList(
                  delegate: SliverChildBuilderDelegate(
                  (context, index) {
            final q = questions[index];
            return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            child: QuestionCard(
            key: ValueKey('${q.id}_$index'),
            question: q.question,
            scholar: q.scholar,
            answer: q.answer,
            ),
            );
            },
              childCount: questions.length,
            ),
          ),
                  if (_isLoading)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                          ),
                        ),
                      ),
                    ),
                  if (!_hasMore && allQuestions.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            'সব প্রশ্ন দেখানো হয়েছে',
                            style: TextStyle(
                              fontFamily: 'NotoSansBengali',
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}