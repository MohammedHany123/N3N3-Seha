import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../services/storage/db_helper.dart';
import 'patient_details_page.dart';

enum AlertFilter { all, unread, read }

class AlertsPage extends StatefulWidget {
  final String doctorId;
  const AlertsPage({super.key, required this.doctorId});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  List<Map<String, dynamic>> _alerts = [];
  bool _loading = true;
  AlertFilter _filter = AlertFilter.all;

  @override
  void initState() {
    super.initState();
    _fetchAlerts();
  }

  List<Map<String, dynamic>> get _filteredAlerts {
    if (_filter == AlertFilter.all) return _alerts;
    if (_filter == AlertFilter.unread) {
      return _alerts.where((a) => a['status'] == 'unread').toList();
    }
    return _alerts.where((a) => a['status'] == 'read').toList();
  }

  Future<void> _fetchAlerts() async {
    final alerts = await DatabaseHelper.getDoctorAlerts(widget.doctorId);
    setState(() {
      _alerts = alerts;
      _loading = false;
    });
  }

  Future<void> _markAsRead(int alertId) async {
    await DatabaseHelper.markAlertAsRead(alertId);
    await _fetchAlerts();
  }

  Future<void> _markAsUnread(int alertId) async {
    await DatabaseHelper.markAlertAsUnread(alertId);
    await _fetchAlerts();
  }

  Future<void> _deleteAlert(int alertId) async {
    await DatabaseHelper.deleteAlert(alertId);
    await _fetchAlerts();
  }

  void _openPatient(String patientId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PatientDetailsPage(patientId: patientId, doctorId: widget.doctorId),
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: const Color(0xFF26667f),
            child: ClipOval(
              child: Image.asset(
                "assets/alerts_icon.jpeg",
                fit: BoxFit.contain,
                height: 55,
                width: 55,
                color: Colors.white,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    ),
    body: Column(
      children: [
        // Filter popup menu
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton<AlertFilter>(
                icon: const Icon(Icons.filter_list, color: Color(0xFF26667f)),
                onSelected: (value) => setState(() => _filter = value),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: AlertFilter.all,
                    child: Text("All"),
                  ),
                  const PopupMenuItem(
                    value: AlertFilter.unread,
                    child: Text("Unread"),
                  ),
                  const PopupMenuItem(
                    value: AlertFilter.read,
                    child: Text("Read"),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _filteredAlerts.isEmpty
                  ? Center(child: Text("No alerts", style: GoogleFonts.roboto(fontSize: 18)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredAlerts.length,
                      itemBuilder: (context, index) {
                        final alert = _filteredAlerts[index];
                        final isUnread = alert['status'] == 'unread';
                        return Card(
                          color: isUnread ? const Color(0xFFfbe9e7) : Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            onTap: () => _openPatient(alert['patientId']),
                            leading: Icon(
                              isUnread ? Icons.notifications_active : Icons.notifications_none,
                              color: isUnread ? Colors.red : Colors.grey,
                            ),
                            title: Text(
                              alert['title'] ?? '',
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                color: isUnread ? Colors.red : Colors.black,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  alert['description'] ?? '',
                                  style: GoogleFonts.roboto(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('yyyy-MM-dd – HH:mm').format(DateTime.parse(alert['datetime'])),
                                  style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'read') {
                                  _markAsRead(alert['id']);
                                } else if (value == 'unread') {
                                  _markAsUnread(alert['id']);
                                } else if (value == 'delete') {
                                  _deleteAlert(alert['id']);
                                }
                              },
                              itemBuilder: (context) => [
                                if (isUnread)
                                  const PopupMenuItem(value: 'read', child: Text("Mark as read")),
                                if (!isUnread)
                                  const PopupMenuItem(value: 'unread', child: Text("Mark as unread")),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text("Delete", style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    ),
  );
}
}