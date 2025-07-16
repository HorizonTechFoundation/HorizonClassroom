import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/second_screen.dart';
import '../screens/classroom_screen.dart';
import '../screens/schedule_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String second = '/second';
  static const String classroom = '/classroom';
  static const String schedule = '/schedule';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case second:
        return MaterialPageRoute(builder: (_) => const SecondScreen());
      case classroom:
        return MaterialPageRoute(builder: (_) => const ClassroomScreen());
      case schedule:
        return MaterialPageRoute(builder: (_) => const ScheduleScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined')),
          ),
        );
    }
  }
}
