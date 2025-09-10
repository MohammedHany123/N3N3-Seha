import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/top_box.dart';
import 'doctor_dashboard_page.dart';

class DocScanPage extends StatefulWidget {
  final String doctorId;

  const DocScanPage({super.key, required this.doctorId});

  @override
  State<DocScanPage> createState() => _DocScanPageState();
}

class _DocScanPageState extends State<DocScanPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isProcessingImage = false;
  String _extractedText = '';
  bool _textExtracted = false;

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _selectedImage = picked;
        _textExtracted = false;
        _extractedText = '';
      });
    }
  }

  Future<void> _extractText() async {
    if (_selectedImage == null) return;
    
    setState(() {
      _isProcessingImage = true;
    });

    // Simulate text extraction from image
    await Future.delayed(const Duration(seconds: 3));
    
    // Mock extracted text - in real app, use OCR library like google_mlkit_text_recognition
    final mockExtractedText = """
PATIENT INFORMATION
Name: John Doe
Date of Birth: 15/03/1985
Patient ID: P123456
Date: 15/12/2024

MEDICAL REPORT
Chief Complaint: Chest pain and shortness of breath
History: Patient presents with acute onset chest pain radiating to left arm, associated with nausea and diaphoresis.

PHYSICAL EXAMINATION
Vital Signs:
- Blood Pressure: 140/90 mmHg
- Heart Rate: 95 bpm
- Temperature: 98.6°F
- Respiratory Rate: 22/min

Cardiovascular: Regular rate and rhythm, no murmurs
Respiratory: Clear to auscultation bilaterally
Abdomen: Soft, non-tender, no organomegaly

ASSESSMENT AND PLAN
1. Chest pain - rule out acute coronary syndrome
   - Order EKG, cardiac enzymes
   - Consider stress test if stable
   
2. Hypertension
   - Continue current antihypertensive
   - Monitor blood pressure closely
   
3. Follow-up in 1 week

Dr. Smith
Cardiologist
License: MD12345
""";

    setState(() {
      _extractedText = mockExtractedText;
      _textExtracted = true;
      _isProcessingImage = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text extracted successfully!')),
    );
  }

  void _discardDocument() {
    setState(() {
      _selectedImage = null;
      _extractedText = '';
      _textExtracted = false;
    });
  }

  void _saveDocument() {
    // TODO: Implement save logic to database
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document saved successfully!')),
    );
    
    // Navigate back to dashboard after saving
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorDashboardPage(doctorId: widget.doctorId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fixed TopBox
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: TopBox(),
      ),

      body: SingleChildScrollView(
        child: Padding(
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
                      builder: (_) => DoctorDashboardPage(
                        doctorId: widget.doctorId,
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

            // Page title
            Center(
              child: Text(
                "Document Scanner",
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF26667f),
                ),
              ),
            ),

            // Camera and Gallery buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _circleIconButton(
                  iconPath: "assets/camera_icon.png",
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                const SizedBox(width: 40),
                _circleIconButton(
                  iconPath: "assets/folder_icon.png",
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Image preview
            if (_selectedImage != null) ...[
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_selectedImage!.path),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Extract text button
              if (!_textExtracted)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isProcessingImage ? null : _extractText,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF26667f),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: _isProcessingImage
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4caf50)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Extracting Text...',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Extract Text',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
            ],

            const SizedBox(height: 20),

            // Extracted text preview
            if (_textExtracted) ...[
              Container(
                height: 300, // Fixed height instead of Expanded
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.text_fields, color: Color(0xFF26667f)),
                        const SizedBox(width: 8),
                        Text(
                          "Extracted Text",
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF26667f),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            _extractedText,
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.black,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: _actionButton("Discard", _discardDocument, outlined: true),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionButton("Save to Patient", _saveDocument),
                  ),
                ],
              ),
            ],

            // Instructions when no image is selected
            if (_selectedImage == null) ...[
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.document_scanner,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Scan a document to extract text",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Use camera or select from gallery",
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            ],
          ),
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
}
