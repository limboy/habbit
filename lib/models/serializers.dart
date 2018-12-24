library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/serializer.dart';
import '../models/dailytask.dart';
import '../models/habit.dart';

part 'serializers.g.dart';

/// Collection of generated serializers for the built_value chat example.
@SerializersFor(const [
  DailyTask,
  Habit,
])
final Serializers flatSerializers = _$flatSerializers;

final builtListHabitType = FullType(BuiltList, [FullType(Habit)]);
final builtListTaskType = FullType(BuiltList, [FullType(DailyTask)]);

final serializers = (flatSerializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..addBuilderFactory(builtListHabitType, () => ListBuilder<Habit>())
      ..addBuilderFactory(builtListTaskType, () => ListBuilder<DailyTask>()))
    .build();
