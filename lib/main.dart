import 'package:flutter/material.dart';
import 'dart:math';
import './env.dart';
import './repository/repository_ios.dart';
import './widgets/tasks.dart';
import './widgets/actions.dart';
import './widgets/habits.dart';
import './blocs/bloc_provider.dart';
import './blocs/habits_bloc.dart';
import 'package:flutter/services.dart';

void main() {
  Env.repository = RepositoryIOS();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(App());
  });
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFF111111)),
      child: StreamBuilder<bool>(
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
                final habitsHeight = (totalHeight - tasksHeight).toInt();

                if (habitCount == 0) {
                  // show welcome
                  return CustomScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white),
                          height: totalHeight - habitsHeight,
                          child: Center(
                            child: Text(
                              'WE BECOME \nWHAT WE \nREPEATEDLY DO.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black87,
                                  height: 1.2),
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          child: Habits(habitsHeight),
                        ),
                      )
                    ],
                  );
                } else {
                  return CustomScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    slivers: <Widget>[
                      SliverToBoxAdapter(child: Tasks(context)),
                      // SliverToBoxAdapter(child: Actions(actionsHeight)),
                      SliverToBoxAdapter(
                        child: Habits(habitsHeight),
                      )
                    ],
                  );
                }
              },
            ));
          }),
    );
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
            style: TextStyle(color: Colors.white),
          );
        });
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: HabitsBloc(context),
      child: MaterialApp(
        title: 'Habbit',
        theme: ThemeData(
          backgroundColor: Color(0xFF212121),
          scaffoldBackgroundColor: Color(0xFF212121),
          primaryTextTheme: TextTheme(title: TextStyle(color: Colors.white)),
        ),
        home: Scaffold(
          backgroundColor: Color(0xFF111111),
          appBar: AppBar(
            centerTitle: true,
            brightness: Brightness.dark,
            title: Title(),
            elevation: 0,
            backgroundColor: Color(0xFF212121),
          ),
          body: Body(),
          resizeToAvoidBottomPadding: false,
        ),
      ),
    );
  }
}
