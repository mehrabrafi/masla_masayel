import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/DataModels.dart';
import '../State/providers.dart';
import 'QuestionDetailScreen.dart';
import 'dart:math';

class SearchScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String query = '';
  late List<Question> randomQuestions;

  @override
  void initState() {
    super.initState();
    final questions = ref.read(questionsProvider).value ?? [];
    randomQuestions = _getRandomQuestions(questions, 7);
  }

  List<Question> _getRandomQuestions(List<Question> allQuestions, int count) {
    if (allQuestions.isEmpty) return [];
    final random = Random();
    final shuffled = List.of(allQuestions)..shuffle(random);
    return shuffled.take(count).toList();
  }

  String getFirstWords(String text, {int wordCount = 10}) {
    List<String> words = text.split(' ');
    if (words.length > wordCount) {
      return words.take(wordCount).join(' ') + '...';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionsProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('প্রশ্ন অনুসন্ধান করুন', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: questionsAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (allQuestions) {
          final questions = query.isEmpty
              ? randomQuestions
              : allQuestions.where((q) =>
              q.question.toLowerCase().contains(query.toLowerCase()))
              .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'প্রশ্ন লিখুন...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => query = value),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final q = questions[index];
                    return Material(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('প্রশ্ন: ${getFirstWords(q.question)}'),
                            subtitle: Text('উত্তর: ${getFirstWords(q.answer)}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: Duration(milliseconds: 300),
                                  pageBuilder: (_, __, ___) => QuestionDetailScreen(
                                    question: q.question,
                                    scholar: q.scholar,
                                    answer: q.answer,
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
                            },
                            splashColor: Colors.transparent,
                            tileColor: Colors.transparent,
                            selectedTileColor: Colors.transparent,
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey[300],
                            indent: 16,
                            endIndent: 16,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}