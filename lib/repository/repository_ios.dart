import '../models/dailytask.dart';
import '../models/habit.dart';
import './repository.dart';
import '../mock/tasks.dart';

class RepositoryIOS extends Repository {
  List<Habit> habits = <Habit>[];

  Future<Habit> createHabit(Habit habit) async {
    habits.add(habit);
    return habit;
  }

  Future<Habit> updateHabit(Habit habit) async {
    return habit;
  }

  Future<List<Habit>> getHabits() async {
    return habits;
  }

  deleteHabit(Habit habit) {
    habits.removeWhere((_habit) {
      return _habit.title == habit.title;
    });
  }

  Future<List<DailyTask>> getTasks(int habitID) async {
    return threeTasks;
  }

  Future<DailyTask> updateTask(DailyTask task) async {
    return task;
  }
}
