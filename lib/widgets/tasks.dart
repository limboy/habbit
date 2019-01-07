import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:math';
import '../models/dailytask.dart';
import '../blocs/bloc_provider.dart';
import '../blocs/tasks_bloc.dart';
import '../blocs/habits_bloc.dart';
import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

const padding = 16.0;
const threeTasksCount = 3;
const weekTasksCount = 9;
const monthTasksCount = 25;
const quarterTasksCount = 81;

class _TaskItem extends StatefulWidget {
  final double itemWidth;
  final DailyTask task;

  _TaskItem(this.itemWidth, this.task);

  @override
  State<StatefulWidget> createState() {
    return _TaskItemState();
  }
}

class _TaskItemState extends State<_TaskItem>
    with SingleTickerProviderStateMixin {
  double widthRatio = 1.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final itemWidth = widget.itemWidth;

    final bloc = BlocProvider.of<HabitsBloc>(context).tasksBloc;
    var circleColor = Color(0xFFFFDD835);
    var text = '${task.seq}';
    var textColor = Colors.white;
    var borderColor = Colors.transparent;
    final completedIcon = Icon(
      Icons.done,
      color: Colors.white,
      size: itemWidth / 2,
    );
    final failedIcon = Icon(
      Icons.close,
      color: Colors.white,
      size: itemWidth / 2,
    );
    var icon;

    switch (task.status) {
      case DailyTaskStatus.completed:
        circleColor = Colors.green;
        icon = completedIcon;
        break;
      case DailyTaskStatus.failed:
        circleColor = Colors.red;
        icon = failedIcon;
        break;
      case DailyTaskStatus.skipped:
        circleColor = Colors.black38;
        text = '-';
    }

    if (task.isSelected == true) {
      if (task.status == null) {
        textColor = Colors.white;
        // circleColor = Colors.black12;
      }
      borderColor = Colors.black54;
    }

    if (task.isToday == true) {
      textColor = Colors.black;
      if (task.status == null) {
        circleColor = Colors.black12;
      }
    }

    if (task.isFuture == true) {
      textColor = Colors.black26;
      circleColor = Colors.black12;
    }

    return GestureDetector(
      onTapUp: (event) {
        if (task.isToday == true) {
          bloc.selectTask(task);
          this.setState(() {
            widthRatio = 1.0;
          });
        }
      },
      onTapCancel: () {
        if (task.isToday == true) {
          this.setState(() {
            widthRatio = 1.0;
          });
        }
      },
      onTapDown: (event) {
        if (task.isToday == true) {
          this.setState(() {
            widthRatio = 1.5;
          });
        }
      },
      child: Container(
          margin: EdgeInsets.all(padding / 2 * widthRatio),
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
            border: Border.all(
                color: borderColor,
                width: max((itemWidth ~/ 25).toDouble(), 2.0)),
          ),
          child: Center(
            child: () {
              if (icon == null) {
                return Text(
                  text,
                  style: TextStyle(color: textColor, fontSize: itemWidth / 2.5),
                );
              } else {
                return icon;
              }
            }(),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class Tasks extends StatelessWidget {
  final BuildContext context;

  Tasks(this.context);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HabitsBloc>(context).tasksBloc;
    return StreamBuilder<BuiltList<DailyTask>>(
        initialData: bloc.tasks.value,
        stream: bloc.tasks.stream,
        builder: (context, snapshot) {
          final tasks = snapshot.data;
          if (tasks == null) {
            return Container();
          }

          var columnCount = threeTasksCount;
          switch (tasks.length) {
            case weekTasksCount:
              columnCount = sqrt(weekTasksCount).toInt();
              break;
            case monthTasksCount:
              columnCount = sqrt(monthTasksCount).toInt();
              break;
            case quarterTasksCount:
              columnCount = sqrt(quarterTasksCount).toInt();
          }
          final screenWidth = MediaQuery.of(context).size.width;
          final height = screenWidth;
          final itemWidth =
              ((height - padding * 2) - (columnCount - 1) * padding) /
                  columnCount;
          var extraPaddingTop = 0.0;
          if (tasks.length == threeTasksCount) {
            extraPaddingTop = (height - padding * 2 - itemWidth) / 2;
          }

          return Container(
              height: height,
              width: screenWidth,
              padding: EdgeInsets.only(
                  left: padding / 2,
                  top: padding / 2 + extraPaddingTop,
                  right: padding / 2,
                  bottom: padding / 2),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(width: 0.5, color: Colors.black26))),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return _TaskItem(
                    itemWidth,
                    tasks[index],
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                ),
              ));
        });
  }
}
