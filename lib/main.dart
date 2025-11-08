import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '/utils/localization.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/calendar_page.dart';
import 'pages/statistics_page.dart';
import 'services/auth_services.dart';

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
        AppLocalizations.delegate,
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
            return MainApp(
              onToggleLanguage: _toggleLanguage,
              isEnglish:
                  _locale.languageCode == 'en',
            );
          } else {
            return AuthScreen(
              onToggleLanguage: _toggleLanguage,
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
  final VoidCallback onToggleLanguage;
  final bool isEnglish;

  const MainApp({
    super.key,
    required this.onToggleLanguage,
    required this.isEnglish,
  });

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(
      context,
    );

    // Fallback nếu localization chưa sẵn sàng
    if (localizations == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final List<Widget> _pages = [
      const HomePage(),
      const CalendarPage(),
      const StatisticsPage(),
      const ProfilePage(),
    ];

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
            label: localizations.bottomNavHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.calendar_today_outlined,
            ),
            activeIcon: const Icon(
              Icons.calendar_today,
            ),
            label:
                localizations.bottomNavCalendar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.bar_chart_outlined,
            ),
            activeIcon: const Icon(
              Icons.bar_chart,
            ),
            label:
                localizations.bottomNavStatistics,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.person_outlined,
            ),
            activeIcon: const Icon(Icons.person),
            label: localizations.bottomNavProfile,
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          // Switch ngôn ngữ
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(
                20,
              ),
              border: Border.all(
                color: Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nút VI
                GestureDetector(
                  onTap: () {
                    if (widget.isEnglish) {
                      widget.onToggleLanguage();
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.only(
                            topLeft:
                                Radius.circular(
                                  20,
                                ),
                            bottomLeft:
                                Radius.circular(
                                  20,
                                ),
                          ),
                      color: !widget.isEnglish
                          ? Colors.blue
                                .withOpacity(0.1)
                          : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        'VI',
                        style: TextStyle(
                          color: !widget.isEnglish
                              ? Colors.blue
                              : Colors.grey[600],
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                // Nút EN
                GestureDetector(
                  onTap: () {
                    if (!widget.isEnglish) {
                      widget.onToggleLanguage();
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.only(
                            topRight:
                                Radius.circular(
                                  20,
                                ),
                            bottomRight:
                                Radius.circular(
                                  20,
                                ),
                          ),
                      color: widget.isEnglish
                          ? Colors.blue
                                .withOpacity(0.1)
                          : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        'EN',
                        style: TextStyle(
                          color: widget.isEnglish
                              ? Colors.blue
                              : Colors.grey[600],
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: showLogin
          ? LoginPage(
              key: Key(
                'login_${widget.isEnglish ? 'en' : 'vi'}',
              ), // Thêm key để rebuild khi đổi ngôn ngữ
              onTapRegister: () => setState(
                () => showLogin = false,
              ),
            )
          : RegisterPage(
              key: Key(
                'register_${widget.isEnglish ? 'en' : 'vi'}',
              ), // Thêm key để rebuild khi đổi ngôn ngữ
              onTapLogin: () => setState(
                () => showLogin = true,
              ),
            ),
    );
  }
}
