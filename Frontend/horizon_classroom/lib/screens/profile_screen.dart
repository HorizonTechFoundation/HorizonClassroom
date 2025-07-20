import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String name="UnKnown";
  String regNo="00000000";
  final storage = FlutterSecureStorage();
  String? isLoggedIn;

  TextEditingController? _nameController;
  TextEditingController? _regController;

  Future<void> readData() async {
    isLoggedIn = await storage.read(key: "is_login") ?? "0";
     final nameVal = await storage.read(key: "name") ?? name;
    final regVal = await storage.read(key: "regNo") ?? regNo;

    setState(() {
      _nameController = TextEditingController(text: nameVal);
      _regController = TextEditingController(text: regVal);
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(backgroundColor: Colors.white,),
      body: Center(
        child: Column(
          children:[

            // =============== HEAD SPACE ================

            SizedBox(
              height: height * 0.05,
              width: width,
            ),

            // ================ PROFILE IMAGE ================

            Image.asset(
                'assets/ProfileImage.png',
                fit: BoxFit.contain,
                width: width,
                height: height * 0.3,
            ),

            // =============== SPACE ================

            SizedBox(
              height: height * 0.05,
              width: width,
            ),

            // ================ PROFILE TITLE ================

            SizedBox(
              width: width * 0.8,
              height: height * 0.1,
              child: Text("Students Details",
                style: GoogleFonts.amaranth(fontSize: width * 0.08, color: const Color(0xFF08AD8C)),
                textAlign: TextAlign.center,
              ),
            ),

            // ================ PROFILE DETAILS ================

            SizedBox(
              width: width * 0.8,
              height: height * 0.1,
              child: TextField(
                controller: _nameController,
                readOnly: true, // Makes the field uneditable
                style: GoogleFonts.amaranth(fontSize: width * 0.045, color: const Color.fromARGB(183, 0, 0, 0)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF0F0F0),
                  labelText: 'Name',
                  labelStyle: GoogleFonts.amaranth(
                    fontSize: width * 0.04,
                    color: const Color.fromARGB(128, 0, 0, 0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: width * 0.048,
                    vertical: height * 0.021,
                  ),
                ),
              ),
            ),

            SizedBox(
              width: width * 0.8,
              height: height * 0.1,
              child: TextField(
                controller: _regController,
                readOnly: true, // Makes the field uneditable
                style: GoogleFonts.amaranth(fontSize: width * 0.045, color: const Color.fromARGB(183, 0, 0, 0)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF0F0F0),
                  labelText: 'Registration Number',
                  labelStyle: GoogleFonts.amaranth(
                    fontSize: width * 0.04,
                    color: const Color.fromARGB(128, 0, 0, 0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: width * 0.048,
                    vertical: height * 0.021,
                  ),
                ),
              ),
            ),

            // ================ LOGOUT BUTTON ================

            SizedBox(
              height: height * 0.1,
              width: width * 0.8,
              child: Column(
                children:[
                  SizedBox(
                    height: height * 0.067,
                    width: width * 0.8,
                    child:ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF61C1C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/welcome');
                      },
                      child: Text("Logout",
                        style: GoogleFonts.amaranth(fontSize: width*0.06, color: Colors.white),
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
