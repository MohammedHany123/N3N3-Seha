import 'package:flutter/material.dart';

import '../../routing/app_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String role = 'Doctor';
  final TextEditingController _idCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('N3N3 Seha - Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: role,
              items: const [
                DropdownMenuItem(value: 'Doctor', child: Text('Doctor')),
                DropdownMenuItem(value: 'Patient', child: Text('Patient')),
                DropdownMenuItem(value: 'Admin', child: Text('Admin')),
              ],
              onChanged: (v) => setState(() => role = v ?? 'Doctor'),
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _idCtrl,
              decoration: InputDecoration(
                labelText: role == 'Doctor'
                    ? 'Syndicate ID'
                    : role == 'Patient'
                        ? 'National ID'
                        : 'Email/Username',
              ),
            ),
            if (role != 'Admin') ...[
              const SizedBox(height: 12),
              TextField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone number'),
                keyboardType: TextInputType.phone,
              ),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: _passwordCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (role == 'Doctor') {
                        Navigator.pushNamed(context, AppRoutes.doctorDashboard);
                      } else if (role == 'Admin') {
                        Navigator.pushNamed(context, AppRoutes.adminDashboard);
                      } else {
                        Navigator.pushNamed(context, AppRoutes.patientHistory);
                      }
                    },
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(width: 12),
                if (role == 'Doctor')
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.registerDoctor);
                      },
                      child: const Text('Register'),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (role != 'Admin')
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.otp);
                },
                child: const Text('Login with OTP'),
              ),
          ],
        ),
      ),
    );
  }
}


