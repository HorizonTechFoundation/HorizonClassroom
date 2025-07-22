import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:dio/dio.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  

  String className = "Data Structures and Algorithms";
  bool isLoading = true;
  bool isError = false;
  int currentIndex = 0;
  String? selectedOption;
  bool isAnswered = false;
  int score = 0;
  final storage = FlutterSecureStorage();
  String? isLoggedIn;
  String classid="1";

  List<Map<String, dynamic>> questions = [];
  
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
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await readData();
      await getTestForClass();
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

  Future<void> getTestForClass() async {
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
        final response = await dio.get('$api/horizon001/api/students/gettestbyid/$classid/');
        print(response.data);
        setState(() {
          questions = List<Map<String, dynamic>>.from(response.data['testdata']['questions']);
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
            final retryResponse = await dio.get('$api/horizon001/api/students/gettestbyid/$classid/');
            setState(() {
              questions = List<Map<String, dynamic>>.from(retryResponse.data['testdata']['questions']);
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
        questions = [];
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
    
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (isError) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text("Failed to load questions")),
      );
    }
    else if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text("No Questions Available !")),
      );
    }

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

            // =============== QUESTION SPACE ================

            Container(
              width: width * 0.8,
              padding: EdgeInsets.all(width * 0.04),
              decoration: BoxDecoration(
                color: Color(0xFFb0ece0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child:Text(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      "Q${currentIndex + 1}: ${questions[currentIndex]['question']}",
                      style: GoogleFonts.amaranth(
                        fontSize: width * 0.045,
                      ),
                    ),
                  ),
                  
                  
                  SizedBox(height: height * 0.02),

                  // Options as Radio Buttons
                  ...List.generate(3, (index) {
                    String option = questions[currentIndex]["options"][index];
                    bool isSelected = selectedOption == option;
                    bool isCorrectAnswer = option == questions[currentIndex]["correctAnswer"];

                    return GestureDetector(
                      onTap: isAnswered ? null : () {
                        setState(() {
                          selectedOption = option;
                        });
                      },
                      child: SizedBox(
                        width: width * 0.7,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: height * 0.015, horizontal: width * 0.03),
                          margin: EdgeInsets.symmetric(vertical: height * 0.008),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                option,
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: isSelected ? const Color(0xFF08AD8C) : Colors.black54,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              // Show feedback icon only if answered & this option is selected
                              if (isAnswered && isSelected)
                                Icon(
                                  isCorrectAnswer ? Icons.check_circle : Icons.cancel,
                                  color: isCorrectAnswer ? Colors.green : Colors.red,
                                  size: width * 0.05,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),


                SizedBox(height: height * 0.02),


                SizedBox(
                  width: width * 0.7,
                  height: height * 0.055,
                  child:ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF08AD8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      if (!isAnswered) {
                        if (selectedOption == null) return;

                        setState(() {
                          isAnswered = true;
                          if (selectedOption == questions[currentIndex]["correctAnswer"]) {
                            score++;
                          } else {
                          }
                        });
                      } else {
                        if (currentIndex < questions.length - 1) {
                          setState(() {
                            currentIndex++;
                            selectedOption = null;
                            isAnswered = false;
                          });
                        } else {
                          Navigator.pushNamed(context, '/result', arguments: score);
                        }
                      }
                    },


                    child: Text(isAnswered ? "Next" : "Submit", 
                      style: GoogleFonts.amaranth(fontSize: width * 0.04, color: Colors.white),
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
