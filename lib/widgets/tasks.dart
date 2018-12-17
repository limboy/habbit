import 'package:flutter/material.dart';
import '../models/dailytask.dart';

const padding = 16.0;
const smallPadding = 8.0;
const weekTasksCount = 7;
const monthTasksCount = 28;
const quarterTasksCount = 84;

class _TaskItem extends StatelessWidget {
  final double itemWidth;
  final DailyTask task;
  _TaskItem(this.itemWidth, this.task);

  @override
  Widget build(BuildContext context) {
    var circleColor = Colors.transparent;
    var text = '${task.seq}';
    var textColor = Colors.white;
    var indicatorColor = Colors.transparent;
    var selectedColor = Colors.transparent;

    if (task.isSelected == true) {
      selectedColor = Colors.blue;
    }

    if (task.isToday == true) {
      circleColor = Colors.black12;
      textColor = Colors.black87;
    }
    if (task.status == DailyTaskStatus.completed) {
      circleColor = Colors.green;
    } else if (task.status == DailyTaskStatus.failed) {
      circleColor = Colors.red;
    }

    if (task.status == DailyTaskStatus.skipped) {
      text = '--';
      textColor = Colors.black54;
    }

    if (task.isFuture == true) {
      textColor = Colors.black54;
      circleColor = Colors.transparent;
    }

    if (task.hasNote == true) {
      indicatorColor = task.status == DailyTaskStatus.skipped
          ? Colors.black54
          : Colors.white;
    }

    return Column(
      children: <Widget>[
        Stack(alignment: Alignment(0, 0.75), children: <Widget>[
          Container(
              width: itemWidth,
              height: itemWidth,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              // border: Border.all(color: circleBorderColor, width: 2)),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(color: textColor, fontSize: 18),
                ),
              )),
          Container(
            width: 4,
            height: 4,
            decoration:
                BoxDecoration(color: indicatorColor, shape: BoxShape.circle),
          )
        ]),
        SizedBox(
          width: itemWidth,
          height: padding,
          child: Center(
            child: Container(
              width: 10,
              height: 4,
              decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.all(Radius.circular(2.0))),
            ),
          ),
        )
      ],
    );
  }
}

class _ListTaskItem extends StatelessWidget {
  final DailyTask task;
  final double itemWidth;

  _ListTaskItem(this.itemWidth, this.task);

  @override
  Widget build(BuildContext context) {
    var circleColor = Colors.transparent;
    var text = '';
    var textColor = Colors.black54;
    var indicatorColor = Colors.transparent;
    var selectedColor = Colors.transparent;

    if (task.isSelected == true) {
      selectedColor = Colors.blue;
    }

    if (task.isToday == true) {
      circleColor = Colors.black12;
    }

    if (task.status == DailyTaskStatus.completed) {
      circleColor = Colors.green;
    } else if (task.status == DailyTaskStatus.failed) {
      circleColor = Colors.red;
    }

    if (task.status == DailyTaskStatus.skipped && task.hasNote != true) {
      text = '-';
    }

    if (task.isFuture == true) {
      circleColor = Colors.transparent;
      text = '${task.seq}';
    }

    if (task.hasNote == true) {
      indicatorColor = task.status == DailyTaskStatus.skipped
          ? Colors.black54
          : Colors.white;
    }

    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: itemWidth,
                height: itemWidth,
                decoration:
                    BoxDecoration(color: circleColor, shape: BoxShape.circle),
              ),
              Text(
                text,
                style: TextStyle(color: textColor),
              ),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                    color: indicatorColor, shape: BoxShape.circle),
              )
            ],
          ),
          Container(
            width: smallPadding,
            height: smallPadding,
            child: Center(
              child: Container(
                width: 4,
                height: 4,
                decoration:
                    BoxDecoration(color: selectedColor, shape: BoxShape.circle),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ListTask extends StatelessWidget {
  final List<DailyTask> tasks;
  final double itemWidth;

  _ListTask(this.itemWidth, this.tasks);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tasks.map((task) {
        return Container(
          width: itemWidth + smallPadding,
          height: itemWidth + smallPadding,
          child: _ListTaskItem(itemWidth, task),
        );
      }).toList(),
    );
  }
}

class Tasks extends StatelessWidget {
  final BuildContext context;
  final List<DailyTask> tasks;

  Tasks(this.context, this.tasks);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bigItemWidth =
        (screenWidth - padding * (weekTasksCount + 1)) / weekTasksCount;
    final smallItemColumns = quarterTasksCount / weekTasksCount;
    final smallItemWidth =
        (screenWidth - smallPadding * (smallItemColumns + 1)) /
            (smallItemColumns);
    final rows = tasks.length / 7;

    if (tasks.length <= monthTasksCount) {
      return Container(
          height: (bigItemWidth + padding) * rows + padding + 1,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(width: 0.5, color: Colors.black26))),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(padding / 2),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return _TaskItem(bigItemWidth, tasks[index]);
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
          ));
    } else {
      return Container(
        height:
            (smallItemWidth + smallPadding) * weekTasksCount + smallPadding + 1,
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 0.5, color: Colors.black26))),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(left: smallPadding, top: smallPadding),
          itemCount: tasks.length ~/ weekTasksCount,
          itemExtent: smallItemWidth + smallPadding,
          itemBuilder: (context, index) {
            final subTasks = tasks
                .take((index + 1) * weekTasksCount)
                .skip(index * weekTasksCount)
                .toList();
            return _ListTask(smallItemWidth, subTasks);
          },
        ),
      );
    }
  }
}
