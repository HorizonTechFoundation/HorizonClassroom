import 'package:flutter/material.dart';


class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

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
      appBar: AppBar(title: const Text("Result Screen")),
      body: Center(
        child: Column(
          children:[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/classroom');
              },
              child: const Text("Go to Classroom"),
            ),
          ],
        )
      ),
    );
  }
}
