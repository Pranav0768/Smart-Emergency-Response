import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../models/incident.dart';
import '../services/database_helper.dart';

class IncidentProvider with ChangeNotifier {
  List<Incident> _incidents = [];
  bool _isLoading = false;

  List<Incident> get incidents => _incidents;
  bool get isLoading => _isLoading;

  Future<void> fetchIncidents() async {
    _isLoading = true;
    notifyListeners();


    try {
      if (kIsWeb) {
        // web doesn't support sqflite out of the box, use in-memory list for preview
        await Future.delayed(const Duration(milliseconds: 500));
      } else {
        _incidents = await DatabaseHelper.instance.readAllIncidents();
      }
    } catch (e) {
      debugPrint('Database fetch error: $e');
    }
    _sortIncidents();

    _isLoading = false;
    notifyListeners();
  }

  void _sortIncidents() {
    _incidents.sort((a, b) {
      final aPriority = _getPriorityValue(a.priority);
      final bPriority = _getPriorityValue(b.priority);
      
      if (aPriority != bPriority) {
        return bPriority.compareTo(aPriority); // Higher priority first
      } else {
        return b.timestamp.compareTo(a.timestamp); // Newer first
      }
    });
  }

  int _getPriorityValue(String priority) {
    switch (priority) {
      case 'Critical': return 4;
      case 'High': return 3;
      case 'Medium': return 2;
      case 'Low': return 1;
      default: return 0;
    }
  }

  Future<void> addIncident(Incident incident) async {
    if (!kIsWeb) {
      try { await DatabaseHelper.instance.create(incident); } catch (e) {}
    }
    _incidents.add(incident);
    _sortIncidents();
    notifyListeners();
  }

  Future<void> updateIncident(Incident incident) async {
    if (!kIsWeb) {
      try { await DatabaseHelper.instance.update(incident); } catch (e) {}
    }
    final index = _incidents.indexWhere((i) => i.id == incident.id);
    if (index != -1) {
      _incidents[index] = incident;
      _sortIncidents();
      notifyListeners();
    }
  }

  Future<void> deleteIncident(String id) async {
    if (!kIsWeb) {
      try { await DatabaseHelper.instance.delete(id); } catch (e) {}
    }
    _incidents.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  // Dashboard Stats
  int get totalIncidents => _incidents.length;
  int get activeCases => _incidents.where((i) => i.status != 'Resolved').length;
  int get resolvedCases => _incidents.where((i) => i.status == 'Resolved').length;

  Map<String, int> get priorityDistribution {
    final dist = {'Critical': 0, 'High': 0, 'Medium': 0, 'Low': 0};
    for (var incident in _incidents) {
      if (dist.containsKey(incident.priority)) {
        dist[incident.priority] = dist[incident.priority]! + 1;
      }
    }
    return dist;
  }
}
