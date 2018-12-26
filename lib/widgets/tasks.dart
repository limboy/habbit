import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
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

class _TaskItem extends StatefulWidget {
  final double itemWidth;
  final DailyTask task;
  final showPassedSeq;

  _TaskItem(this.itemWidth, this.task, {this.showPassedSeq: true});

  @override
  State<StatefulWidget> createState() {
    return _TaskItemState();
  }
}

class _TaskItemState extends State<_TaskItem>
    with SingleTickerProviderStateMixin {
  Animation<Color> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _setupAnimation();
  }

  @override
  didUpdateWidget(_TaskItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.task.isSelected == true) {
      _setupAnimation();
      controller
        ..reset()
        ..forward();
    }
  }

  _setupAnimation() {
    var toColor = Colors.black12;
    if (widget.task.status != null) {
      switch (widget.task.status) {
        case DailyTaskStatus.completed:
          toColor = Colors.green;
          break;
        case DailyTaskStatus.failed:
          toColor = Colors.red;
          break;
        case DailyTaskStatus.skipped:
          toColor = Colors.black38;
      }
    }
    animation = ColorTween(end: toColor).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final itemWidth = widget.itemWidth;
    final showPassedSeq = widget.showPassedSeq;

    final bloc = BlocProvider.of<HabitsBloc>(context).tasksBloc;
    var circleColor = Colors.black12;
    var text = '${task.seq}';
    var textColor = Colors.white;
    var borderColor = Colors.transparent;

    if (task.isToday == true) {
      textColor = Colors.black;
    }

    if (task.status != null && !showPassedSeq) {
      text = '';
    }

    switch (task.status) {
      case DailyTaskStatus.completed:
        circleColor = Colors.green;
        break;
      case DailyTaskStatus.failed:
        circleColor = Colors.red;
        break;
      case DailyTaskStatus.skipped:
        circleColor = Colors.black38;
        if (showPassedSeq) {
          text = '-';
        }
    }

    if (task.isSelected == true) {
      if (task.status == null) {
        textColor = Colors.white;
        circleColor = Colors.black12;
      }
      borderColor = Colors.black54;
    }

    if (task.isFuture == true) {
      textColor = Colors.black26;
      circleColor = Colors.black12;
    }

    return GestureDetector(
      onTap: () {
        if (task.isFuture != true) {
          bloc.selectTask(task);
        }
      },
      child: Container(
          width: itemWidth,
          height: itemWidth,
          margin: EdgeInsets.all(padding / 2),
          decoration: BoxDecoration(
            color:
                widget.task.isSelected == true ? animation.value : circleColor,
            shape: BoxShape.circle,
            border: Border.all(
                color: borderColor,
                width: max((itemWidth ~/ 25).toDouble(), 2.0)),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: itemWidth / 2.5),
            ),
          )),
    );
  }

  @override
  void dispose() {
    controller.dispose();
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
