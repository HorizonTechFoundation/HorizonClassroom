import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  String className = "Data Structures and Algorithms";

  String score = "0";
  String classid = "0";
  String totalScore = "0";

  Map<String, String> results =
    {
      "position1":"John Doe",
      "position2":"Jane Smith",
      "position3":"Alice Johnson",
    };

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
  // ================== GET CLASSROOM =====================

  bool _didInit = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      print("Received arguments: $args");

      if (args is Map<String, dynamic>) {
        score = args['score'].toString();
        totalScore = args['total'].toString();
        classid = args['classid'].toString();
        className = args['className'] ?? "Unknown Class";
      } else {
        print("Arguments missing or wrong type!");
      }

      _didInit = true;
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


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Center(
        child: Column(
          children:[
            // ================ CLASS INFO ================

            SizedBox(
              height: height * 0.1,
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
                ],
              ),
            ),

            // =============== AD SPACE =================

            SizedBox(
              width: width * 0.8,
              child: Padding( 
                padding: EdgeInsets.symmetric(vertical: height * 0.04),
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

            // ================ YOUR SCORE ================

            SizedBox(
              width: width * 0.8,
              height: height * 0.1,
              child: Text("$score/$totalScore",
                style: GoogleFonts.amaranth(fontSize: width * 0.1, color: const Color(0xFF08AD8C)),
                textAlign: TextAlign.center,
              ),
            ),

            // ================ RESULTS ================

            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              child: SizedBox(
                width: width * 0.85,
                height: height * 0.35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🏆 Top Performers",
                      style: GoogleFonts.amaranth(
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF08AD8C),
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    ...results.entries.map((entry) {
                      int pos = int.parse(entry.key.replaceAll("position", ""));
                      Color iconColor;
                      switch (pos) {
                        case 1:
                          iconColor = Colors.amber;
                          break;
                        case 2:
                          iconColor = const Color.fromARGB(255, 212, 212, 212);
                          break;
                        case 3:
                          iconColor = const Color.fromARGB(255, 165, 80, 0);
                          break;
                        default:
                          iconColor = Colors.blueGrey;
                      }

                      return Card(
                        elevation: 4,
                        color: const Color(0xFF08AD8C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.symmetric(vertical: height * 0.01),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(vertical: height * 0.01 , horizontal: width * 0.03),
                          child: Row(
                            children: [
                              Card(
                                color: iconColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(360),
                                ),
                                child: SizedBox(
                                  width: width * 0.09,
                                  height: width * 0.09,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [Text(pos.toString(),
                                    style: GoogleFonts.amaranth(
                                      fontSize: width * 0.045,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                    )
                                  ]
                                  ),
                                ),
                              ),
                              SizedBox(width: width * 0.04),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: GoogleFonts.amaranth(
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),


            
          ],
        )
      ),
    );
  }
}
