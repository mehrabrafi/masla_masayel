import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../State/providers.dart';
import '../UiComponents/card.dart';

class CategoryQuestionsScreen extends ConsumerWidget {
  final String category;

  const CategoryQuestionsScreen({required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(questionsProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(category, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: questionsAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (questions) {
          final categoryQuestions = questions
              .where((q) => q.category == category)
              .toList();

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: categoryQuestions.length,
            itemBuilder: (context, index) {
              final q = categoryQuestions[index];
              return QuestionCard(
                question: q.question,
                scholar: q.scholar,
                answer: q.answer,
              );
            },
          );
        },
      ),
    );
  }
}