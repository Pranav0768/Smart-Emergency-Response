import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/incident_provider.dart';
import 'incident_details_screen.dart';

class IncidentListScreen extends StatelessWidget {
  const IncidentListScreen({super.key});

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Critical': return Colors.red;
      case 'High': return Colors.orange;
      case 'Medium': return Colors.amber;
      case 'Low': return Colors.green;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Incidents')),
      body: Consumer<IncidentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.incidents.isEmpty) {
            return const Center(child: Text('No incidents reported yet'));
          }

          return ListView.builder(
            itemCount: provider.incidents.length,
            itemBuilder: (context, index) {
              final incident = provider.incidents[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: _getPriorityColor(incident.priority), width: 2),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: ListTile(
                  title: Text(incident.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${incident.category} • ${incident.status}\n'
                    '${DateFormat.yMMMd().add_jm().format(incident.timestamp)}'
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(incident.priority).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Text(incident.priority, style: TextStyle(color: _getPriorityColor(incident.priority), fontWeight: FontWeight.bold)),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => IncidentDetailsScreen(incident: incident)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
