import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'AboutUs.dart';
import 'Aboutme.dart';
import 'providers.dart';

class CustomDialog extends ConsumerWidget {
  const CustomDialog({super.key});

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'মেনু',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.tealAccent : Colors.teal[800],
                shadows: isDarkMode
                    ? [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.teal.withOpacity(0.5),
                    offset: const Offset(1.0, 1.0),
                  )
                ]
                    : null),
          ),
          const SizedBox(height: 12),
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.teal[800]!, Colors.teal[400]!, Colors.teal[800]!]
                    : [Colors.teal[100]!, Colors.teal[300]!, Colors.teal[100]!],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogItem(
      BuildContext context, IconData icon, String text, bool isDarkMode, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap ?? () {
            Navigator.pop(context);
          },
          splashColor: Colors.teal.withOpacity(0.2),
          highlightColor: Colors.teal.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isDarkMode ? Colors.tealAccent : Colors.teal[700],
                ),
                const SizedBox(width: 16),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.teal[50] : Colors.teal[900],
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: isDarkMode ? Colors.teal[300] : Colors.teal[500],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSwitch(BuildContext context, WidgetRef ref, bool isDarkMode) {
    final currentTheme = ref.watch(themeProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(
              Icons.palette,
              size: 24,
              color: isDarkMode ? Colors.tealAccent : Colors.teal[700],
            ),
            const SizedBox(width: 16),
            Text(
              'থিম',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.teal[50] : Colors.teal[900],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: currentTheme == AppThemeMode.dark
                        ? [
                      Colors.grey[800]!,
                      Colors.grey[700]!,
                    ]
                        : [
                      Colors.teal[100]!,
                      Colors.teal[200]!,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      left: currentTheme == AppThemeMode.dark ? 30 : 0,
                      right: currentTheme == AppThemeMode.dark ? 0 : 30,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentTheme == AppThemeMode.dark
                              ? Colors.tealAccent
                              : Colors.teal,
                        ),
                        child: Icon(
                          currentTheme == AppThemeMode.dark
                              ? Icons.nightlight
                              : Icons.wb_sunny,
                          size: 16,
                          color: currentTheme == AppThemeMode.dark
                              ? Colors.grey[900]
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.teal[800]!, Colors.teal[400]!, Colors.teal[800]!]
                    : [Colors.teal[100]!, Colors.teal[300]!, Colors.teal[100]!],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'সংস্করণ ১.০.০',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.teal[300] : Colors.teal[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [
              Colors.grey[850]!,
              Colors.grey[900]!,
            ]
                : [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.5 : 0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context, isDarkMode),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _buildThemeSwitch(context, ref, isDarkMode),
                    const SizedBox(height: 8),
                    _buildDialogItem(
                      context,
                      Icons.info_outline,
                      'App সম্পর্কে',
                      isDarkMode,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                        );
                      },
                    ),                    _buildDialogItem(
                      context,
                      Icons.people_outline,
                      'App নির্মাতা',
                      isDarkMode,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AboutMe()),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildDialogItem(
                      context,
                      Icons.star_outline,
                      'রেটিং দিন',
                      isDarkMode,
                    ),
                    const SizedBox(height: 8),
                    _buildDialogItem(
                      context,
                      Icons.share_outlined,
                      'শেয়ার করুন',
                      isDarkMode,
                    ),
                  ],
                ),
              ),
            ),
            _buildFooter(context, isDarkMode),
          ],
        ),
      ),
    );
  }

  static void show(BuildContext context, WidgetRef ref) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Dialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const CustomDialog();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.fastEaseInToSlowEaseOut,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}