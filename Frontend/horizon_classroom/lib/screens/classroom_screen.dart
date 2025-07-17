import 'package:flutter/material.dart';


class ClassroomScreen extends StatefulWidget {
  const ClassroomScreen({super.key});

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {

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
      appBar: AppBar(title: const Text("Classroom Screen")),
      body: Center(
        child: Column(
          children:[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/notes');
              },
              child: const Text("Notes"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/test');
              },
              child: const Text("Test"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Raise Hand"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text("Leave"),
            ),
          ],
        )
      ),
    );
  }
}
