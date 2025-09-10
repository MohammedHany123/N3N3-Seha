import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/top_box.dart';
import 'doctor_dashboard_page.dart';

class DentalImagePage extends StatefulWidget {
  const DentalImagePage({super.key});

  @override
  State<DentalImagePage> createState() => _DentalImagePageState();
}

class _DentalImagePageState extends State<DentalImagePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _resultsVisible = false; // track if results are shown

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _selectedImage = picked;
        _resultsVisible = false; // reset results when new image is picked
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fixed TopBox
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: TopBox(),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dashboard button
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DoctorDashboardPage(
                        doctorId: "DUMMY_ID", // replace with actual doctor ID
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.dashboard, color: Color(0xFF09090b)),
                label: Text(
                  "Dashboard",
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF09090b),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Circular buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _circleIconButton(
                  iconPath: "assets/camera_icon.png", // replace with your asset
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                const SizedBox(width: 40),
                _circleIconButton(
                  iconPath: "assets/folder_icon.png", // replace with your asset
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Image preview
            Expanded(
              child: Center(
                child: _selectedImage != null
                    ? Image.file(File(_selectedImage!.path), height: 250)
                    : const Text("No image selected"),
              ),
            ),

            const SizedBox(height: 20),

            // Conditional buttons
            if (_selectedImage != null && !_resultsVisible)
              _actionButton("Results", () {
                // Placeholder: call AI model here
                setState(() {
                  _resultsVisible = true;
                });
              }),

            if (_resultsVisible) ...[
              _resultsWindow(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _actionButton("Discard", () {
                      setState(() {
                        _selectedImage = null;
                        _resultsVisible = false;
                      });
                    }, outlined: true),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _actionButton("Save to Patient", () {
                      // TODO: save logic
                    }),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Circular Icon Button
  Widget _circleIconButton({required String iconPath, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: CircleAvatar(
        radius: 40,
        backgroundColor: const Color(0xFF26667f),
        child: Image.asset(
          iconPath,
          height: 40,
          width: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Styled Action Button
  Widget _actionButton(String text, VoidCallback onPressed, {bool outlined = false}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: outlined ? Colors.transparent : const Color(0xFF26667f),
        foregroundColor: outlined ? const Color(0xFF26667f) : Colors.white,
        side: outlined ? const BorderSide(color: Color(0xFF26667f)) : null,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        textStyle: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: onPressed,
      child: Text(text, textAlign: TextAlign.center),
    );
  }

  /// Placeholder for AI Results
  Widget _resultsWindow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: const Text(
        "AI Results Placeholder:\n- No tooth detected → please retry\n- Or show detected conditions with confidence + heatmap",
        style: TextStyle(
            fontSize: 14,
            color: Color(0xFF077a7d),
        ), 
      ),
    );
  }
}