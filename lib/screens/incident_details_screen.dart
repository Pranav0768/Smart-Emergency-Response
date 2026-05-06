import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/incident.dart';
import '../providers/incident_provider.dart';

class IncidentDetailsScreen extends StatefulWidget {
  final Incident incident;
  const IncidentDetailsScreen({super.key, required this.incident});

  @override
  State<IncidentDetailsScreen> createState() => _IncidentDetailsScreenState();
}

class _IncidentDetailsScreenState extends State<IncidentDetailsScreen> {
  late String _status;
  late String _assignee;

  @override
  void initState() {
    super.initState();
    _status = widget.incident.status;
    _assignee = widget.incident.assignedResponder ?? '';
  }

  void _updateIncident() {
    final updated = widget.incident.copyWith(
      status: _status,
      assignedResponder: _assignee.isEmpty ? null : _assignee,
    );
    Provider.of<IncidentProvider>(context, listen: false).updateIncident(updated);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incident updated')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Incident Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.incident.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Reported: ${DateFormat.yMMMd().add_jm().format(widget.incident.timestamp)}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            _buildInfoRow('ID:', widget.incident.id),
            _buildInfoRow('Category:', widget.incident.category),
            _buildInfoRow('Priority:', widget.incident.priority),
            _buildInfoRow('Location:', widget.incident.location),
            const Divider(height: 32),
            const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.incident.description),
            const Divider(height: 32),
            const Text('Admin Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
              items: ['Reported', 'In Progress', 'Resolved'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => _status = val!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _assignee,
              decoration: const InputDecoration(labelText: 'Assign Responder', border: OutlineInputBorder()),
              onChanged: (val) => _assignee = val,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateIncident,
                child: const Text('Update Incident'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
