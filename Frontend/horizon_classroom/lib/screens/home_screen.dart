import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String? userName;

  Map<String, dynamic> currentClass = {};
  bool isLoading = true;
  bool isError = false;
  final storage = FlutterSecureStorage();
  String? isLoggedIn;


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
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await readData();
      await getCurrentClass();
    });
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
        print(response.data);
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

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: height * 0.05),
            child: Column(
              children:[
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
                          Text(userName ?? "Unknown User",
                            style: GoogleFonts.amaranth(fontSize: width * 0.084, color:Color(0xFF08AD8C)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Color.fromARGB(255, 255, 255, 255)),
                            style: IconButton.styleFrom(
                              backgroundColor: Color(0xFF08AD8C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(360),
                              ),
                            ),
                            onPressed: () {
                              getCurrentClass();
                            },
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
                        ]
                      )
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
                currentClass.isNotEmpty
                ? SizedBox(
                    height: height * 0.15,
                    width: width * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: Text(
                            currentClass['classname'] ?? "Error In Fetching Data",
                            style: GoogleFonts.amaranth(fontSize: width * 0.053, color: const Color(0xFF08AD8C)),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ),
                        Text(
                          currentClass['takenBy'] ?? "Error in Fetching Data",
                          style: GoogleFonts.basic(fontSize: width * 0.048, color: Colors.black),
                        ),
                        Text(
                          '${currentClass['timeFrom'] ?? "Error"} - ${currentClass['timeEnd'] ?? "Error"} at ${currentClass['venue'] ?? "Error"}',
                          style: GoogleFonts.basic(fontSize: width * 0.043, color: Colors.black54),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: height * 0.15,
                    width: width * 0.8,
                    child: Center(
                      child: isLoading
                          ? CircularProgressIndicator()
                          : isError
                              ? Text(
                                  "Failed to load current class",
                                  style: GoogleFonts.basic(fontSize: width * 0.05, color: Colors.red),
                                )
                              : Text(
                                  "No current class scheduled",
                                  style: GoogleFonts.basic(fontSize: width * 0.05, color: Colors.black54),
                                ),
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
          )
        )
      ),
    );
  }
}
