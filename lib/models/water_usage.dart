class WaterUsage {
  final String id;
  final String activity;
  final double litres;
  final String category;
  final DateTime date;
  final String? note;

  WaterUsage({
    required this.id,
    required this.activity,
    required this.litres,
    required this.category,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'activity': activity,
      'litres': litres,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory WaterUsage.fromMap(Map<String, dynamic> map) {
    return WaterUsage(
      id: map['id'],
      activity: map['activity'],
      litres: (map['litres'] as num).toDouble(),
      category: map['category'],
      date: DateTime.parse(map['date']),
      note: map['note'],
    );
  }
}