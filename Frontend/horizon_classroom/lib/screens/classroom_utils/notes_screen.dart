import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';


class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {

  String className = "Data Structures and Algorithms";

  String notesText = "";
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());


  // ================ SAVE AS PDF ================

  Future<Uint8List> generatePdf(String notes, String className) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) =>[
          pw.Text("Horizon Tech Foundation - Horizon Classroom" ,style: pw.TextStyle(fontSize: 12, color: PdfColors.black)),
          pw.SizedBox(height: 10),
          pw.Text(className ,style: pw.TextStyle(fontSize: 20, color: PdfColors.greenAccent700), textAlign: pw.TextAlign.center),
          pw.SizedBox(height: 10),
          pw.Text("Date : $formattedDate", style: pw.TextStyle(fontSize: 15)),
          pw.SizedBox(height: 30),
          pw.Paragraph(text:notes, style: pw.TextStyle(fontSize: 14)),
        ],
      ),
  );

  return pdf.save();
}

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
      appBar: AppBar(title: const Text("Take Notes")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // ================ CLASS INFO ================
              SizedBox(
                height: height * 0.1,
                width: width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Text(
                        className,
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
                  child: SizedBox(
                    width: width * 0.8,
                    height: (width * 0.8) * 0.5625, // 16:9 aspect ratio
                    child: ColoredBox(color: Colors.cyan),
                  ),
                ),
              ),

              // =============== NOTE TAKING SPACE ================

              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                child: SizedBox(
                  height: height * 0.3,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        notesText = value;
                      });
                    },
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: 'Write your notes here...',
                      filled: true,
                      fillColor: const Color(0xFFE2E2E2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.all(width * 0.04),
                      hintStyle: GoogleFonts.amaranth(
                        fontSize: width * 0.04,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    style: GoogleFonts.amaranth(
                      fontSize: width * 0.045,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              // ================ SAVE AS PDF BUTTON ================

              SizedBox(height: height*0.05),
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
                  onPressed: () async {
                    final pdfBytes = await generatePdf(notesText, className);
                    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfBytes);
                  },
                  child: Text("Save as PDF", 
                    style: GoogleFonts.amaranth(fontSize: width * 0.05, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
