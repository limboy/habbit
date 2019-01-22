import '../models/dailytask.dart';
import '../models/habit.dart';
import '../models/serializers.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:built_collection/built_collection.dart';

const _habitsFilePath = 'habits.json';
const _taskFilePath = 'habit-{}-tasks.json';
const _profileFilePath = 'me.json';

class Repository {
  BuiltList<Habit> _habits = BuiltList();

  BuiltList<Habit> get habits => _habits;

  Repository() {
    // meanwhile ensure _habits is inited.
    // migrateDBIfNeeded();
  }

  Future migrateDBIfNeeded() async {
    final dirPath = await getApplicationDocumentsDirectory();
    final file = File('${dirPath.path}/$_profileFilePath');
    final oldFile = File('${dirPath.path}/$_habitsFilePath');

    _getTasksByHabitID(int habitID) async {
      Map<int, BuiltList<DailyTask>> _tasks = {};
      try {
        final dirPath = await getApplicationDocumentsDirectory();
        final file = File('${dirPath.path}/$_taskFilePath'
            .replaceFirst('{}', habitID.toString()));
        final content = await file.readAsString();
        _tasks[habitID] = serializers.deserialize(json.decode(content),
            specifiedType: builtListTaskType);
      } catch (e) {
        print('something wrong happend when opening tasks file: $e');
      }
      return _tasks[habitID];
    }

    Future<BuiltList<Habit>> _getHabits() async {
      BuiltList<Habit> habits;
      try {
        final dirPath = await getApplicationDocumentsDirectory();
        final file = File('${dirPath.path}/$_habitsFilePath');
        final content = await file.readAsString();
        habits = serializers.deserialize(json.decode(content),
            specifiedType: builtListHabitType);
      } catch (e) {
        print('something wrong happend when opening habits file: $e');
      }
      return habits;
    }

    if (!file.existsSync() && oldFile.existsSync()) {
      final habits = await _getHabits();
      for (final habit in habits) {
        final tasks = await _getTasksByHabitID(habit.habitID);
        // remove habitID in tasks
        final _tasks = ListBuilder<DailyTask>();
        for (final task in tasks) {
          final _task = task.rebuild((b) => b..habitID = null);
          _tasks.add(_task);
        }

        var filledHabit = habit.rebuild((b) => b..tasks = _tasks);
        _habits = _habits.rebuild((b) => b.add(filledHabit));
      }

      final result = json.encode(serializers.serialize(_habits));
      file.writeAsStringSync(result);
    } else if (file.existsSync()) {
      final content = await file.readAsString();
      _habits = serializers.deserialize(json.decode(content),
          specifiedType: builtListHabitType);
    }
  }

  Future<Habit> createHabit(Habit habit) async {
    List<DailyTask> _createTasks(int habitID) {
      var tasks = <DailyTask>[];
      for (int i = 1; i <= 81; i++) {
        final task = DailyTask((b) => b..seq = i);
        tasks.add(task);
      }
      return tasks;
    }

    if (habit.habitID == null) {
      habit = habit.rebuild((b) => b..habitID = b.created);
    }
    final tasks = _createTasks(habit.habitID);
    habit = habit.rebuild((b) => b..tasks = ListBuilder(tasks));

    _habits = _habits.rebuild((b) => b..add(habit));
    _persistentHabits();
    return habit;
  }

  Future<Habit> updateHabit(Habit habit) async {
    final originHabit =
        _habits.firstWhere((_habit) => _habit.habitID == habit.habitID);
    final habitIndex = _habits.indexOf(originHabit);
    _habits = _habits
        .rebuild((b) => b..replaceRange(habitIndex, habitIndex + 1, [habit]));

    _persistentHabits();
    return habit;
  }

  deleteHabit(Habit habit) async {
    final habits = _habits;
    final habitIndex =
        habits.indexWhere((_habit) => _habit.habitID == habit.habitID);
    _habits = habits.rebuild((b) => b..removeAt(habitIndex));
    _persistentHabits();
  }

  BuiltList<DailyTask> getTasks(int habitID) {
    BuiltList<DailyTask> tasks;
    for (var habit in _habits) {
      if (habit.habitID == habitID) {
        tasks = habit.tasks;
      }
    }
    return tasks;
  }

  Future<DailyTask> updateTask(DailyTask task, int habitID) async {
    BuiltList<DailyTask> tasks;
    Habit habit;

    for (var _habit in _habits) {
      if (_habit.habitID == habitID) {
        tasks = _habit.tasks;
        habit = _habit;
      }
    }

    int habitIndex = _habits.indexOf(habit);

    final originTask = tasks.firstWhere((_task) => _task.seq == task.seq);
    final taskIndex = tasks.indexOf(originTask);
    final updatedTasks =
        tasks.rebuild((b) => b.replaceRange(taskIndex, taskIndex + 1, [task]));

    final updatedHabit =
        habit.rebuild((b) => b..tasks = ListBuilder(updatedTasks));
    _habits = _habits.rebuild(
        (b) => b.replaceRange(habitIndex, habitIndex + 1, [updatedHabit]));

    _persistentHabits();
    return task;
  }

  _persistentHabits() async {
    final dirPath = await getApplicationDocumentsDirectory();
    final file = File('${dirPath.path}/$_profileFilePath');

    final result = json.encode(
        serializers.serialize(_habits, specifiedType: builtListHabitType));
    return file.writeAsStringSync(result);
  }
}
