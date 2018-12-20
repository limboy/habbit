import 'package:flutter/material.dart';
import 'dart:math';
import '../models/dailytask.dart';
import '../blocs/bloc_provider.dart';
import '../blocs/tasks_bloc.dart';
import '../blocs/habits_bloc.dart';
import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

const padding = 16.0;
const threeTasksCount = 3;
const weekTasksCount = 9;
const monthTasksCount = 25;
const quarterTasksCount = 81;

class _TaskItem extends StatelessWidget {
  final double itemWidth;
  final DailyTask task;
  var showPassedSeq;
  _TaskItem(this.itemWidth, this.task, {this.showPassedSeq: true});

  @override
  Widget build(BuildContext context) {
    var circleColor = Colors.black12;
    var text = '${task.seq}';
    var textColor = Colors.white;

    if (task.isSelected == true) {
      textColor = Colors.black87;
    }

    if (task.isToday == true) {
      textColor = Colors.blue;
    }

    if (task.status != null && !showPassedSeq) {
      text = '';
    }

    switch (task.status) {
      case DailyTaskStatus.completed:
        circleColor = Colors.green;
        break;
      case DailyTaskStatus.failed:
        circleColor = Colors.green;
        break;
      case DailyTaskStatus.skipped:
        if (showPassedSeq) {
          text = '-';
        }
    }

    if (task.isFuture == true) {
      textColor = Colors.black38;
      circleColor = Colors.black12;
    }

    return Container(
        width: itemWidth,
        height: itemWidth,
        margin: EdgeInsets.all(padding / 2),
        decoration: BoxDecoration(
          color: circleColor,
          shape: BoxShape.circle,
        ),
        // border: Border.all(color: circleBorderColor, width: 2)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: itemWidth / 2.5),
          ),
        ));
  }
}

class Tasks extends StatelessWidget {
  final BuildContext context;

  Tasks(this.context);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HabitsBloc>(context).tasksBloc;
    return StreamBuilder<BuiltList<DailyTask>>(
        initialData: null,
        stream: bloc.tasks,
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

          bool showPassedSeq = sqrt(quarterTasksCount).toInt() != columnCount;

          return Container(
              height: height,
              width: screenWidth,
              padding: EdgeInsets.only(
                  left: padding / 2,
                  top: padding / 2 + extraPaddingTop,
                  right: padding / 2,
                  bottom: padding / 2),
              decoration: BoxDecoration(
                  // color: Colors.yellow,
                  border: Border(
                      bottom: BorderSide(width: 0.5, color: Colors.black26))),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return _TaskItem(
                    itemWidth,
                    tasks[index],
                    showPassedSeq: showPassedSeq,
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                ),
              ));
        });
  }
}
