import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/top_box.dart';
import '../../../services/storage/db_helper.dart';
import 'doctor_dashboard_page.dart';
import 'add_diagnosis_page.dart';

class PatientDetailsPage extends StatefulWidget {
  final String doctorId;
  final String patientId;
  
  const PatientDetailsPage({
    super.key, 
    required this.doctorId, 
    required this.patientId,
  });

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  Map<String, dynamic>? _patient;
  List<Map<String, dynamic>> _patientHistory = [];
  List<Map<String, dynamic>> _diagnostics = [];
  List<Map<String, dynamic>> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    try {
      final patient = await DatabaseHelper.getPatientById(widget.patientId);
      final history = await DatabaseHelper.getPatientHistory(widget.patientId);
      final diagnostics = await DatabaseHelper.getPatientDiagnostics(widget.patientId);
      final appointments = await DatabaseHelper.getPatientAppointments(widget.patientId);
      
      setState(() {
        _patient = patient;
        _patientHistory = history;
        _diagnostics = diagnostics;
        _appointments = appointments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading patient data: $e')),
      );
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  int _calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null) return 0;
    try {
      final birthDate = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
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

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _patient == null
              ? const Center(child: Text('Patient not found'))
              : SingleChildScrollView(
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
                                builder: (_) => DoctorDashboardPage(doctorId: widget.doctorId),
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

                      // Patient Header
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: const Color(0xFF26667f),
                              child: Text(
                                '${_patient!['first_name'][0]}${_patient!['last_name'][0]}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_patient!['first_name']} ${_patient!['last_name']}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF26667f),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'ID: ${_patient!['national_id']}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    'Age: ${_calculateAge(_patient!['date_of_birth'])} years',
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    'Gender: ${_patient!['gender'] ?? 'N/A'}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Patient Information
                      _buildInfoSection('Patient Information', [
                        {'label': 'Phone', 'value': _patient!['phone'] ?? 'N/A'},
                        {'label': 'Email', 'value': _patient!['email'] ?? 'N/A'},
                        {'label': 'Date of Birth', 'value': _formatDate(_patient!['date_of_birth'])},
                        {'label': 'Gender', 'value': _patient!['gender'] ?? 'N/A'},
                      ]),

                      const SizedBox(height: 20),

                      // Medical History Table
                      _buildHistoryTable(),

                      const SizedBox(height: 20),

                      // Diagnostics Table
                      _buildDiagnosticsTable(),

                      const SizedBox(height: 20),

                      // Appointments Table
                      _buildAppointmentsTable(),

                      const SizedBox(height: 30),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Implement PDF generation and sharing
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('PDF generation feature coming soon!')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF26667f),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              icon: const Icon(Icons.share),
                              label: const Text('Share as PDF'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddDiagnosisPage(
                                      doctorId: widget.doctorId,
                                      patientId: widget.patientId,
                                    ),
                                  ),
                                ).then((_) {
                                  // Refresh data when returning
                                  _loadPatientData();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4caf50),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Diagnosis'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoSection(String title, List<Map<String, String>> info) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF26667f),
            ),
          ),
          const SizedBox(height: 12),
          ...info.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    '${item['label']}:',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    item['value']!,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildHistoryTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF26667f),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.history, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Medical History',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (_patientHistory.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'No medical history recorded',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
                columns: const [
                  DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                  DataColumn(label: Text('Symptoms', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                  DataColumn(label: Text('Diagnosis', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                  DataColumn(label: Text('Treatment', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                  DataColumn(label: Text('Medications', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                ],
                rows: _patientHistory.map((history) {
                  return DataRow(
                    cells: [
                      DataCell(Text(_formatDate(history['visit_date']), style: const TextStyle(color: Colors.black))),
                      DataCell(Text(history['symptoms'] ?? 'N/A', style: const TextStyle(color: Colors.black))),
                      DataCell(Text(history['diagnosis'] ?? 'N/A', style: const TextStyle(color: Colors.black))),
                      DataCell(Text(history['treatment'] ?? 'N/A', style: const TextStyle(color: Colors.black))),
                      DataCell(Text(history['medications'] ?? 'N/A', style: const TextStyle(color: Colors.black))),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF4caf50),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.analytics, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'AI Diagnostics',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (_diagnostics.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'No diagnostics recorded',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
                columns: const [
                  DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                  DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                  DataColumn(label: Text('AI Result', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                  DataColumn(label: Text('Doctor Notes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                ],
                rows: _diagnostics.map((diagnostic) {
                  return DataRow(
                    cells: [
                      DataCell(Text(_formatDate(diagnostic['created_at']), style: const TextStyle(color: Colors.black))),
                      DataCell(Text(diagnostic['diagnostic_type'] ?? 'N/A', style: const TextStyle(color: Colors.black))),
                      DataCell(Text(diagnostic['ai_result'] ?? 'N/A', style: const TextStyle(color: Colors.black))),
                      DataCell(Text(diagnostic['doctor_notes'] ?? 'N/A', style: const TextStyle(color: Colors.black))),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFff9800),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Appointments',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (_appointments.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'No appointments scheduled',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
                columns: const [
                  DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                  DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                  DataColumn(label: Text('Notes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                ],
                rows: _appointments.map((appointment) {
                  return DataRow(
                    cells: [
                      DataCell(Text(_formatDate(appointment['scheduled_at']), style: const TextStyle(color: Colors.black))),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(appointment['status']).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            appointment['status'] ?? 'N/A',
                            style: TextStyle(
                              color: _getStatusColor(appointment['status']),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text(appointment['notes'] ?? 'N/A', style: const TextStyle(color: Colors.black))),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'scheduled':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
