import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/calendar_page.dart';
import 'pages/statistics_page.dart';
import 'services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import ''; // nếu bạn dùng gen-l10n

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale(
    'vi',
  ); // mặc định là tiếng Việt

  void _toggleLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'vi'
          ? const Locale('en')
          : const Locale('vi');
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final Stream<User?> authStream =
        authService.userChanges;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate, // gen-l10n
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: StreamBuilder<User?>(
        stream: authStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            return const MainApp();
          } else {
            return AuthScreen(
              onToggleLanguage:
                  _toggleLanguage, // truyền callback xuống
              isEnglish:
                  _locale.languageCode == 'en',
            );
          }
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CalendarPage(),
    StatisticsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) =>
            setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: t.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.calendar_today_outlined,
            ),
            activeIcon: const Icon(
              Icons.calendar_today,
            ),
            label: t.calendar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.bar_chart_outlined,
            ),
            activeIcon: const Icon(
              Icons.bar_chart,
            ),
            label: t.statistics,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.person_outlined,
            ),
            activeIcon: const Icon(Icons.person),
            label: t.profile,
          ),
        ],
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  final VoidCallback onToggleLanguage;
  final bool isEnglish;

  const AuthScreen({
    super.key,
    required this.onToggleLanguage,
    required this.isEnglish,
  });

  @override
  State<AuthScreen> createState() =>
      _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.isEnglish
              ? "Language: EN"
              : "Ngôn ngữ: VI",
          style: const TextStyle(
            color: Colors.blue,
          ),
        ),
        actions: [
          Switch(
            value: widget.isEnglish,
            onChanged: (value) =>
                widget.onToggleLanguage(),
            activeColor: Colors.blue,
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(
          milliseconds: 300,
        ),
        child: showLogin
            ? LoginPage(
                key: const ValueKey('login'),
                onTapRegister: () => setState(
                  () => showLogin = false,
                ),
              )
            : RegisterPage(
                key: const ValueKey('register'),
                onTapLogin: () => setState(
                  () => showLogin = true,
                ),
              ),
      ),
    );
  }
}
