import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final List<String> statuses = [
    "Opening application...",
    "Connecting to cloud...",
    "Loading user data...",
    "Almost ready..."
  ];
  int _statusIndex = 0;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() async {
    for (int i = 0; i < statuses.length; i++) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _statusIndex = i;
        _progress = (i + 1) / statuses.length;
      });
    }
    // TODO: Navigate to the next page after loading
    // Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Bigger logo
            Image.asset(
              'assets/logo.png',
              width: 223,
              height: 242,
            ),
            const SizedBox(height: 40),
            // ✅ Rounded progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 250,
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: const Color(0xFF757575), // gray
                  color: const Color(0xFF4caf50), // green
                  minHeight: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              statuses[_statusIndex],
              style: GoogleFonts.ubuntu( 
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            if (_statusIndex < statuses.length - 1)
              const CircularProgressIndicator(
                color: Color(0xFF4caf50),
                strokeWidth: 3,
              ),
          ],
        ),
      ),
    );
  }
}
