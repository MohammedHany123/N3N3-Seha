// ...existing imports...
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/storage/db_helper.dart';

class SelectPatientDialog extends StatefulWidget {
  final String doctorId;
  final String aiResult;
  final String diagnosticType;
  final void Function(Map<String, dynamic> patient) onPatientSelected;

  const SelectPatientDialog({
    super.key,
    required this.doctorId,
    required this.aiResult,
    required this.diagnosticType,
    required this.onPatientSelected,
  });

  @override
  State<SelectPatientDialog> createState() => _SelectPatientDialogState();
}

class _SelectPatientDialogState extends State<SelectPatientDialog> {
  List<Map<String, dynamic>> _allPatients = [];
  List<Map<String, dynamic>> _filteredPatients = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPatients();
    _searchController.addListener(() {
      _filterPatients(_searchController.text.trim());
    });
  }

  Future<void> _loadPatients() async {
    final patients = await DatabaseHelper.getAllPatients();
    setState(() {
      _allPatients = patients;
      _filteredPatients = patients;
    });
  }

  void _filterPatients(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredPatients = _allPatients;
      });
    } else {
      final patients = await DatabaseHelper.searchPatients(query);
      setState(() {
        _filteredPatients = patients;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        width: 400,
        height: 580,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "Select Patient",
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFFE8DB),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                style: const TextStyle( // this makes typed text black
                    color: Colors.black,
                    fontSize: 16,
                ),
                controller: _searchController,
                decoration: InputDecoration(
                hintText: "Search by name/NID",
                hintStyle: GoogleFonts.roboto(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: const Color(0xFFb3b3c3),
                ),
                filled: true,
                fillColor: const Color(0xFFf6f2fa),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFb3b3c3)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                maxLines: 2,
                style: const TextStyle( // this makes typed text black
                    color: Colors.black,
                    fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: "Doctor notes (optional)",
                  prefixIcon: const Icon(Icons.note_alt_outlined),
                  filled: true,
                  fillColor: const Color(0xFFf6f2fa),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _filteredPatients.isEmpty
                    ? const Center(child: Text("No patients found"))
                    : ListView.builder(
                        itemCount: _filteredPatients.length,
                        itemBuilder: (context, index) {
                          final patient = _filteredPatients[index];
                          return Card(
                            color: const Color(0xFFf6f2fa),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(color: Color(0xFFe0e0e0)),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              onTap: () async {
                                await DatabaseHelper.addDiagnostic(
                                  patientId: patient['national_id'],
                                  doctorId: widget.doctorId,
                                  aiResult: widget.aiResult,
                                  doctorNotes: _notesController.text,
                                  diagnosticType: widget.diagnosticType,
                                );
                                widget.onPatientSelected(patient);
                                Navigator.of(context).pop();
                              },
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF26667f),
                                child: Text(
                                  '${patient['first_name'][0]}${patient['last_name'][0]}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                "${patient['first_name']} ${patient['last_name']}",
                                style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF1b1b20)),
                              ),
                              subtitle: Text(
                                "ID: ${patient['national_id']}",
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: Colors.black54,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}