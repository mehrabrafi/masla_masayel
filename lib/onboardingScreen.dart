import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeScreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  bool _isLastPage = false;

  final List<Map<String, dynamic>> onboardingData = [
    {
      "image": "assets/o1.png",
      "text": "প্রাত্যহিক জীবনের যাবতীয় ইসলামিক প্রশ্ন এখন এক অ্যাপে",
      "bgColor": Color(0xFFE0F2F1), // Light teal background
      "textColor": Color(0xFF00796B), // Dark teal text
    },
    {
      "image": "assets/on2.png",
      "text": "নির্ভরযোগ্য আলেমদের  মাধ্যমে প্রমাণসহ উত্তর",
      "bgColor": Color(0xFFB2DFDB), // Medium teal background
      "textColor": Color(0xFF004D40), // Darker teal text
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _isLastPage = _pageController.page! >= onboardingData.length - 0.5;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        color: onboardingData[_currentIndex]["bgColor"],
        child: Stack(
          children: [
            // Decorative elements with teal colors
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: onboardingData[_currentIndex]["textColor"].withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: onboardingData[_currentIndex]["textColor"].withOpacity(0.1),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextButton(
                        onPressed: _completeOnboarding,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: onboardingData[_currentIndex]["textColor"],
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: onboardingData.length,
                      onPageChanged: (index) {
                        setState(() => _currentIndex = index);
                      },
                      itemBuilder: (context, index) {
                        final data = onboardingData[index];

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Local Image
                              Container(
                                height: isTablet ? 350 : 250,
                                child: Image.asset(
                                  data["image"],
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: 40),
                              // Animated Text
                              AnimatedSwitcher(
                                duration: Duration(milliseconds: 500),
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(0, 0.2),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Text(
                                  key: ValueKey(data["text"]),
                                  data["text"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isTablet ? 26 : 20,
                                    fontWeight: FontWeight.w700,
                                    color: data["textColor"],
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: isTablet ? 40 : 20,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: [
                        // Dot Indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            onboardingData.length,
                                (index) => AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: _currentIndex == index ? 24 : 8,
                              height: 8,
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: _currentIndex == index
                                    ? onboardingData[_currentIndex]["textColor"]
                                    : onboardingData[_currentIndex]["textColor"].withOpacity(0.3),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        // Animated Button - Now using teal colors
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          width: _isLastPage ? size.width * 0.8 : 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: _isLastPage ? BoxShape.rectangle : BoxShape.circle,
                            borderRadius: _isLastPage ? BorderRadius.circular(30) : null,
                            color: Colors.teal, // Using your app's primary teal color
                            boxShadow: [
                              BoxShadow(
                                color: Colors.teal.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: _isLastPage ? BorderRadius.circular(30) : null,
                              onTap: () {
                                if (_currentIndex < onboardingData.length - 1) {
                                  _pageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeOut,
                                  );
                                } else {
                                  _completeOnboarding();
                                }
                              },
                              child: Center(
                                child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 300),
                                  child: _isLastPage
                                      ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Get Started',
                                        style: TextStyle(
                                          fontSize: isTablet ? 18 : 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                    ],
                                  )
                                      : Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}