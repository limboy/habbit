import 'package:flutter/material.dart';
import '../models/daliytask.dart';

class Actions extends StatelessWidget {
  final DailyTaskStatus selectedStatus;
  Actions(this.selectedStatus);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final mainButtonWidth = screenWidth / 3.67;
    final buttonWidth = mainButtonWidth * 2 / 3;
    final padding = (screenWidth - mainButtonWidth - buttonWidth * 2) / 4;
    final verticalPadding = padding / 2;
    final height = mainButtonWidth / 0.6;
    return Container(
      height: height,
      padding:
          EdgeInsets.symmetric(vertical: verticalPadding, horizontal: padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            width: (padding + buttonWidth),
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
                      border: Border.all(width: 2, color: Colors.black87)),
                  child: Icon(
                    Icons.close,
                    size: buttonWidth * 0.5,
                    color: Colors.black87,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: verticalPadding - 5),
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
                        border: Border.all(width: 2, color: Colors.black87)),
                    child: Icon(
                      Icons.done,
                      size: mainButtonWidth * 0.5,
                      color: Colors.black87,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: verticalPadding - 5),
                  ),
                  Text(
                    'completed',
                    style: TextStyle(color: Colors.black54),
                  ),
                ]),
          ),
          Container(
            width: (padding + buttonWidth),
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
                        border: Border.all(width: 2, color: Colors.black87)),
                    child: Icon(
                      Icons.skip_next,
                      size: buttonWidth * 0.5,
                      color: Colors.black87,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: verticalPadding - 5),
                  ),
                  Text(
                    'skip',
                    style: TextStyle(color: Colors.black54),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
