import '../models/habit.dart';
import '../models/dailytask.dart';

abstract class Repository {
  Future<Habit> createHabit(Habit habit);
  Future<Habit> updateHabit(Habit habit);
  Future<List<Habit>> getHabits();
  deleteHabit(Habit habit);

  Future<List<DailyTask>> getTasks(int habitID);
  Future<DailyTask> updateTask(DailyTask task);
}
