import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String title;
  final String imageUrl;

  Category({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory Category.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Category(
      id: doc.id,
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Convert a Category to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
    };
  }
}


class Question {
  final String id;
  final String question;
  final String answer;
  final String scholar;
  final String category; // ✅ নতুন ফিল্ড

  Question({
    required this.id,
    required this.question,
    required this.answer,
    required this.scholar,
    required this.category,
  });

  factory Question.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Question(
      id: doc.id,
      question: data['question'] ?? '',
      answer: data['answer'] ?? '',
      scholar: data['scholar'] ?? '',
      category: data['category'] ?? '', // ✅ এখানে প্যার্স করতেও হবে
    );
  }
}
