import 'package:flutter/material.dart';

import '../../../routing/app_router.dart';

class DoctorDashboardPage extends StatefulWidget {
  const DoctorDashboardPage({super.key});

  @override
  State<DoctorDashboardPage> createState() => _DoctorDashboardPageState();
}

class _DoctorDashboardPageState extends State<DoctorDashboardPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _PatientsTab(),
      _AIToolsTab(),
      _NotificationsTab(),
      _ReportsTab(),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Dashboard')),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.people_alt), label: 'Patients'),
          NavigationDestination(icon: Icon(Icons.science), label: 'AI Tools'),
          NavigationDestination(icon: Icon(Icons.notifications), label: 'Alerts'),
          NavigationDestination(icon: Icon(Icons.picture_as_pdf), label: 'Reports'),
        ],
        onDestinationSelected: (i) => setState(() => index = i),
      ),
    );
  }
}

class _PatientsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.patientHistory);
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Create / View Patient'),
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          child: Center(
            child: Text('Patients list (offline-first) placeholder'),
          ),
        ),
      ],
    );
  }
}

class _AIToolsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: const [
          _ToolCard(icon: Icons.camera_alt, title: 'Dental Imaging'),
          _ToolCard(icon: Icons.bloodtype, title: 'CBC Classifier'),
          _ToolCard(icon: Icons.description, title: 'OCR Digitize'),
          _ToolCard(icon: Icons.sync, title: 'Sync Status'),
        ],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  const _ToolCard({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(icon, size: 36), const SizedBox(height: 8), Text(title)],
          ),
        ),
      ),
    );
  }
}

class _NotificationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Urgent alerts & updates placeholder'));
  }
}

class _ReportsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Reports & PDF exports placeholder'));
  }
}


