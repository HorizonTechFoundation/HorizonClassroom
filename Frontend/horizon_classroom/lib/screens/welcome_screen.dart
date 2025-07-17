import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    

    return Scaffold(
      body: Center(
        child: Column(
          children:[
            SizedBox(
              height: height * 0.155,
              width: width,
            ),
            SizedBox(
              height: height * 0.13,
              width: width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome to",
                    style: GoogleFonts.amaranth(fontSize: width*0.074, color: Colors.black),
                  ),
                  Text(
                    "Horizon Classroom !",
                    style: GoogleFonts.amaranth(fontSize: width*0.084, color: const Color(0xFF08AD8C)),
                  ),
                ],
              )
            ),
            Image.asset(
                'assets/welcomeImage.png',
                fit: BoxFit.contain,
                width: width,
                height: height * 0.3,
            ),
            SizedBox(
              height: height * 0.15,
              width: width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text(
                    "    Technology improves life through innovation, communication, and efficiency. However, it also brings challenges like privacy concerns and job loss, requiring responsible and balanced use.",
                    style: GoogleFonts.average(fontSize: width * 0.043, color: Colors.black),
                  )
                ]
              ),
            ),
            SizedBox(
              height: height * 0.15,
              width: width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * 0.56,
                    height: height * 0.065,
                    child:ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF08AD8C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text("Get Started",
                        style: GoogleFonts.amaranth(fontSize: width*0.053, color: Colors.white),
                      ),
                    )
                  )
                ],
              )
            ),
          ],
        )
      ),
    );
  }
}
