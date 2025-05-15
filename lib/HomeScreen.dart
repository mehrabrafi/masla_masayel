import 'package:alemer_jobab/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'AllCategoriesScreen.dart';
import 'AllQuestionsScreen.dart';
import 'CategoryQuestionsScreen.dart';
import 'CustomDiolouge.dart';
import 'SavedQuestionsScreen.dart';
import 'providers.dart';
import 'ui.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;

  final List<Widget> _screens = [
    HomeContent(),
    Container(),
    SavedScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      _controller.forward(from: 0.0);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SearchScreen()),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 2 ? null : AppBar(
        backgroundColor: Colors.teal,
        title: Text('মাসলা-মাসায়েল', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => CustomDialog.show(context, ref),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(1),
        backgroundColor: Colors.teal,
        child: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          ),
          child: Icon(Icons.search, size: 28, color: Colors.white),
        ),
        shape: CircleBorder(),
        elevation: 8,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 16,
        color: Colors.teal,
        height: 70,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.home, size: 28),
                color: Colors.white,
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: Icon(Icons.bookmark_add_outlined, size: 28),
                color: Colors.white,
                onPressed: () => _onItemTapped(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredCategories = ref.watch(featuredCategoriesProvider);
    final featuredQuestions = ref.watch(featuredQuestionsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final questionsAsync = ref.watch(questionsProvider);

    if (categoriesAsync.isLoading || questionsAsync.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (categoriesAsync.hasError || questionsAsync.hasError) {
      return Center(child: Text('Error loading data'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('বিষয়ভিত্তিক বিভাগ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AllCategoriesScreen())),
                child: Text('সব দেখুন', style: TextStyle(color: Theme.of(context).primaryColor)),
              )],
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: 4),
                ...featuredCategories.map((cat) => CategoryCard(
                  title: cat.title,
                  imageUrl: cat.imageUrl,
                  color: Colors.teal,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CategoryQuestionsScreen(category: cat.title)),
                  ),
                )),
                SizedBox(width: 4),
              ],
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('প্রশ্নসমূহ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AllQuestionsScreen())),
                child: Text('সব দেখুন', style: TextStyle(color: Theme.of(context).primaryColor)),
              )],
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: featuredQuestions.length,
            itemBuilder: (context, index) {
              final q = featuredQuestions[index];
              return QuestionCard(
                question: q.question,
                scholar: q.scholar,
                answer: q.answer,
              );
            },
          ),
        ],
      ),
    );
  }
}