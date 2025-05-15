import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/DataModels.dart';

// Firebase instances
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Theme Provider
enum AppThemeMode { light, dark }

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  ThemeNotifier() : super(AppThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    state = isDark ? AppThemeMode.dark : AppThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state == AppThemeMode.light) {
      state = AppThemeMode.dark;
      await prefs.setBool('isDarkMode', true);
    } else {
      state = AppThemeMode.light;
      await prefs.setBool('isDarkMode', false);
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier();
});

// Categories Provider
final categoriesProvider = StreamProvider<List<Category>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore.collection('categories').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
  });
});

// Questions Provider
final questionsProvider = StreamProvider.autoDispose<List<Question>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final pageSize = 20; // প্রতি বার ২০টা প্রশ্ন দেখাবো

  // স্ক্রল হওয়ার পর নতুন ডেটা লোড হবে
  final query = firestore
      .collection('questions')
      .orderBy('timestamp', descending: true)
      .limit(pageSize);

  return query.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => Question.fromFirestore(doc)).toList();
  });
});

// Featured Categories Provider
final featuredCategoriesProvider = Provider<List<Category>>((ref) {
  final categories = ref.watch(categoriesProvider).value ?? [];
  return categories.take(4).toList();
});

// Featured Questions Provider
final featuredQuestionsProvider = Provider<List<Question>>((ref) {
  final questions = ref.watch(questionsProvider).value ?? [];
  return questions.take(20).toList();
});

// Bookmark Provider
class BookmarkNotifier extends StateNotifier<List<Map<String, String>>> {
  BookmarkNotifier() : super([]) {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('saved_questions') ?? [];
    state = saved.map((questionJson) {
      final parts = questionJson.split('|||');
      return {
        'question': parts[0],
        'scholar': parts[1],
        'answer': parts[2],
      };
    }).toList();
  }

  Future<void> toggleBookmark(Map<String, String> question) async {
    final prefs = await SharedPreferences.getInstance();
    final questionString = '${question['question']}|||${question['scholar']}|||${question['answer']}';
    List<String> saved = prefs.getStringList('saved_questions') ?? [];

    if (saved.contains(questionString)) {
      saved.remove(questionString);
    } else {
      saved.add(questionString);
    }

    await prefs.setStringList('saved_questions', saved);
    await loadBookmarks();
  }

  Future<void> removeBookmark(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> saved = prefs.getStringList('saved_questions') ?? [];
    saved.removeAt(index);
    await prefs.setStringList('saved_questions', saved);
    await loadBookmarks();
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_questions');
    state = [];
  }
}

final bookmarkProvider = StateNotifierProvider<BookmarkNotifier, List<Map<String, String>>>((ref) {
  return BookmarkNotifier();
});