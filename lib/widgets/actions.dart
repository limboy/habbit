import 'package:flutter/material.dart';
import '../models/dailytask.dart';
import '../blocs/bloc_provider.dart';
import '../blocs/tasks_bloc.dart';
import '../blocs/habits_bloc.dart';

class Actions extends StatelessWidget {
  final double height;
  Actions(this.height);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HabitsBloc>(context).tasksBloc;
    return StreamBuilder(
      initialData: null,
      stream: bloc.selectedTask,
      builder: (context, snapshot) {
        final task = snapshot.data;
        if (task == null) {
          return Container();
        }

        final screenWidth = MediaQuery.of(context).size.width;
        final mainButtonWidth = screenWidth / 3.67;
        final buttonWidth = mainButtonWidth * 2 / 3;
        return Container(
          height: height,
          padding: EdgeInsets.only(bottom: (height - mainButtonWidth - 30) / 2),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: buttonWidth,
                  // decoration: BoxDecoration(color: Colors.yellow),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: buttonWidth,
                        height: buttonWidth,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(width: 2, color: Colors.black87)),
                        child: Icon(
                          Icons.close,
                          size: buttonWidth * 0.5,
                          color: Colors.black87,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Text(
                        'failed',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: mainButtonWidth,
                  // decoration: BoxDecoration(color: Colors.red),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: mainButtonWidth,
                          height: mainButtonWidth,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 2, color: Colors.black87)),
                          child: Icon(
                            Icons.done,
                            size: mainButtonWidth * 0.5,
                            color: Colors.black87,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Text(
                          'completed',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ]),
                ),
                Container(
                  width: buttonWidth,
                  // decoration: BoxDecoration(color: Colors.blue),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: buttonWidth,
                          height: buttonWidth,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 2, color: Colors.black87)),
                          child: Icon(
                            Icons.skip_next,
                            size: buttonWidth * 0.5,
                            color: Colors.black87,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Text(
                          'skip',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
