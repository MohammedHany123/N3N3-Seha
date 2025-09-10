import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/top_box.dart';
import 'doctor_dashboard_page.dart';

class CbcAnalyzerPage extends StatefulWidget {
  final String doctorId;   // receive doctorId

  const CbcAnalyzerPage({super.key, required this.doctorId});

  @override
  State<CbcAnalyzerPage> createState() => _CbcAnalyzerPageState();
}

class _CbcAnalyzerPageState extends State<CbcAnalyzerPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Example CBC fields
  final Map<String, TextEditingController> _controllers = {
    "WBC": TextEditingController(),
    "RBC": TextEditingController(),
    "HGB": TextEditingController(),
    "PLT": TextEditingController(),
    "HCT": TextEditingController(),
    "MCV": TextEditingController(),
    "MCH": TextEditingController(),
    "MCHC": TextEditingController(),
    "RDW": TextEditingController(),
    "MPV": TextEditingController(),
  };

  bool _resultsVisible = false;
  XFile? _selectedImage;
  bool _isProcessingImage = false;

  // Normal ranges for adult references (generic; adjust to lab standards)
  final Map<String, Map<String, double>> _normalRanges = const {
    "WBC": {"min": 4.0, "max": 11.0}, // x10^9/L
    "RBC": {"min": 4.0, "max": 5.5}, // x10^12/L
    "HGB": {"min": 12.0, "max": 16.0}, // g/dL
    "PLT": {"min": 150.0, "max": 450.0}, // x10^9/L
    "HCT": {"min": 36.0, "max": 46.0}, // %
    "MCV": {"min": 80.0, "max": 100.0}, // fL
    "MCH": {"min": 27.0, "max": 33.0}, // pg
    "MCHC": {"min": 32.0, "max": 36.0}, // g/dL
    "RDW": {"min": 11.5, "max": 14.5}, // %
    "MPV": {"min": 7.5, "max": 12.5}, // fL
  };

  final Map<String, String> _lowInterpretations = const {
    "WBC": "Low WBC may suggest leukopenia; consider viral infections or marrow suppression.",
    "RBC": "Low RBC may suggest anemia; evaluate HGB/HCT and iron studies.",
    "HGB": "Low HGB suggests anemia; assess iron/B12/folate and bleeding.",
    "PLT": "Low platelets may indicate thrombocytopenia; assess bleeding risk.",
    "HCT": "Low HCT aligns with anemia; correlate with HGB/RBC.",
    "MCV": "Low MCV suggests microcytosis; consider iron deficiency or thalassemia.",
    "MCH": "Low MCH suggests hypochromia; consider iron deficiency.",
    "MCHC": "Low MCHC suggests hypochromia; correlate with iron studies.",
    "RDW": "Low RDW is usually not clinically significant.",
    "MPV": "Low MPV may indicate smaller platelets; correlate clinically.",
  };

  final Map<String, String> _highInterpretations = const {
    "WBC": "High WBC may suggest infection, inflammation, or stress leukocytosis.",
    "RBC": "High RBC may suggest polycythemia; consider dehydration or hypoxia.",
    "HGB": "High HGB may suggest polycythemia; evaluate oxygenation and EPO.",
    "PLT": "High platelets may suggest thrombocytosis; consider reactive causes.",
    "HCT": "High HCT may indicate hemoconcentration or polycythemia.",
    "MCV": "High MCV suggests macrocytosis; consider B12/folate deficiency or alcohol use.",
    "MCH": "High MCH with high MCV suggests macrocytosis.",
    "MCHC": "High MCHC can be seen in spherocytosis or lab artifact.",
    "RDW": "High RDW suggests anisocytosis; mixed deficiencies or recent transfusion.",
    "MPV": "High MPV may indicate larger platelets; increased turnover.",
  };

  double? _parseValue(String? text) {
    if (text == null) return null;
    final cleaned = text.trim().replaceAll(',', '.');
    return double.tryParse(cleaned);
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _selectedImage = picked;
        _resultsVisible = false;
      });
    }
  }

  Future<void> _processImage() async {
    if (_selectedImage == null) return;
    
    setState(() {
      _isProcessingImage = true;
    });

    // Simulate text extraction from image
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock extracted values - in real app, use OCR library like google_mlkit_text_recognition
    final mockExtractedValues = {
      "WBC": "7.2",
      "RBC": "4.5",
      "HGB": "14.2",
      "PLT": "250",
      "HCT": "42.1",
      "MCV": "88.5",
      "MCH": "28.3",
      "MCHC": "32.1",
      "RDW": "12.8",
      "MPV": "9.2",
    };

    // Auto-fill the form with extracted values
    for (var entry in mockExtractedValues.entries) {
      if (_controllers.containsKey(entry.key)) {
        _controllers[entry.key]!.text = entry.value;
      }
    }

    setState(() {
      _isProcessingImage = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document processed successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Same TopBox with Dashboard button
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: TopBox(),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dashboard button (same as Dental Image)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DoctorDashboardPage(
                        doctorId: widget.doctorId, // replace with actual doctorId
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

            const SizedBox(height: 20),

            // Image preview
            if (_selectedImage != null) ...[
              Container(
                height: 200,
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isProcessingImage ? null : _processImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF26667f),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: _isProcessingImage
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4caf50)),
                              ),
                            )
                          : const Text('Extract Text'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF26667f),
                        side: const BorderSide(color: Color(0xFF26667f)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Remove'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ..._controllers.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TextFormField(
                            controller: entry.value,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: entry.key,
                              labelStyle: const TextStyle(color: Colors.black87),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 20),

                      if (!_resultsVisible)
                        _actionButton("Analyze Results", () {
                          setState(() {
                            _resultsVisible = true;
                          });
                        }),

                      if (_resultsVisible) ...[
                        _resultsTable(),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _actionButton("Discard", () {
                                setState(() {
                                  for (var c in _controllers.values) {
                                    c.clear();
                                  }
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
                      ]
                    ],
                  ),
                ),
              ),
            ),
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

  /// Results Table
  Widget _resultsTable() {
    // Build analysis from form values and defined ranges
    final params = ["WBC","RBC","HGB","PLT","HCT","MCV","MCH","MCHC","RDW","MPV"];
    final analysisResults = <Map<String, String>>[];

    for (final p in params) {
      final value = _parseValue(_controllers[p]?.text);
      final range = _normalRanges[p]!;
      final min = range['min']!;
      final max = range['max']!;
      String status = 'Normal';
      String interp = 'Within normal limits';

      if (value == null) {
        status = 'N/A';
        interp = 'No value entered';
      } else if (value < min) {
        status = 'Low';
        interp = _lowInterpretations[p] ?? 'Below normal range; correlate clinically.';
      } else if (value > max) {
        status = 'High';
        interp = _highInterpretations[p] ?? 'Above normal range; correlate clinically.';
      }

      analysisResults.add({
        'parameter': p,
        'value': value?.toStringAsFixed(2) ?? '',
        'normalRange': '${min.toStringAsFixed(1)}-${max.toStringAsFixed(1)}',
        'status': status,
        'interpretation': interp,
      });
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF26667f),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.analytics, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  "CBC Analysis Results",
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
              columns: const [
                DataColumn(label: Text('Parameter', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                DataColumn(label: Text('Value', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                DataColumn(label: Text('Normal Range', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                DataColumn(label: Text('Interpretation', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
              ],
              rows: analysisResults.map((result) {
                Color statusColor = Colors.green;
                if (result['status'] == 'High') statusColor = Colors.red;
                if (result['status'] == 'Low') statusColor = Colors.orange;
                if (result['status'] == 'N/A') statusColor = Colors.grey;
                
                return DataRow(
                  cells: [
                    DataCell(Text(result['parameter']!, style: const TextStyle(color: Colors.black))),
                    DataCell(Text(result['value']!.isEmpty ? 'N/A' : result['value']!, style: const TextStyle(color: Colors.black))),
                    DataCell(Text(result['normalRange']!, style: const TextStyle(color: Colors.black))),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          result['status']!,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(result['interpretation']!, style: const TextStyle(color: Colors.black))),
                  ],
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
