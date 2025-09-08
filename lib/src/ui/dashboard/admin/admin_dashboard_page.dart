import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('Approve Doctors'),
              subtitle: Text('Manage pending doctor accounts'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text('Audit Logs'),
              subtitle: Text('Review system actions'),
            ),
          ],
        ),
      ),
    );
  }
}


