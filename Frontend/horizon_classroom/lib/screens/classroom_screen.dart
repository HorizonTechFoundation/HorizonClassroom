import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class ClassroomScreen extends StatefulWidget {
  const ClassroomScreen({super.key});

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {

  final storage = FlutterSecureStorage();
  String? isLoggedIn;


  Future<void> readData() async {
    isLoggedIn = await storage.read(key: "is_login") ?? "0";
    checkLoginStatus();
  }

  // ================= CHECK LOGIN STATUS =================

  void checkLoginStatus() {
    if(isLoggedIn != "1"){
      Navigator.pushNamed(context, '/welcome');
    }
  }

  // ------------------------------------------------------
  // ================= INITIALIZATION =====================

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      readData();
    });
  }

  // ------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String className = "Data Structures and Algorithms";
    String classTakenBy = "Chocka D Lingam";
    String classTimeFrom = "10:00 AM";
    String classTimeTo = "10:50 AM";
    String classVenue = "B3L02";
    int classPresent = 52;
    int classTotal = 55;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children:[

            // ================ HEAD SPACE ================

            SizedBox(
              height: height * 0.126,
              width: width,
            ),

            // ================ CLASS INFO ================

            SizedBox(
              height: height * 0.2,
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
                  Text("$classPresent/$classTotal",
                    style: GoogleFonts.amaranth(fontSize: width * 0.1, color: Color(0xFF08AD8C)),
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

            // =============== AD SPACE =================

            SizedBox(
              width: width * 0.8,
              child: Padding( 
                padding: EdgeInsets.symmetric(vertical: height * 0.06),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    SizedBox(
                      width: width * 0.8,
                      height: (width * 0.8)*0.5625, // 16:9 aspect ratio
                      child: ColoredBox(color: Colors.cyan)
                    )
                  ],
                )
              ),
            ),

            // =============== WARN ==================

            SizedBox(
              width: width * 0.8,
              height: height * 0.1,
              child: Text(
                "*During Class Time Don’t Switch Tab , Use Split Screen or Open Notification Bar Otherwise You Will Mark As Absent During Class",
                style: GoogleFonts.basic(fontSize: width * 0.038, color: const Color.fromARGB(255, 0, 0, 0)),
                textAlign: TextAlign.center,
              ),
            ),

            // =============== BUTTONS =================

            SizedBox(
              width: width * 0.8,
              height: height * 0.12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.filled(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF08AD8C),
                      shape: const CircleBorder(),
                      padding: EdgeInsets.all(width * 0.035),
                    ),
                    tooltip: 'View Notes',
                    onPressed: () {
                      Navigator.pushNamed(context, '/notes');
                    }, 
                    icon: Icon(Icons.note_alt_outlined, color: Colors.white, size:width*0.06)
                  ),
                  IconButton.filled(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF08AD8C),
                      shape: const CircleBorder(),
                      padding: EdgeInsets.all(width * 0.035),
                    ),
                    tooltip: 'Take Test',
                    onPressed: () {
                      Navigator.pushNamed(context, '/test');
                    },
                    icon: Icon(Icons.question_answer_outlined, color: Colors.white, size:width*0.06)
                  ),
                  IconButton.filled(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF08AD8C),
                      shape: const CircleBorder(),
                      padding: EdgeInsets.all(width * 0.035),
                    ),
                    tooltip: 'Raise Hand',
                    onPressed: () {}, 
                    icon: Icon(Icons.back_hand_outlined, color: Colors.white, size:width*0.06)
                  ),
                  SizedBox(
                    width: width * 0.25,
                    height: (width * 0.035)+(width * 0.035)+(width * 0.06),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF61C1C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      child: Text("Leave", 
                        style: GoogleFonts.basic(fontSize: width * 0.05, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
            
          ],
        )
      ),
    );
  }
}
