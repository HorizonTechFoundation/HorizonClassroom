import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/classroom_screen.dart';
import '../screens/schedule_screen.dart';
import '../screens/profile_screen.dart';

import '../screens/classroom_utils/test_screen.dart';
import '../screens/classroom_utils/result_screen.dart';
import '../screens/classroom_utils/notes_screen.dart';

import '../screens/login_screen.dart';
import '../screens/welcome_screen.dart';

import '../screens/splash_screen.dart';


class AppRoutes {
  static const String home = '/';
  static const String second = '/second';
  static const String classroom = '/classroom';
  static const String schedule = '/schedule';
  static const String profile = '/profile';

  static const String test = '/test';
  static const String result = '/result';
  static const String notes = '/notes';

  static const String login = '/login';
  static const String welcome = '/welcome';

  static const String splash = '/splash';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case classroom:
        return MaterialPageRoute(builder: (_) => const ClassroomScreen());
      case schedule:
        return MaterialPageRoute(builder: (_) => const ScheduleScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      
      case test:
        return MaterialPageRoute(builder: (_) => const TestScreen());
      case result:
        return MaterialPageRoute(builder: (_) => const ResultScreen());      
      case notes:
        return MaterialPageRoute(builder: (_) => const NotesScreen());
         
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined')),
          ),
        );
    }
  }
}
