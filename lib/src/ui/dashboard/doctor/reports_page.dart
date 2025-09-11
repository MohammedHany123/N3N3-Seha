import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../services/storage/db_helper.dart';

class ReportsPage extends StatefulWidget {
  final String doctorId;
  const ReportsPage({super.key, required this.doctorId});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<Map<String, dynamic>> _reports = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    final reports = await DatabaseHelper.getDoctorReports(widget.doctorId);
    setState(() {
      _reports = reports;
      _loading = false;
    });
  }

  Future<void> _deleteReport(int diagnosticId) async {
    final db = await DatabaseHelper.database;
    await db.delete(
      'Diagnostics',
      where: 'diagnostic_id = ?',
      whereArgs: [diagnosticId],
    );
    await _fetchReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top Circle Icon (instead of plain text AppBar)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFF26667f),
              child: ClipOval(
                child: Image.asset(
                  "assets/reports_icon.jpeg", // <-- your reports icon here
                  fit: BoxFit.contain,
                  height: 55,
                  width: 55,
                  color: Colors.white,
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _reports.isEmpty
              ? Center(
                  child: Text(
                    "No reports found",
                    style: GoogleFonts.roboto(fontSize: 18, color: Colors.black),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _reports.length,
                  itemBuilder: (context, index) {
                    final report = _reports[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 4,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Text(
                          "${report['first_name']} ${report['last_name']} (${report['national_id']})",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report['diagnostic_type'] ?? '',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.blueGrey,
                              ),
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd – HH:mm')
                                  .format(DateTime.parse(report['created_at'])),
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              (report['ai_result'] as String).split('\n').first,
                              style: GoogleFonts.roboto(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("AI Result:",
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold, color: Colors.black)),
                                Text(report['ai_result'] ?? '',
                                    style: GoogleFonts.roboto(color: Colors.black)),
                                const SizedBox(height: 8),
                                if (report['doctor_notes'] != null &&
                                    report['doctor_notes'].toString().isNotEmpty)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Doctor Notes:",
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.bold, color: Colors.black)),
                                      Text(report['doctor_notes'],
                                          style: GoogleFonts.roboto(color: Colors.black)),
                                    ],
                                  ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                                      onPressed: () {
                                        // TODO: Export as PDF
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.table_chart, color: Colors.blue),
                                      onPressed: () {
                                        // TODO: Export as CSV
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteReport(report['diagnostic_id']),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
