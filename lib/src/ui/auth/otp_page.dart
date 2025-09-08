import 'package:flutter/material.dart';

import '../../routing/app_router.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpCtrl = TextEditingController();
  String method = 'SMS';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: method,
              items: const [
                DropdownMenuItem(value: 'SMS', child: Text('SMS')),
                DropdownMenuItem(value: 'Email', child: Text('Email')),
              ],
              onChanged: (v) => setState(() => method = v ?? 'SMS'),
              decoration: const InputDecoration(labelText: 'Delivery Method'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _otpCtrl,
              decoration: const InputDecoration(labelText: 'Enter OTP'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.doctorDashboard);
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}


