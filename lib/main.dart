import 'package:alemer_jobab/providers.dart';
import 'package:alemer_jobab/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  timeago.setLocaleMessages('bn', timeago.BnMessages());

  await Firebase.initializeApp();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'দীনুত্তর',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'HindSiliguri',
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'HindSiliguri',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          color: Colors.grey[900],
          titleTextStyle: TextStyle(
            fontFamily: 'HindSiliguri',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      themeMode: themeMode == AppThemeMode.light ? ThemeMode.light : ThemeMode.dark,
      home: const SplashScreen(), // Start with splash screen
    );
  }
}