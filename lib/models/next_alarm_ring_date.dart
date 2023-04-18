class NextAlarmRingDate {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  NextAlarmRingDate({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
  });

  NextAlarmRingDate copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
  }) {
    return NextAlarmRingDate(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  factory NextAlarmRingDate.fromMap(Map<String, dynamic> map) {
    return NextAlarmRingDate(
      year: map['year'] as int,
      month: map['month'] as int,
      day: map['day'] as int,
      hour: map['hour'] as int,
      minute: map['minute'] as int,
    );
  }

  DateTime convertToDateTime() => DateTime(year, month, day, hour, minute);
}
