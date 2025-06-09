class EventModel {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String createdBy;
  final String? color;
  final DateTime createdAt;

  EventModel({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.createdBy,
    this.color,
    required this.createdAt,
  });

  factory EventModel.fromMap(Map<String, dynamic> data, String docId) {
    return EventModel(
      id: docId,
      title: data['title'] ?? '',
      description: data['description'],
      startTime: DateTime.parse(data['startTime']),
      endTime: DateTime.parse(data['endTime']),
      createdBy: data['createdBy'] ?? '',
      color: data['color'],
      createdAt: DateTime.parse(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'createdBy': createdBy,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
