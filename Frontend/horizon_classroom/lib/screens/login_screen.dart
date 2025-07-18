import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children:[
            SizedBox(
              height: height * 0.08,
              width: width,
            ),
            Image.asset(
                'assets/LoginImage.png',
                fit: BoxFit.contain,
                width: width * 0.9,
                height: height * 0.4,
            ),
            SizedBox(
              width: width * 0.8,
              height: height * 0.1,
              child: Text("Students Login",
                style: GoogleFonts.amaranth(fontSize: width * 0.08, color: const Color(0xFF08AD8C)),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: width * 0.8,
              height: height * 0.1,
              child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF0F0F0),
                    labelText: 'Resistration Number',
                    labelStyle: GoogleFonts.amaranth(fontSize: width * 0.04, color: const Color.fromARGB(128, 0, 0, 0)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: width * 0.048, vertical: height * 0.021)
                ),
              ),
            ),
            SizedBox(
              width: width * 0.8,
              height: height * 0.1,
              child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF0F0F0),
                    labelText: 'Password',
                    labelStyle: GoogleFonts.amaranth(fontSize: width * 0.04, color: const Color.fromARGB(128, 0, 0, 0)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: width * 0.048, vertical: height * 0.021),
                  
                ),
              ),
            ),
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
                        backgroundColor: const Color(0xFF08AD8C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      child: Text("Login",
                        style: GoogleFonts.amaranth(fontSize: width*0.06, color: Colors.white),
                      ),
                    ),
                  )
                ]
              )
            ),
            SizedBox(
              height: height * 0.1,
              width: width * 0.8,
              child: Text("* Get Login From Your Institute !",
                style: GoogleFonts.balooBhai2(fontSize: width * 0.03, color: const Color.fromARGB(255, 0, 0, 0)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )
      ),
    );
  }
}
