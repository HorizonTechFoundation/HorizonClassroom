import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // ================= CHECK LOGIN STATUS =================

  bool isLoggedIn = true;
  void checkLoginStatus() {
    if(!isLoggedIn){
      Navigator.pushNamed(context, '/welcome');
    }
  }

  // ------------------------------------------------------
  // ================= INITIALIZATION =====================

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLoginStatus();
    });
  }

  // ------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Screen")),
      body: Center(
        child: Column(
          children:[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/classroom');
              },
              child: const Text("Join Class"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/schedule');
              },
              child: const Text("View Scheduled Classes"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: const Text("Profile"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/splash');
              },
              child: const Text("splash"),
            ),
          ],
        )
      ),
    );
  }
}
