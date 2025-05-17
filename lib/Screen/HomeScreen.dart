import 'package:alemer_jobab/Screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'AllCategoriesScreen.dart';
import 'AllQuestionsScreen.dart';
import 'CategoryQuestionsScreen.dart';
import '../UiComponents/CustomDiolouge.dart';
import 'SavedQuestionsScreen.dart';
import '../State/providers.dart';
import '../UiComponents/card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;

  // Screens list - only contains home content
  final List<Widget> _screens = [
    HomeContent(),
    Container(), // Placeholder (not used)
    Container(), // Placeholder (not used)
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

  Route _createBottomToTopRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // Home - just update index, no navigation
      setState(() {
        _selectedIndex = 0;
      });
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // Search screen
      _controller.forward(from: 0.0);
      Navigator.of(context).push(_createBottomToTopRoute(SearchScreen()))
          .then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    } else if (index == 2) {
      // Saved screen
      Navigator.of(context).push(_createBottomToTopRoute(SavedScreen()))
          .then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 ? AppBar(
        backgroundColor: Colors.teal,
        title: Text('ইসলামিক Query', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => CustomDialog.show(context, ref),
          ),
        ],
      ) : null,
      body: _selectedIndex == 0 ? _screens[0] : Container(),
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
}class HomeContent extends ConsumerWidget {
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
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (_, __, ___) => AllCategoriesScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
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
      title: cat.title,  // Changed from category.title to cat.title
      imageUrl: cat.imageUrl,  // Changed from category.imageUrl to cat.imageUrl
      color: Colors.teal,
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => CategoryQuestionsScreen(category: cat.title), // Changed from category.title to cat.title
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0); // Starts from bottom
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
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
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (_, __, ___) => AllQuestionsScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
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