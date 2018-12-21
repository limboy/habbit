import 'package:rxdart/rxdart.dart';
import '../models/habit.dart';
import '../env.dart';
import '../blocs/bloc_base.dart';
import '../blocs/tasks_bloc.dart';
import 'package:built_collection/built_collection.dart';

class HabitsBloc extends BlocBase {
  final _habits = BehaviorSubject<BuiltList<Habit>>(seedValue: BuiltList());
  final tasksBloc = TasksBloc();

  Stream<BuiltList<Habit>> get habits => _habits.stream;

  _getHabits() {
    Env.repository.getHabits().then((habits) {
      if (habits.length > 0) {
        _habits.value = BuiltList(habits);
        selectHabit(habits[0]);
      }
    });
  }

  HabitsBloc() {
    _getHabits();
  }

  addHabit(Habit habit) {
    Env.repository.createHabit(habit).then((habit) {
      final habits = _habits.value.rebuild((b) => b..add(habit));
      if (habits.length == 1) {
        _habits.value = habits;
        selectHabit(habit);
      } else {
        _habits.add(habits);
      }
    });
  }

  selectHabit(Habit habit) {
    final selectedHabit = habit.rebuild((b) => b..isSelected = true);
    final habitIndex = _habits.value.indexOf(habit);

    // remove previous isSelected
    _habits.value = _habits.value.rebuild((b) =>
        b..map((item) => item.rebuild((_item) => _item.isSelected = false)));

    _habits.add(_habits.value.rebuild(
        (b) => b.replaceRange(habitIndex, habitIndex + 1, [selectedHabit])));
    tasksBloc.selectHabit(habit.habitID);
  }

  updateHabit(Habit habit) {
    final theHabit =
        _habits.value.where((_habit) => _habit.habitID == habit.habitID).first;
    final habitIndex = _habits.value.indexOf(theHabit);
    Env.repository.updateHabit(habit).then((habit) {
      _habits.add(_habits.value
          .rebuild((b) => b.replaceRange(habitIndex, habitIndex + 1, [habit])));
    });
  }

  deleteHabit(Habit habit) {
    final habitIndex = _habits.value.indexOf(habit);
    final newHabits = _habits.value.rebuild((b) => b.removeAt(habitIndex));
    _habits.add(newHabits);
    if (newHabits.length > 0) {
      selectHabit(newHabits[0]);
    }
  }

  dispose() {
    _habits.close();
  }
}
