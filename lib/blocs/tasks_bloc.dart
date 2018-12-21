import 'package:rxdart/rxdart.dart';
import '../models/dailytask.dart';
import '../mock/tasks.dart';
import '../blocs/bloc_base.dart';
import 'package:built_collection/built_collection.dart';

class TasksBloc extends BlocBase {
  final selectedTask = BehaviorSubject<DailyTask>();
  final tasks = BehaviorSubject<BuiltList<DailyTask>>();

  selectHabit(int habitID) {
    tasks.add(BuiltList(quarterTasks));
    selectedTask
        .add(quarterTasks.where((task) => task.isSelected == true).first);
  }

  dispose() {
    selectedTask.close();
    tasks.close();
  }
}
