import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_provider.dart';
import 'incident_reporting_screen.dart';
import 'incident_list_screen.dart';
import 'search_filter_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Smart Emergency Response & Incident Reporting App', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Color(0xFF1E293B)),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchFilterScreen()),
              ),
            ),
          )
        ],
      ),
      body: Consumer<IncidentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final dist = provider.priorityDistribution;

          return Stack(
            children: [
              // Beautiful Gradient Background
              Container(
                height: 300,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE0F2FE), Color(0xFFF1F5F9)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Status',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF0F172A).withValues(alpha: 0.9),
                            letterSpacing: -1),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(child: _buildStatCard('Total\nIncidents', provider.totalIncidents.toString(), const Color(0xFF3B82F6), Icons.analytics_rounded)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildStatCard('Active\nCases', provider.activeCases.toString(), const Color(0xFFF59E0B), Icons.warning_rounded)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildStatCard('Resolved\nCases', provider.resolvedCases.toString(), const Color(0xFF10B981), Icons.check_circle_rounded)),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Priority',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: Column(
                          children: [
                            _buildPriorityBar('Critical', dist['Critical'] ?? 0, const Color(0xFFEF4444), provider.totalIncidents),
                            _buildPriorityBar('High', dist['High'] ?? 0, const Color(0xFFF97316), provider.totalIncidents),
                            _buildPriorityBar('Medium', dist['Medium'] ?? 0, const Color(0xFFEAB308), provider.totalIncidents),
                            _buildPriorityBar('Low', dist['Low'] ?? 0, const Color(0xFF22C55E), provider.totalIncidents),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E293B),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const IncidentListScreen()));
                          },
                          child: const Text('Manage All Incidents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const IncidentReportingScreen()));
        },
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_alert_rounded),
        label: const Text('Report', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: color, height: 1.0)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w600, height: 1.2)),
        ],
      ),
    );
  }

  Widget _buildPriorityBar(String label, int count, Color color, int total) {
    double factor = total == 0 ? 0 : (count / total);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          SizedBox(width: 70, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF475569)))),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 12,
                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      height: 12,
                      width: constraints.maxWidth * factor,
                      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
                    );
                  }
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(width: 30, child: Text(count.toString(), textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
        ],
      ),
    );
  }
}
