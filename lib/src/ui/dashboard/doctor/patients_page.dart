import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/storage/db_helper.dart';
import '../../../routing/app_router.dart';
import 'add_patient_page.dart';
import 'patient_details_page.dart';


class PatientsPage extends StatefulWidget {
  final String doctorId;
  const PatientsPage({super.key, required this.doctorId});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  List<Map<String, dynamic>> _allPatients = [];
  List<Map<String, dynamic>> _filteredPatients = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPatients();

    _searchController.addListener(() {
      _filterPatients(_searchController.text.trim());
    });
  }

  Future<void> _loadPatients() async {
    final patients = await DatabaseHelper.getAllPatients(); // implement in db_helper.dart
    setState(() {
      _allPatients = patients;
      _filteredPatients = patients;
    });
  }

  void _filterPatients(String query) async {
    if (query.isEmpty) {
        final patients = await DatabaseHelper.getAllPatients();
        setState(() {
        _filteredPatients = patients;
        });
    } else {
        final patients = await DatabaseHelper.searchPatients(query);
        setState(() {
        _filteredPatients = patients;
        print(patients);
        });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Patients Icon
          CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFF26667f), // solid circle background
              child: ClipOval(
                  child: Image.asset(
                  "assets/patients_icon.jpeg", // <-- your own icon here
                  fit: BoxFit.contain,
                  height: 55,
                  width: 55,
                  color: Colors.white, // makes the image "invert-style" (white overlay)
                  colorBlendMode: BlendMode.srcIn,
                  ),
              ),
            ),
          const SizedBox(height: 20),

          // Search Bar
          TextField(
          controller: _searchController,
          style: const TextStyle( // this makes typed text black
              color: Colors.black,
              fontSize: 16,
          ),
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


          const SizedBox(height: 20),

          // Patients List
         Expanded(
         child: _filteredPatients.isEmpty
             ? const Center(
                 child: Text(
                     "No patients found",
                     style: TextStyle(
                     color: Colors.black, // text color black
                     fontSize: 16,
                     ),
                 ),
                 )
             : ListView.builder(
                 itemCount: _filteredPatients.length,
                 itemBuilder: (context, index) {
                     final patient = _filteredPatients[index];
                     return _patientCard(patient);
                },
            ),

          ),

          // Add Patient Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF077a7d),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddPatientPage(doctorId: widget.doctorId),
                  ),
                );
                // Refresh the patients list when returning
                _loadPatients();
              },
              child: const Text("Add Patient"),
            ),
          ),
        ],
      ),
    );
  }

  /// Patient Card UI
  Widget _patientCard(Map<String, dynamic> patient) {
    return Card(
      color: const Color(0xFFf6f2fa),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Color(0xFFe0e0e0)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PatientDetailsPage(
                doctorId: widget.doctorId,
                patientId: patient['national_id'],
              ),
            ),
          );
        },
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF26667f),
          radius: 25,
          child: Text(
            '${patient['first_name'][0]}${patient['last_name'][0]}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          "${patient['first_name']} ${patient['last_name']}",
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF1b1b20),
          ),
        ),
        subtitle: Text(
          "ID: ${patient['national_id']}",
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF26667f),
          size: 16,
        ),
      ),
    );
  }
}
