import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 1)
class Habit extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final int interval;
  @HiveField(4)
  final bool isEnabled;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.interval,
    required this.isEnabled,
  });

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    int? interval,
    bool? isEnabled,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      interval: interval ?? this.interval,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
