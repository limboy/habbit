import 'package:flutter/material.dart';
import 'dart:math';
import './env.dart';
import './repository/repository_ios.dart';
import './widgets/tasks.dart';
import './widgets/actions.dart';
import './widgets/habits.dart';
import './models/habit.dart';
import './mock/tasks.dart';
import './blocs/bloc_provider.dart';
import './blocs/habits_bloc.dart';
import './blocs/tasks_bloc.dart';
import 'package:built_collection/built_collection.dart';

void main() {
  Env.repository = RepositoryIOS();
  runApp(MyApp());
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BuiltList<Habit>>(
        initialData: null,
        stream: BlocProvider.of<HabitsBloc>(context).habits,
        builder: (context, snapshot) {
          final habits = snapshot.data;
          final habitCount = habits == null ? 0 : habits.length;

          return SafeArea(child: LayoutBuilder(
            builder: (context, constraints) {
              final totalHeight = constraints.maxHeight;
              final tasksHeight = MediaQuery.of(context).size.width;
              final habitItemHeight = 56;
              final habitPadding = 16;
              final habitsHeight = (min(habitCount + 1, 6) / 2).ceil() *
                      (habitItemHeight + habitPadding) +
                  habitPadding;
              final actionsHeight = totalHeight - tasksHeight - habitsHeight;

              if (habitCount <= 1) {
                if (habitCount == 0) {
                  // show welcome
                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.yellow),
                          height: totalHeight - habitsHeight,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Habits(habitsHeight),
                      )
                    ],
                  );
                } else {
                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(child: Tasks(context)),
                      SliverToBoxAdapter(child: Actions(actionsHeight)),
                      SliverToBoxAdapter(
                        child: Habits(habitsHeight),
                      )
                    ],
                  );
                }
              }
            },
          ));
        });
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Hello World',
            style: TextStyle(color: Colors.black87),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: BlocProvider(bloc: HabitsBloc(), child: Body()),
        resizeToAvoidBottomPadding: false,
      ),
    );
  }
}
