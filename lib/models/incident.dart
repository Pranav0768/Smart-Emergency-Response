class Incident {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String location;
  final String status;
  final DateTime timestamp;
  final String? assignedResponder;
  final bool isSynced;

  Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.location,
    this.status = 'Reported',
    required this.timestamp,
    this.assignedResponder,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'location': location,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'assignedResponder': assignedResponder,
      'isSynced': isSynced ? 1 : 0,
    };
  }

  factory Incident.fromMap(Map<String, dynamic> map) {
    return Incident(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      priority: map['priority'],
      location: map['location'],
      status: map['status'],
      timestamp: DateTime.parse(map['timestamp']),
      assignedResponder: map['assignedResponder'],
      isSynced: map['isSynced'] == 1,
    );
  }

  Incident copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? priority,
    String? location,
    String? status,
    DateTime? timestamp,
    String? assignedResponder,
    bool? isSynced,
  }) {
    return Incident(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      location: location ?? this.location,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      assignedResponder: assignedResponder ?? this.assignedResponder,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
