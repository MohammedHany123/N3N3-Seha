import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../doctor/dental_image_page.dart';
import '../doctor/cbc_analyzer_page.dart';
import '../doctor/doc_scan_page.dart';
import '../../../routing/app_router.dart';



class AiPage extends StatelessWidget {
  final String doctorId;

  AiPage({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            // AI Icon
          CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFF26667f), // solid circle background
              child: ClipOval(
                  child: Image.asset(
                  "assets/bot_icon.jpeg", // <-- your own AI icon here
                  fit: BoxFit.contain,
                  height: 55,
                  width: 55,
                  color: Colors.white, // makes the image "invert-style" (white overlay)
                  colorBlendMode: BlendMode.srcIn,
                  ),
              ),
            ),
          const SizedBox(height: 20),

          // Assistance message
          const Text(
            "How can AI help you today?",
            style: TextStyle(
              fontFamily: 'IBM Plex Sans',
              fontSize: 35,
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // Action Buttons
          _aiButton(context, "Dental Image", DentalImagePage(doctorId: doctorId)),
          const SizedBox(height: 20),
          _aiButton(context, "CBC Analyzer", CbcAnalyzerPage(doctorId: doctorId)),
          const SizedBox(height: 20),
          _aiButton(context, "Document Scanning", DocScanPage(doctorId: doctorId)),
        ],
      ),
    );
  }

    Widget _aiButton(BuildContext context, String text, Widget targetPage) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF077a7d),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => targetPage),
          );
        },
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}