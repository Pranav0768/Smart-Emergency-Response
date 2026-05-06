import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_provider.dart';
import 'incident_details_screen.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  String _searchQuery = '';
  String? _selectedStatus;
  String? _selectedPriority;
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search & Filter')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by Title or ID',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildFilterDropdown(
                  'Status',
                  ['Reported', 'In Progress', 'Resolved'],
                  _selectedStatus,
                  (val) => setState(() => _selectedStatus = val),
                ),
                const SizedBox(width: 8),
                _buildFilterDropdown(
                  'Priority',
                  ['Low', 'Medium', 'High', 'Critical'],
                  _selectedPriority,
                  (val) => setState(() => _selectedPriority = val),
                ),
                const SizedBox(width: 8),
                _buildFilterDropdown(
                  'Category',
                  ['Medical', 'Fire', 'Security', 'Accident', 'Other'],
                  _selectedCategory,
                  (val) => setState(() => _selectedCategory = val),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedStatus = null;
                      _selectedPriority = null;
                      _selectedCategory = null;
                      _searchQuery = '';
                    });
                  },
                  child: const Text('Clear'),
                )
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Consumer<IncidentProvider>(
              builder: (context, provider, child) {
                final results = provider.incidents.where((incident) {
                  final matchesSearch = incident.title.toLowerCase().contains(_searchQuery) ||
                                        incident.id.toLowerCase().contains(_searchQuery);
                  final matchesStatus = _selectedStatus == null || incident.status == _selectedStatus;
                  final matchesPriority = _selectedPriority == null || incident.priority == _selectedPriority;
                  final matchesCategory = _selectedCategory == null || incident.category == _selectedCategory;

                  return matchesSearch && matchesStatus && matchesPriority && matchesCategory;
                }).toList();

                if (results.isEmpty) {
                  return const Center(child: Text('No results found'));
                }

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final incident = results[index];
                    return ListTile(
                      title: Text(incident.title),
                      subtitle: Text('${incident.category} • ${incident.priority}'),
                      trailing: Text(incident.status),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => IncidentDetailsScreen(incident: incident)),
                        );
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String hint, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      hint: Text(hint),
      value: value,
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
      onChanged: onChanged,
    );
  }
}
