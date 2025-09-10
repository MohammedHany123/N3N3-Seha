import 'package:flutter/material.dart';
import '../../routing/app_router.dart';
import '../common/top_box.dart';
import '../../services/storage/db_helper.dart';
import '../dashboard/doctor/doctor_dashboard_page.dart';

enum Role { doctor, patient, admin }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Role _selectedRole = Role.doctor; // default selected
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFddf4e7),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100), // fixed height
        child: TopBox(), // stays pinned at the top
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Log In',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans',
                fontSize: 40,
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Role-specific icon
            SizedBox(
              height: 80,
              child: Image.asset(
                _selectedRole == Role.doctor
                    ? 'assets/doctor_icon.jpeg'
                    : _selectedRole == Role.patient
                        ? 'assets/patient_icon.jpeg'
                        : 'assets/admin_icon.jpeg',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),

            // Role toggle buttons
            Row(
              children: [
                _roleButton(Role.doctor, "Doctor"),
                const SizedBox(width: 8),
                _roleButton(Role.patient, "Patient"),
                const SizedBox(width: 8),
                _roleButton(Role.admin, "Admin"),
              ],
            ),

            const SizedBox(height: 40),

            // Form fields
            _buildForm(),

            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: forgot password action
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Color(0xFF26667f)),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Login & Cancel buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF26667f),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      String idOrEmail = _idController.text.trim();
                      String password = _passwordController.text.trim();
                      bool isValid = false;

                      if (_selectedRole == Role.doctor) {
                        isValid = await DatabaseHelper.loginDoctor(idOrEmail, password);
                        if (isValid) {
                          _navigateToDashboard(context);
                        }
                      } else if (_selectedRole == Role.patient) {
                        isValid = await DatabaseHelper.loginPatient(idOrEmail, password);
                        if (isValid) {
                          _navigateToDashboard(context);
                        }
                      } else if (_selectedRole == Role.admin) {
                        isValid = await DatabaseHelper.loginAdmin(idOrEmail, password);
                        if (isValid) {
                          _navigateToDashboard(context);
                        }
                      }

                      if (!isValid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Invalid credentials. Please try again.")),
                        );
                      }
                    },
                    child: const Text("Log In"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF26667f),
                      side: const BorderSide(color: Color(0xFF26667f)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/welcome');
                    },
                    child: const Text("Cancel"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget for animated role button
  Widget _roleButton(Role role, String text) {
    bool isSelected = _selectedRole == role;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF26667f) : const Color(0xFF56dfcf),
          borderRadius: BorderRadius.circular(isSelected ? 10 : 50),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(isSelected ? 10 : 50),
          onTap: () {
            setState(() {
              _selectedRole = role;
            });
          },
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF444559),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build dynamic form based on selected role
  Widget _buildForm() {
    String label1;
    switch (_selectedRole) {
      case Role.doctor:
        label1 = 'Syndicate ID';
        break;
      case Role.patient:
        label1 = 'National ID';
        break;
      case Role.admin:
        label1 = 'Email';
        break;
    }

    return Column(
      children: [
        TextField(
          controller: _idController,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: label1,
            labelStyle: const TextStyle(color: Colors.black54),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          style: const TextStyle(color: Colors.black),
          obscureText: !_isLoginPasswordVisible,
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
                _isLoginPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isLoginPasswordVisible = !_isLoginPasswordVisible;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToDashboard(BuildContext context) {
    switch (_selectedRole) {
      case Role.doctor:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorDashboardPage(doctorId: _idController.text.trim()),
          ),
        );
        break;
      case Role.patient:
        Navigator.pushReplacementNamed(context, AppRoutes.patientDashboard);
        break;
      case Role.admin:
        Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
        break;
    }
  }
}
