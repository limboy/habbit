import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart' show BehaviorSubject;
import '../models/habit.dart';
import '../env.dart';
import '../blocs/bloc_base.dart';
import '../blocs/tasks_bloc.dart';
import 'package:built_collection/built_collection.dart';

class HabitsBloc extends BlocBase {
  final habits = BehaviorSubject<BuiltList<Habit>>(seedValue: BuiltList());
  final tasksBloc = TasksBloc();
  final _hasLoaded = BehaviorSubject<bool>(seedValue: false);

  Stream<bool> get hasLoaded {
    return _hasLoaded.stream;
  }

  _getHabits(BuildContext context) async {
    var __habits = await Env.repository.getHabits();
    if (__habits.length > 0) {
      habits.value = BuiltList(__habits);
      await selectHabit(__habits[0], context);
    }
    _hasLoaded.add(true);
  }

  HabitsBloc(BuildContext context) {
    _getHabits(context);
  }

  addHabit(Habit habit, BuildContext context) async {
    if (habit.habitID == null) {
      habit = habit.rebuild((b) => b.habitID = b.created);
    }
    final _habit = await Env.repository.createHabit(habit);
    final _habits = habits.value.rebuild((b) => b..add(_habit));
    if (_habits.length == 1) {
      habits.value = _habits;
      await selectHabit(habit, context);
    } else {
      habits.add(_habits);
    }
    _hasLoaded.add(true);
  }

  selectHabit(Habit habit, BuildContext context) async {
    final selectedHabit = habit.rebuild((b) => b..isSelected = true);
    final habitIndex =
        habits.value.indexWhere((_habit) => _habit.habitID == habit.habitID);

    // remove previous isSelected
    habits.value = habits.value.rebuild((b) =>
        b..map((item) => item.rebuild((_item) => _item.isSelected = false)));

    habits.add(habits.value.rebuild(
        (b) => b.replaceRange(habitIndex, habitIndex + 1, [selectedHabit])));
    await tasksBloc.selectHabit(habit);
  }

  updateHabit(Habit habit) async {
    final theHabit =
        habits.value.where((_habit) => _habit.habitID == habit.habitID).first;
    final habitIndex = habits.value.indexOf(theHabit);
    final _habit = await Env.repository.updateHabit(habit);
    habits.add(habits.value
        .rebuild((b) => b.replaceRange(habitIndex, habitIndex + 1, [_habit])));

    _hasLoaded.add(true);
  }

  deleteHabit(Habit habit, BuildContext context) async {
    await Env.repository.deleteHabit(habit);
    final habitIndex = habits.value.indexOf(habit);
    final newHabits = habits.value.rebuild((b) => b.removeAt(habitIndex));
    habits.add(newHabits);
    if (newHabits.length > 0) {
      await selectHabit(newHabits[0], context);
    }

    _hasLoaded.add(true);
  }

  dispose() {
    habits.close();
  }
}
