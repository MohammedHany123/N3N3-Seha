import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/top_box.dart';
import '../../../services/storage/db_helper.dart';
import '../doctor/doctor_dashboard_page.dart';

class DoctorSettingsPage extends StatefulWidget {
  final String doctorId;
  final String fname;
  final String lname;
  final String email;
  final String phone;
  final String? profileImagePath;
  final String name;

  const DoctorSettingsPage({
    super.key,
    required this.doctorId,
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
    this.profileImagePath,
  }) : name = '$fname $lname';

  @override
  State<DoctorSettingsPage> createState() => _DoctorSettingsPageState();
}

class _DoctorSettingsPageState extends State<DoctorSettingsPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  File? _profileImage;
  bool _isDarkTheme = false;
  bool _notificationsEnabled = true;
  String _language = 'en';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    if (widget.profileImagePath != null) {
      _profileImage = File(widget.profileImagePath!);
    }
  }

  Future<void> _pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
      await DatabaseHelper.updateDoctorProfileImage(widget.doctorId, picked.path);
    }
  }

  void _changePassword() {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Password', style: TextStyle(color: Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPassController,
              obscureText: true,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(labelText: 'Old Password'),
            ),
            TextField(
              controller: newPassController,
              obscureText: true,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await DatabaseHelper.updateDoctorPassword(
                widget.doctorId,
                newPassController.text,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF26667f)),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    // TODO: Clear session/token if needed
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void _saveProfile() async {
    await DatabaseHelper.updateDoctorProfile(
      widget.doctorId,
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated!')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorDashboardPage(doctorId: widget.doctorId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF26667f),
              child: Icon(
                Icons.settings,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Profile Picture
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage('assets/doctor_icon.jpeg') as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: _pickProfileImage,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFF26667f),
                      child: const Icon(Icons.edit, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Profile Fields
          TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.black), // <- label
              prefixIcon: Icon(Icons.person, color: Colors.black), // <- icon
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.black), // <- label
              prefixIcon: Icon(Icons.email, color: Colors.black), // <- icon
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              labelText: 'Phone',
              labelStyle: TextStyle(color: Colors.black), // <- label
              prefixIcon: Icon(Icons.phone, color: Colors.black), // <- icon
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF26667f),
              foregroundColor: Colors.white,
            ),
            child: const Text('Save Profile'),
          ),
          const Divider(height: 36),

          // App Preferences
          Text('App Preferences', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Colors.black)),
          SwitchListTile(
            title: const Text('Dark Theme', style: TextStyle(color: Colors.black)),
            value: _isDarkTheme,
            onChanged: (val) => setState(() => _isDarkTheme = val),
            secondary: const Icon(Icons.dark_mode, color: Colors.black),
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.black),
            title: const Text(
              'Language',
              style: TextStyle(color: Colors.black),
            ),
            trailing: DropdownButton<String>(
              value: _language,
              dropdownColor: Colors.white, // dropdown menu background white
              style: const TextStyle(color: Colors.black), // dropdown items black
              items: const [
                DropdownMenuItem(
                  value: 'en',
                  child: Text('English', style: TextStyle(color: Colors.black)),
                ),
                DropdownMenuItem(
                  value: 'ar',
                  child: Text('العربية', style: TextStyle(color: Colors.black)),
                ),
              ],
              onChanged: (val) => setState(() => _language = val!),
            ),
          ),
          SwitchListTile(
            title: const Text('Enable Notifications', style: TextStyle(color: Colors.black)),
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
            secondary: const Icon(Icons.notifications_active, color: Colors.black),
          ),
          const Divider(height: 36),

          // Account Actions
          Text('Account', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Colors.black)),
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.black),
            title: const Text('Change Password', style: TextStyle(color: Colors.black)),
            onTap: _changePassword,
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}