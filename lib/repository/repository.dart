import '../models/habit.dart';
import '../models/dailytask.dart';
import 'package:built_collection/built_collection.dart';

abstract class Repository {
  Future<Habit> createHabit(Habit habit);
  Future<Habit> updateHabit(Habit habit);
  Future<BuiltList<Habit>> getHabits();
  deleteHabit(Habit habit);

  Future<BuiltList<DailyTask>> getTasks(int habitID);
  Future<DailyTask> updateTask(DailyTask task);
}
