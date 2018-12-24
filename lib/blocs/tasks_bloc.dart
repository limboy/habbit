import 'package:rxdart/rxdart.dart';
import '../models/dailytask.dart';
import '../models/habit.dart';
// import '../mock/tasks.dart';
import '../blocs/bloc_base.dart';
import 'package:built_collection/built_collection.dart';
import '../env.dart';

final _threeDays = 3;
final _weekDays = 9;
final _monthDays = 25;
final _quaterDays = 81;

class TasksBloc extends BlocBase {
  final selectedTask = BehaviorSubject<DailyTask>();
  final tasks = BehaviorSubject<BuiltList<DailyTask>>();

  BuiltList<DailyTask> _formatTasks(Habit habit, BuiltList<DailyTask> tasks) {
    final now = DateTime.now().toLocal();
    final currentDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final passedDays = currentDate
        .difference(DateTime.fromMicrosecondsSinceEpoch(habit.created))
        .inDays;
    final seq = passedDays + 1;

    var presentedDays = _threeDays;
    if (passedDays >= _threeDays) {
      presentedDays = _weekDays;
    }
    if (passedDays >= _weekDays) {
      presentedDays = _monthDays;
    }
    if (passedDays >= _monthDays) {
      presentedDays = _quaterDays;
    }

    var _tasks = <DailyTask>[];
    for (int i = 0; i < presentedDays; i++) {
      var task = tasks[i];
      if (task.seq > seq) {
        task = task.rebuild((b) => b..isFuture = true);
      } else if (task.seq == seq) {
        task = task.rebuild((b) => b
          ..isSelected = true
          ..isToday = true);
      }
      _tasks.add(task);
    }

    return BuiltList(_tasks);
  }

  selectHabit(Habit habit) async {
    final _tasks = await Env.repository.getTasks(habit.habitID);
    final formatedTasks = _formatTasks(habit, _tasks);
    tasks.add(formatedTasks);
    selectedTask
        .add(formatedTasks.where((task) => task.isSelected == true).first);
  }

  selectTask(DailyTask task) {
    selectedTask.add(task);
    tasks.add(tasks.value.rebuild((b) => b.map((_task) {
          if (_task.isSelected == true && _task.seq != task.seq) {
            return _task.rebuild((__task) => __task..isSelected = false);
          }
          if (_task.seq == task.seq) {
            return _task.rebuild((__task) => __task..isSelected = true);
          }
          return _task;
        })));
  }

  updataTask(DailyTask task) {
    Env.repository.updateTask(task);
    task = task.rebuild((b) => b.isSelected = true);
    selectedTask.add(task);
    tasks.add(tasks.value.rebuild((b) => b.map((_task) {
          return _task.seq == task.seq ? task : _task;
        })));
  }

  dispose() {
    selectedTask.close();
    tasks.close();
  }
}
