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
        final selectedHabit = habits[0].rebuild((b) => b..isSelected = true);
        habits[0] = selectedHabit;
        _habits.add(BuiltList(habits));
        tasksBloc.selectHabit(selectedHabit.habitID);
      }
    });
  }

  HabitsBloc() {
    _getHabits();
  }

  addHabit(Habit habit) {
    Env.repository.createHabit(habit).then((habit) {
      final habits = _habits.value.rebuild((b) => b..add(habit));
      _habits.add(habits);
      if (_habits.value.length == 1) {
        selectHabit(habit);
      }
    });
  }

  selectHabit(Habit habit) {
    final habitIndex = _habits.value.indexOf(habit);
    _habits.add(_habits.value
        .rebuild((b) => b.replaceRange(habitIndex, habitIndex + 1, [habit])));
    tasksBloc.selectHabit(habit.habitID);
  }

  dispose() {
    _habits.close();
  }
}
