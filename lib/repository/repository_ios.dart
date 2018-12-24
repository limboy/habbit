import '../models/dailytask.dart';
import '../models/habit.dart';
import './repository.dart';
import 'dart:convert';
import '../mock/tasks.dart';
import '../models/serializers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'dart:io';

const _habitsFilePath = 'habits.json';
const _taskFilePath = 'habit-{}-tasks.json';

class RepositoryIOS extends Repository {
  BuiltList<Habit> _habits = BuiltList();
  Map<int, BuiltList<DailyTask>> _tasks = {};

  Future<Habit> createHabit(Habit habit) async {
    if (habit.habitID == null) {
      habit = habit.rebuild((b) => b..habitID = b.created);
    }
    _habits = _habits.rebuild((b) => b..add(habit));
    _persistentHabits();
    _createTasks(habit.habitID);
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

  Future<BuiltList<Habit>> getHabits() async {
    try {
      final dirPath = await getApplicationDocumentsDirectory();
      final file = File('${dirPath.path}/$_habitsFilePath');
      final content = await file.readAsString();
      _habits = serializers.deserialize(json.decode(content),
          specifiedType: builtListHabitType);
    } catch (e) {
      print('something wrong happend when opening habits file: $e');
    }
    return _habits;
  }

  deleteHabit(Habit habit) async {
    final habitIndex =
        _habits.indexWhere((_habit) => _habit.habitID == habit.habitID);
    _habits = _habits.rebuild((b) => b..removeAt(habitIndex));
    _persistentHabits();
    _deleteTasks(habit.habitID);
  }

  Future<BuiltList<DailyTask>> getTasks(int habitID) async {
    var tasks = _tasks[habitID];
    if (tasks == null) {
      tasks = await _getTasksByHabitID(habitID);
    }
    return tasks;
  }

  Future<DailyTask> updateTask(DailyTask task) async {
    var _targetTasks = _tasks[task.habitID];
    final originTask =
        _targetTasks.firstWhere((_task) => _task.seq == task.seq);
    final taskIndex = _targetTasks.indexOf(originTask);
    _tasks[task.habitID] = _targetTasks
        .rebuild((b) => b.replaceRange(taskIndex, taskIndex + 1, [task]));
    _persistentTasks(task.habitID);
    return task;
  }

  _getTasksByHabitID(int habitID) async {
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

  _createTasks(int habitID) async {
    var tasks = <DailyTask>[];
    for (int i = 1; i <= 81; i++) {
      final task = DailyTask((b) => b
        ..habitID = habitID
        ..seq = i);
      tasks.add(task);
    }
    _tasks[habitID] = BuiltList(tasks);
    _persistentTasks(habitID);
  }

  _persistentHabits() async {
    final dirPath = await getApplicationDocumentsDirectory();
    final file = File('${dirPath.path}/$_habitsFilePath');

    final specifiedType = FullType(BuiltList, [FullType(Habit)]);
    final result = json
        .encode(serializers.serialize(_habits, specifiedType: specifiedType));
    return file.writeAsStringSync(result);
  }

  _persistentTasks(int habitID) async {
    final dirPath = await getApplicationDocumentsDirectory();
    final file = File('${dirPath.path}/$_taskFilePath'
        .replaceFirst('{}', habitID.toString()));

    final specifiedType = FullType(BuiltList, [FullType(DailyTask)]);
    final result = json.encode(
        serializers.serialize(_tasks[habitID], specifiedType: specifiedType));
    return file.writeAsStringSync(result);
  }

  _deleteTasks(int habitID) async {
    final dirPath = await getApplicationDocumentsDirectory();
    final file = File('${dirPath.path}/$_taskFilePath'
        .replaceFirst('{}', habitID.toString()));

    return file.deleteSync();
  }
}
