import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {

  List<Map<String, dynamic>> schedule = [
    {
      "classname": "Environmental And Social Impact Assessment",
      "timeStart": "9:00 AM",
      "timeEnd": "10:30 AM",
      "takenBy": "Dr. Smith",
      "venue": "B3L02"
    },
    {
      "classname": "Environmental And Social Impact Assessment",
      "timeStart": "9:00 AM",
      "timeEnd": "10:30 AM",
      "takenBy": "Dr. Smith",
      "venue": "B3L02"
    },
    {
      "classname": "Environmental And Social Impact Assessment",
      "timeStart": "9:00 AM",
      "timeEnd": "10:30 AM",
      "takenBy": "Dr. Smith",
      "venue": "B3L02"
    },
  ];

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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Schedule Classes", 
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        )
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: height * 0.02),
          itemCount: schedule.length,
          itemBuilder: (context, index) {
            return Center(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: const Color(0xFF08AD8C),
                margin: EdgeInsets.symmetric(vertical: height * 0.01),
                child: SizedBox(
                  height: height * 0.2,
                  width: width * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width * 0.8,
                        child: Text(
                          schedule[index]['classname'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.average(
                            fontSize: width * 0.05,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      SizedBox(
                        width: width * 0.8,
                        child: Text(
                          schedule[index]['takenBy'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.basic(
                            fontSize: width * 0.05,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.005,
                      ),
                      SizedBox(
                        width: width * 0.8,
                        child: Text(
                          "${schedule[index]['timeStart']} - ${schedule[index]['timeEnd']} at ${schedule[index]['venue']}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.basic(
                            fontSize: width * 0.045,
                            color: const Color.fromARGB(141, 255, 255, 255),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),    
    );
  }
}
