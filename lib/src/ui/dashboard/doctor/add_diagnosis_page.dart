import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/top_box.dart';
import '../../../services/storage/db_helper.dart';
import 'patient_details_page.dart';

class AddDiagnosisPage extends StatefulWidget {
  final String doctorId;
  final String patientId;
  
  const AddDiagnosisPage({
    super.key, 
    required this.doctorId, 
    required this.patientId,
  });

  @override
  State<AddDiagnosisPage> createState() => _AddDiagnosisPageState();
}

class _AddDiagnosisPageState extends State<AddDiagnosisPage> {
  final _formKey = GlobalKey<FormState>();
  final _symptomsController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _notesController = TextEditingController();
  final _diagnosticTypeController = TextEditingController();
  final _aiResultController = TextEditingController();
  final _doctorNotesController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _symptomsController.dispose();
    _diagnosisController.dispose();
    _treatmentController.dispose();
    _medicationsController.dispose();
    _notesController.dispose();
    _diagnosticTypeController.dispose();
    _aiResultController.dispose();
    _doctorNotesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showDiagnosticTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Diagnostic Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('CBC Analysis'),
                onTap: () {
                  setState(() {
                    _diagnosticTypeController.text = 'CBC Analysis';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Dental Image'),
                onTap: () {
                  setState(() {
                    _diagnosticTypeController.text = 'Dental Image';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Document Scan'),
                onTap: () {
                  setState(() {
                    _diagnosticTypeController.text = 'Document Scan';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('General Examination'),
                onTap: () {
                  setState(() {
                    _diagnosticTypeController.text = 'General Examination';
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveDiagnosis() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Add to patient history
      await DatabaseHelper.addPatientHistory(
        patientId: widget.patientId,
        doctorId: widget.doctorId,
        visitDate: _selectedDate,
        symptoms: _symptomsController.text.trim(),
        diagnosis: _diagnosisController.text.trim(),
        treatment: _treatmentController.text.trim(),
        medications: _medicationsController.text.trim(),
        notes: _notesController.text.trim(),
      );

      // Add to diagnostics if AI result is provided
      if (_aiResultController.text.trim().isNotEmpty) {
        await DatabaseHelper.addDiagnostic(
          patientId: widget.patientId,
          doctorId: widget.doctorId,
          aiResult: _aiResultController.text.trim(),
          doctorNotes: _doctorNotesController.text.trim(),
          diagnosticType: _diagnosticTypeController.text.trim(),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Diagnosis added successfully!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PatientDetailsPage(
            doctorId: widget.doctorId,
            patientId: widget.patientId,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFddf4e7),
      
      // Fixed TopBox
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: TopBox(),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF09090b)),
                  label: Text(
                    "Back",
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF09090b),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Center(
                child: Text(
                  'Add Diagnosis',
                  style: GoogleFonts.roboto(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF26667f),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Visit Date
              TextField(
                controller: TextEditingController(
                  text: "${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}",
                ),
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Visit Date',
                  labelStyle: const TextStyle(color: Colors.black87),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.grey),
                    onPressed: _selectDate,
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Symptoms
              TextFormField(
                controller: _symptomsController,
                style: const TextStyle(color: Colors.black),
                decoration: _inputDecoration('Symptoms *'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter symptoms';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Diagnosis
              TextFormField(
                controller: _diagnosisController,
                style: const TextStyle(color: Colors.black),
                decoration: _inputDecoration('Diagnosis *'),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter diagnosis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Treatment
              TextFormField(
                controller: _treatmentController,
                style: const TextStyle(color: Colors.black),
                decoration: _inputDecoration('Treatment *'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter treatment';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Medications
              TextFormField(
                controller: _medicationsController,
                style: const TextStyle(color: Colors.black),
                decoration: _inputDecoration('Medications'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                style: const TextStyle(color: Colors.black),
                decoration: _inputDecoration('Additional Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              // AI Diagnostic Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Diagnostic (Optional)',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF26667f),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Diagnostic Type
                    TextField(
                      controller: _diagnosticTypeController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Diagnostic Type',
                        labelStyle: const TextStyle(color: Colors.black87),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                          onPressed: _showDiagnosticTypeDialog,
                        ),
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),

                    // AI Result
                    TextFormField(
                      controller: _aiResultController,
                      style: const TextStyle(color: Colors.black),
                      decoration: _inputDecoration('AI Result'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Doctor Notes
                    TextFormField(
                      controller: _doctorNotesController,
                      style: const TextStyle(color: Colors.black),
                      decoration: _inputDecoration('Doctor Notes'),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF26667f),
                        side: const BorderSide(color: Color(0xFF26667f)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveDiagnosis,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4caf50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Save Diagnosis'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black87),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
