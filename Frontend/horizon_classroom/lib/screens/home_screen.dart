import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String userName = "John Doe";

    String className = "Data Structures and Algorithms";
    String classTakenBy = "Chocka D Lingam";
    String classTimeFrom = "10:00 AM";
    String classTimeTo = "10:50 AM";
    String classVenue = "B3L02";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children:[
            SizedBox(
              height: height * 0.126,
              width: width,
            ),
            SizedBox(
              height: height * 0.1,
              width: width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hi !",
                        style: GoogleFonts.amaranth(fontSize: width * 0.072, color:Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Text(userName.isNotEmpty ? userName : "Unknown User",
                        style: GoogleFonts.amaranth(fontSize: width * 0.084, color:Color(0xFF08AD8C)),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_rounded, color:Color.fromARGB(255, 255, 255, 255)),
                    style: IconButton.styleFrom(
                      backgroundColor: Color(0xFF08AD8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(360),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.05,
              width: width,
            ),
            Image.asset(
                'assets/HomeImage.png',
                fit: BoxFit.contain,
                width: width * 0.55,
                height: height * 0.25,
            ),
            SizedBox(
              height: height * 0.02,
              width: width,
            ),
            SizedBox(
              height: height * 0.15,
              width: width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      child:Text(className,
                      style: GoogleFonts.amaranth(fontSize: width * 0.053, color: const Color(0xFF08AD8C)),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                  Text(classTakenBy,
                    style: GoogleFonts.basic(fontSize: width * 0.048, color: Colors.black),
                  ),
                  Text('$classTimeFrom - $classTimeTo at $classVenue',
                    style: GoogleFonts.basic(fontSize: width * 0.043, color: Colors.black54),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.01,
              width: width,
            ),
            SizedBox(
              height: height * 0.2,
              width: width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  SizedBox(
                    width: width * 0.8,
                    height: height * 0.067,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF08AD8C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/classroom');
                      },
                      child: Text("Join Class", 
                        style: GoogleFonts.amaranth(fontSize: width * 0.05, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.8,
                    height: height * 0.067,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCDEBE5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/schedule');
                      },
                      child: Text("View Scheduled Classes",
                        style: GoogleFonts.amaranth(fontSize: width * 0.05, color: const Color(0xFF018369)),
                      ),
                    ),
                  )
                ]
              )
            ),
          ],
        )
      ),
    );
  }
}
