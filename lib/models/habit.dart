library habit;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import './dailytask.dart';

part 'habit.g.dart';

abstract class Habit implements Built<Habit, HabitBuilder> {
  static Serializer<Habit> get serializer => _$habitSerializer;
  factory Habit([updates(HabitBuilder b)]) = _$Habit;
  Habit._();

  @nullable
  int get habitID;

  String get title;

  int get created;

  @nullable
  bool get isSelected;

  String get createdString {
    final dt = DateTime.fromMicrosecondsSinceEpoch(created);
    return '${dt.month}/${dt.day}/${dt.year}';
  }
}
