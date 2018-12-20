import 'package:rxdart/rxdart.dart';
import '../models/dailytask.dart';
import '../mock/tasks.dart';
import '../blocs/bloc_base.dart';
import 'package:built_collection/built_collection.dart';

class TasksBloc extends BlocBase {
  final _selectedTask = BehaviorSubject<DailyTask>();
  final _tasks = BehaviorSubject<BuiltList<DailyTask>>();

  Stream<DailyTask> get selectedTask {
    return _selectedTask.stream;
  }

  Stream<BuiltList<DailyTask>> get tasks {
    return _tasks.stream;
  }

  selectHabit(int habitID) {
    _tasks.add(BuiltList(quarterTasks));
    _selectedTask
        .add(quarterTasks.where((task) => task.isSelected == true).first);
  }

  dispose() {
    _selectedTask.close();
    _tasks.close();
  }
}
