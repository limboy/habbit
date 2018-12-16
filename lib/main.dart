import 'package:flutter/material.dart';
import './widgets/tasks.dart';
import './mock/tasks.dart';

void main() => runApp(MyApp());

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
        body: Tasks(context, quarterTasks),
      ),
    );
  }
}
