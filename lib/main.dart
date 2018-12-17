import 'package:flutter/material.dart';
import './env.dart';
import './repository/repository_ios.dart';
import './widgets/tasks.dart';
import './widgets/note.dart';
import './widgets/actions.dart';
import './widgets/habits.dart';
import './models/habit.dart';
import './mock/tasks.dart';

void main() {
  Env.repository = RepositoryIOS();
  runApp(MyApp());
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
        appBar: AppBar(
          title: Text(
            'Hello World',
            style: TextStyle(color: Colors.black87),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: <Widget>[
            Tasks(context, quarterTasks),
            Note('Hello Baby'),
            Actions(null),
            Habits([
              Habit((b) => b
                ..iconName = 'videogame_asset'
                ..title = '每天玩游戏的时间不超过 2 小时')
            ]),
          ],
        ),
      ),
    );
  }
}
