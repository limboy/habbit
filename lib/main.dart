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
  runApp(App());
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        initialData: false,
        stream: BlocProvider.of<HabitsBloc>(context).hasLoaded,
        builder: (context, snapshot) {
          final loaded = snapshot.data;
          if (loaded != true) {
            return Container();
          }

          final bloc = BlocProvider.of<HabitsBloc>(context);
          final habits = bloc.habits.value;

          final int habitCount = habits == null ? 0 : habits.length;

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

              print('habitCount:$habitCount');

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
                      child: Container(child: Habits(habitsHeight)),
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
            },
          ));
        });
  }
}

class ProviderWrapper extends StatelessWidget {
  final Widget child;
  ProviderWrapper(this.child);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: HabitsBloc(context),
      child: child,
    );
  }
}

class Title extends StatelessWidget {
  Title();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        initialData: false,
        stream: BlocProvider.of<HabitsBloc>(context).hasLoaded,
        builder: (context, snapshot) {
          final loaded = snapshot.data;
          if (loaded != true) {
            return Text('');
          }

          final bloc = BlocProvider.of<HabitsBloc>(context);
          final habits = bloc.habits.value;
          var title = 'Habbit';
          if (habits.length > 0) {
            final habit =
                habits.firstWhere((_habit) => _habit.isSelected == true);
            if (habit != null) {
              title = habit.title;
            }
          }
          return Text(
            title,
            style: TextStyle(color: Colors.black87),
          );
        });
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habbit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProviderWrapper(
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Title(),
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          body: Body(),
          resizeToAvoidBottomPadding: false,
        ),
      ),
    );
  }
}
