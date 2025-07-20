import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController regNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Dio dio = Dio();
  bool _isLoading = false;
  final storage = FlutterSecureStorage();


  // -------------------- LOGIN ---------------------

  Future<void> loginStudent(BuildContext context) async {
    String regNo = regNoController.text.trim();
    String password = passwordController.text.trim();

    if (regNo.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter register number and password")),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final String jsonString = await rootBundle.loadString('assets/config.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final String api = jsonData['api'];
      final response = await dio.post(
        '$api/horizon001/api/students/login/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'register_number': regNo,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await storage.write(key: 'access', value: data['access_token']);
        await storage.write(key: 'refresh', value: data['refresh_token']);
        await storage.write(key: 'name', value: data['name']);
        await storage.write(key: 'regNo', value: data['register_number']);
        await storage.write(key: 'is_login', value: "1");
        print('Access Token: ${data['access_token']}');
        Navigator.pushNamed(context, '/');
      }
    } on DioException catch (e) {
      String errorMsg = 'Login failed';
      if (e.response != null) {
        errorMsg = e.response?.data['detail'] ?? 'Invalid credentials';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ------------------------------------------------------------------------

  @override
  void dispose() {
    regNoController.dispose();
    passwordController.dispose();
    super.dispose();
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
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // =============== HEAD SPACE ================

                SizedBox(
                  height: height * 0.04,
                  width: width,
                ),

                // =============== LOGIN IMAGE ================

                Image.asset(
                  'assets/LoginImage.png',
                  fit: BoxFit.contain,
                  width: width * 0.9,
                  height: height * 0.4,
                ),

                // =============== LOGIN TITLE ================

                SizedBox(
                  width: width * 0.8,
                  height: height * 0.1,
                  child: Text(
                    "Students Login",
                    style: GoogleFonts.amaranth(
                        fontSize: width * 0.08, color: const Color(0xFF08AD8C)),
                    textAlign: TextAlign.center,
                  ),
                ),

                // =============== LOGIN REG NO INPUT ================

                SizedBox(
                  width: width * 0.8,
                  child: TextField(
                    controller: regNoController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF0F0F0),
                        labelText: 'Registration Number',
                        labelStyle: GoogleFonts.amaranth(
                            fontSize: width * 0.04,
                            color: const Color.fromARGB(128, 0, 0, 0)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: width * 0.048, vertical: height * 0.021)),
                  ),
                ),
                SizedBox(
                  height: height * 0.015,
                ),

                // =============== LOGIN PASSWORD INPUT ================

                SizedBox(
                  width: width * 0.8,
                  child: TextField(
                    controller: passwordController,
                    obscureText: true, // Hide password text
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF0F0F0),
                        labelText: 'Password',
                        labelStyle: GoogleFonts.amaranth(
                            fontSize: width * 0.04,
                            color: const Color.fromARGB(128, 0, 0, 0)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: width * 0.048, vertical: height * 0.021)),
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),

                // =============== LOGIN BUTTON ================

                SizedBox(
                    height: height * 0.1,
                    width: width * 0.8,
                    child: Column(children: [
                      SizedBox(
                        height: height * 0.067,
                        width: width * 0.8,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF08AD8C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: _isLoading ? null : () => loginStudent(context),
                          child: Text(
                            "Login",
                            style: GoogleFonts.amaranth(
                                fontSize: width * 0.06, color: Colors.white),
                          ),
                        ),
                      )
                    ])),

                // =============== ALTERNATIVE TEXT ================
                
                SizedBox(
                  height: height * 0.1,
                  width: width * 0.8,
                  child: Text(
                    "* Get Login From Your Institute !",
                    style: GoogleFonts.balooBhai2(
                        fontSize: width * 0.03, color: const Color.fromARGB(255, 0, 0, 0)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
