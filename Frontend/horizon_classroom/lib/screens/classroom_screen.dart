import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';


class ClassroomScreen extends StatefulWidget {
  const ClassroomScreen({super.key});

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> with WidgetsBindingObserver {

  final storage = FlutterSecureStorage();
  String? isLoggedIn;
  Map<String, dynamic> currentClass = {};
  bool isLoading = true;
  bool isError = false;
  String? userName;


  Future<void> readData() async {
    isLoggedIn = await storage.read(key: "is_login") ?? "0";
    final name = await storage.read(key: "name") ?? "Unknown User";
    setState(() {
      userName = name;
    });
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
    // WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await readData();
      await getCurrentClass();
    });
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (currentClass.isNotEmpty && (state == AppLifecycleState.paused || state == AppLifecycleState.inactive)) {
  //     _showLeaveConfirmation();
  //   }
  // }

  Future<bool> _showLeaveConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // force user to choose explicitly
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.exit_to_app, color: Color(0xFF08AD8C), size: 28),
            const SizedBox(width: 12),
            Text(
              "Leave Class?",
              style: GoogleFonts.amaranth(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF08AD8C),
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to leave the current class? Your attendance might be affected.",
          style: GoogleFonts.basic(
            fontSize: 16,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
        actionsPadding: const EdgeInsets.only(right: 16, bottom: 8),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              "Cancel",
              style: GoogleFonts.basic(fontSize: 16),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 194, 22, 22),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              "Leave",
              style: GoogleFonts.basic(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }



  
  


  // ------------------------------------------------------
  // ======================= LOGOUT =======================

  void logout() async {
    await storage.deleteAll();
    Navigator.pushNamed(context, '/welcome');
  }

  // ------------------------------------------------------
  // ================== GET CURRENT CLASS =================

  final dio = Dio();

  Future<void> getCurrentClass() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      final String jsonString = await rootBundle.loadString('assets/config.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final String api = jsonData['api'];

      String? accessToken = await storage.read(key: 'access_token');
      String? refreshToken = await storage.read(key: 'refresh_token');

      if (accessToken == null || refreshToken == null) {
        logout();
        return;
      }

      dio.options.headers['Authorization'] = 'Bearer $accessToken';

      try {
        final response = await dio.get('$api/horizon001/api/students/currentclass/');
        // print(response.data);
        setState(() {
          currentClass = Map<String, dynamic>.from(response.data);
          isLoading = false;
          isError = false;
        });
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          try {
            final refreshResponse = await dio.post(
              '$api/horizon001/api/students/token/refresh/',
              data: {'refresh': refreshToken},
            );
            accessToken = refreshResponse.data['access'];
            await storage.write(key: 'access_token', value: accessToken);
            dio.options.headers['Authorization'] = 'Bearer $accessToken';
            final retryResponse = await dio.get('$api/horizon001/api/students/currentclass/');
            setState(() {
              currentClass = Map<String, dynamic>.from(retryResponse.data);
              isLoading = false;
              isError = false;
            });
          } catch (e) {
            logout();
          }
        } else {
          rethrow;
        }
      }
    } catch (e) {
      setState(() {
        currentClass = {};
        isLoading = false;
        isError = true;
      });
      print('Schedule fetch failed: $e');
    }
  }
  

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    int classPresent = 52;
    int classTotal = 55;

    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (isError) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,),
        body: Center(child: Text("Failed to load questions")),
      );
    } else if(currentClass.isEmpty){
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,),
        body: Center(child: Text("The Class Was Ended !")),
      );
    }

    return PopScope(
      canPop: currentClass.isEmpty, // allow back only if no active class
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && currentClass.isNotEmpty) {
          final shouldLeave = await _showLeaveConfirmation();
          if (shouldLeave) {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                getCurrentClass();
              },
              tooltip: 'Refresh',
            ),
          ],),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children:[

              // ================ HEAD SPACE ================

              SizedBox(
                height: height * 0.026,
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
                        child:Text(currentClass['classname']?? "Error In Fetching Data",
                        style: GoogleFonts.amaranth(fontSize: width * 0.053, color: const Color(0xFF08AD8C)),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                    Text("$classPresent/$classTotal",
                      style: GoogleFonts.amaranth(fontSize: width * 0.1, color: Color(0xFF08AD8C)),
                    ),
                    Text(currentClass['takenBy'] ?? "Error in Fetching Data",
                      style: GoogleFonts.basic(fontSize: width * 0.048, color: Colors.black),
                    ),
                    Text('${currentClass['timeStart'] ?? "Error"} - ${currentClass['timeEnd'] ?? "Error"} at ${currentClass['venue'] ?? "Error"}',
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
                        print("currentClass: $currentClass");
                        Navigator.pushNamed(context, '/test', 
                        arguments: currentClass);
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
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("You Raised Hand !"),
                            backgroundColor: const Color.fromARGB(255, 66, 66, 66),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }, 
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
                        onPressed: () async {
                          final shouldLeave = await _showLeaveConfirmation();
                          if (shouldLeave) {
                            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                          }
                        },
                        child: Text(
                          "Leave",
                          style: GoogleFonts.basic(fontSize: width * 0.05, color: Colors.white),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              
            ],
          )
        ),
      )
    );
  }
}
