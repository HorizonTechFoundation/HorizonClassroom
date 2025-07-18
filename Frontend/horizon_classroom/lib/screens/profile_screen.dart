import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String name="John Doe";
  String regNo="953622244000";

  late TextEditingController _nameController;
  late TextEditingController _regController;

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
    _nameController = TextEditingController(text: name);
    _regController = TextEditingController(text: regNo);
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
      appBar: AppBar(),
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
                    fontSize: width * 0.05,
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
                    fontSize: width * 0.05,
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
