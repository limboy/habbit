import 'package:flutter/material.dart';
import 'package:built_collection/built_collection.dart';
import 'dart:math';
import '../models/habit.dart';
import '../blocs/bloc_provider.dart';
import '../blocs/habits_bloc.dart';

const maxHabitCount = 6;

class _Habit extends StatelessWidget {
  final Habit habit;
  final double itemWidth;
  final bool isSelected;
  final Function onSelectMore;

  _Habit(this.itemWidth, this.habit, this.onSelectMore,
      {this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HabitsBloc>(context);
    return GestureDetector(
      onTap: () {
        bloc.selectHabit(habit, context);
      },
      child: Container(
        width: itemWidth,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: isSelected == true ? Colors.black12 : Colors.transparent,
            border: Border.all(
              color: Colors.black87,
              width: 2,
            )),
        padding: EdgeInsets.only(top: 3, left: 5, right: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 4),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  habit.title,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Container(
              height: 23,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    habit.createdString,
                    style: TextStyle(fontSize: 12, color: Colors.black38),
                  ),
                  GestureDetector(
                      onTap: () {
                        onSelectMore();
                      },
                      child: Icon(
                        Icons.more_horiz,
                        size: 20,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddHabit extends StatelessWidget {
  final double itemWidth;
  final Function tapHandler;

  _AddHabit(this.itemWidth, this.tapHandler);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.tapHandler();
      },
      child: Container(
        width: itemWidth,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(
          color: Colors.black87,
          width: 2,
        )),
        padding: EdgeInsets.all(8),
        child: Center(
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class Habits extends StatelessWidget {
  final titleController = TextEditingController();
  final int height;

  Habits(this.height);

  Future<Habit> _showModifyHaibtDialog(
      BuildContext context, Habit habit) async {
    titleController.text = habit.title;

    final bloc = BlocProvider.of<HabitsBloc>(context);

    return await showDialog<Habit>(
        context: context,
        builder: (context) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(16.0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    autofocus: true,
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.black12,
                      filled: true,
                      hasFloatingPlaceholder: false,
                      hintText: "New Habit",
                      contentPadding: EdgeInsets.all(8),
                    ),
                    controller: titleController,
                    onSubmitted: ((value) {
                      Navigator.pop(
                          context,
                          habit.rebuild((b) => b
                            ..title = value
                            ..created = DateTime.now().microsecondsSinceEpoch));
                    }),
                  ),
                  () {
                    if (habit.title == null || habit.title.length == 0) {
                      return Container();
                    } else {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 7),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: GestureDetector(
                                      onTap: () {
                                        bloc.deleteHabit(habit, context);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'delete',
                                        style: TextStyle(color: Colors.red),
                                      )),
                                ),
                                Container(
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'cancel',
                                        style: TextStyle(color: Colors.black54),
                                      )),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }
                  }()
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HabitsBloc>(context);
    final habitWidth = (MediaQuery.of(context).size.width - 16 * 3) / 2;
    final aspect = habitWidth / (56.0 + 8);

    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          // color: Colors.yellow,
          border: Border(top: BorderSide(color: Colors.black45, width: 0.5))),
      height: height.toDouble(),
      child: StreamBuilder<BuiltList<Habit>>(
        initialData: BuiltList(),
        stream: bloc.habits,
        builder: (context, snapshot) {
          final habits = snapshot.data;
          return GridView.builder(
            itemCount:
                habits != null ? min(habits.length + 1, maxHabitCount) : 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: aspect,
            ),
            itemBuilder: (context, index) {
              if (index < habits.length || habits.length == maxHabitCount) {
                return _Habit(habitWidth, habits[index], () async {
                  final updatedHabit =
                      await _showModifyHaibtDialog(context, habits[index]);
                  if (updatedHabit != null && updatedHabit.title != '') {
                    bloc.updateHabit(updatedHabit);
                  }
                }, isSelected: habits[index].isSelected);
              } else {
                return _AddHabit(habitWidth, () async {
                  final habit = Habit((b) => b
                    ..title = ''
                    ..created = DateTime.now().microsecondsSinceEpoch);
                  final newHabit = await _showModifyHaibtDialog(context, habit);
                  if (newHabit != null && newHabit.title != '') {
                    bloc.addHabit(newHabit, context);
                  }
                });
              }
            },
          );
        },
      ),
    );
  }
}
