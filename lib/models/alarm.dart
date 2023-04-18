import 'package:hive/hive.dart';

part 'alarm.g.dart';

@HiveType(typeId: 0)
class AlarmModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final DateTime time;
  @HiveField(3)
  final List<String> weekdays;
  @HiveField(4)
  final bool islaunched;

  AlarmModel({
    required this.id,
    this.name,
    required this.time,
    required this.weekdays,
    required this.islaunched,
  });

  AlarmModel copyWith({
    String? id,
    String? name,
    DateTime? time,
    List<String>? weekdays,
    bool? islaunched,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      weekdays: weekdays ?? this.weekdays,
      islaunched: islaunched ?? this.islaunched,
    );
  }
}
