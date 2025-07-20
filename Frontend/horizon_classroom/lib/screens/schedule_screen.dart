import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {

  List<Map<String, dynamic>> schedule = [];
  bool isLoading = true;
  bool isError = false;
  final storage = FlutterSecureStorage();
  String? isLoggedIn;

  // ======================= LOGOUT =======================

  void logout() async {
    await storage.deleteAll();
    Navigator.pushNamed(context, '/welcome');
  }

  // ------------------------------------------------------
  // ==================== READ DATA =======================

  Future<void> readData() async {
    isLoggedIn = await storage.read(key: "is_login") ?? "0";
    checkLoginStatus();
  }

  // ------------------------------------------------------
  // ================= CHECK LOGIN STATUS =================

  void checkLoginStatus() {
    if(isLoggedIn != "1"){
      Navigator.pushNamed(context, '/welcome');
    }
  }

  // ------------------------------------------------------
  // ================= FETCH SCHEDULE =====================

  final dio = Dio();

  void fetchSchedule() async {
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
      }

      dio.options.headers['Authorization'] = 'Bearer $accessToken';

      try {
        final response = await dio.get('$api/horizon001/api/students/scheduledclasses/');
        setState(() {
          schedule = List<Map<String, dynamic>>.from(response.data);
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
            final retryResponse = await dio.get('$api/horizon001/api/students/scheduledclasses/');
            setState(() {
              schedule = List<Map<String, dynamic>>.from(retryResponse.data);
              isLoading = false;
              isError = false;
            });
          } catch (_) {
            logout();
          }
        } else {
          rethrow;
        }
      }
    } catch (e) {
      setState(() {
        schedule = [];
        isLoading = false;
        isError = true;
      });
      print('Schedule fetch failed: $e');
    }
  }


  // ------------------------------------------------------
  // ================= INITIALIZATION =====================

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await readData();
      if (isLoggedIn == "1") {
        fetchSchedule();
      }
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
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Schedule Classes", 
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              fetchSchedule();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
        ? const Center(child: CircularProgressIndicator())
        : isError
        ? Center(child: Text("Failed to load schedule. Please try again."))
        : schedule.isEmpty
        ? Center(
            child: Text(
              "No classes scheduled.",
              style: GoogleFonts.basic(fontSize: width * 0.05, color: Colors.black54),
            ),
          ):
        ListView.builder(
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
