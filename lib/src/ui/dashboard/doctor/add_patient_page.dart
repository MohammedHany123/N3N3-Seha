import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/top_box.dart';
import '../../../services/storage/db_helper.dart';
import 'doctor_dashboard_page.dart';

class AddPatientPage extends StatefulWidget {
  final String doctorId;
  const AddPatientPage({super.key, required this.doctorId});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  // Controllers
  final _nationalIdController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _genderController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nationalIdController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateOfBirthController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  bool isPasswordStrong(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final hasMinLength = password.length >= 8;

    return hasUppercase && hasLowercase && hasDigit && hasSpecial && hasMinLength;
  }

  bool isValidNationalId(String nationalId) {
    // Check if it's exactly 14 digits
    return RegExp(r'^\d{14}$').hasMatch(nationalId);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)), // Default to 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  void _showGenderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Gender'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Male'),
                onTap: () {
                  setState(() {
                    _genderController.text = 'Male';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Female'),
                onTap: () {
                  setState(() {
                    _genderController.text = 'Female';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFddf4e7),

      // Fixed top bar
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: TopBox(),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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

            // Title
            Text(
              'Add Patient',
              style: GoogleFonts.roboto(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF26667f),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // Form fields
            TextField(
              controller: _nationalIdController,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration('National ID (14 digits)'),
              keyboardType: TextInputType.number,
              maxLength: 14,
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _firstNameController,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration('First Name'),
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _lastNameController,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration('Last Name'),
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _phoneController,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration('Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration('Email (Optional)'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),

            // Date of Birth field
            TextField(
              controller: _dateOfBirthController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Date of Birth',
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
            const SizedBox(height: 12),

            // Gender field
            TextField(
              controller: _genderController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Gender',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  onPressed: _showGenderDialog,
                ),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _passwordController,
              style: const TextStyle(color: Colors.black),
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _confirmPasswordController,
              style: const TextStyle(color: Colors.black),
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Buttons side by side
            Row(
              children: [
                // Add Patient Button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF26667f),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      final nationalId = _nationalIdController.text.trim();
                      final password = _passwordController.text.trim();
                      final confirmPassword = _confirmPasswordController.text.trim();

                      // Validation
                      if (nationalId.isEmpty || _firstNameController.text.trim().isEmpty || 
                          _lastNameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please fill in all required fields")),
                        );
                        return;
                      }

                      if (!isValidNationalId(nationalId)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("National ID must be exactly 14 digits")),
                        );
                        return;
                      }

                      if (password != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Passwords do not match")),
                        );
                        return;
                      }

                      if (!isPasswordStrong(password)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Password must be at least 8 characters, include upper, lower, number, and special char"),
                          ),
                        );
                        return;
                      }

                      if (_selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please select date of birth")),
                        );
                        return;
                      }

                      if (_genderController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please select gender")),
                        );
                        return;
                      }

                      try {
                        await DatabaseHelper.addPatient(
                          nationalId: nationalId,
                          firstName: _firstNameController.text.trim(),
                          lastName: _lastNameController.text.trim(),
                          password: password,
                          phone: _phoneController.text.trim(),
                          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
                          dateOfBirth: _selectedDate!,
                          gender: _genderController.text,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Patient added successfully")),
                        );

                        // Navigate back to patients page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DoctorDashboardPage(doctorId: widget.doctorId),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                    child: const Text("Add Patient"),
                  ),
                ),

                const SizedBox(width: 16),

                // Cancel Button
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF26667f),
                      side: const BorderSide(color: Color(0xFF26667f)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DoctorDashboardPage(doctorId: widget.doctorId),
                        ),
                      );
                    },
                    child: const Text("Cancel"),
                  ),
                ),
              ],
            ),
          ],
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
