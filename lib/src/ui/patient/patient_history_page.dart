import 'package:flutter/material.dart';

class PatientHistoryPage extends StatelessWidget {
  const PatientHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Profile & History')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text('Export PDF'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Name: Placeholder Patient'),
            subtitle: Text('NID: 00000000000000'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.timeline),
            title: Text('Timeline'),
            subtitle: Text('CBC: Normal (Aug 2025)\nDental: Caries detected (Aug 2025)'),
          ),
        ],
      ),
    );
  }
}


