import 'package:rxdart/rxdart.dart';
import '../models/dailytask.dart';
import '../mock/tasks.dart';
import '../blocs/bloc_base.dart';
import 'package:built_collection/built_collection.dart';

class TasksBloc extends BlocBase {
  final selectedTask = BehaviorSubject<DailyTask>();
  final tasks = BehaviorSubject<BuiltList<DailyTask>>();

  selectHabit(int habitID) {
    tasks.add(BuiltList(weekTasks));
    selectedTask.add(weekTasks.where((task) => task.isSelected == true).first);
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
