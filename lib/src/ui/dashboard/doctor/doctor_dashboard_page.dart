import 'package:flutter/material.dart';
import '../../common/top_box.dart';
import '../../../routing/app_router.dart';
import '../../../services/storage/db_helper.dart';
import '../doctor/ai_page.dart';

class DoctorDashboardPage extends StatefulWidget {
  final String doctorId;
  const DoctorDashboardPage({super.key, required this.doctorId});

  @override
  State<DoctorDashboardPage> createState() => _DoctorDashboardPageState();
}


class _DoctorDashboardPageState extends State<DoctorDashboardPage> {
  int _selectedIndex = 1; // AI page default index
  late PageController _pageController;
  String _firstName = "";

  @override
  void initState() {
    super.initState();
    print("DoctorDashboardPage opened with ID: ${widget.doctorId}");
    _pageController = PageController(initialPage: _selectedIndex);
    _loadDoctorName();
  }

  Future<void> _loadDoctorName() async {
    final doctor = await DatabaseHelper.getDoctorById(widget.doctorId);
    print("Doctor record fetched: $doctor");
    setState(() {
      _firstName = doctor?['first_name'] ?? "Doctor";
      print("Doctor first name set to: $_firstName");
    });
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _selectedIndex = index);
  }

  // Inside DoctorDashboardPage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFddf4e7),

      // Top bar
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: TopBox(),
      ),

      // Main content
      body: Column(
        children: [
          // Greeting + Logout
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/welcome');
                  },
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF09090b)),
                  label: const Text(
                    "Logout",
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 18, // adjusted as you asked before
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF09090b),
                    ),
                  ),
                ),
                Text(
                  "Hello, Dr. $_firstName",
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Swipeable Pages
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                Center(child: Text("Patients Page - TODO")),
                AiPage(),
                Center(child: Text("Alerts Page - TODO")),
                Center(child: Text("Reports Page - TODO")),
                Center(child: Text("Settings Page - TODO")),
              ],
            ),
          ),
        ],
      ),

      // Custom Footer
      bottomNavigationBar: Container(
        color: const Color(0xFF6de1d2), // footer bg
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem("assets/patients_icon.jpeg", "Patients", 0),
            _buildNavItem("assets/bot_icon.jpeg", "AI", 1),
            _buildNavItem("assets/alerts_icon.jpeg", "Alerts", 2),
            _buildNavItem("assets/reports_icon.jpeg", "Reports", 3),
            _buildNavItem("assets/patients_icon.jpeg", "Settings", 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String assetPath, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF13897a) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              assetPath,
              height: 24,
              width: 24,
              color: isSelected ? const Color(0xFF24f2d8) : const Color(0xFF444444),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'SourceSansPro',
                fontSize: 12,
                color: isSelected ? const Color(0xFF24f2d8) : const Color(0xFF444444),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}