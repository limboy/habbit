import 'package:flutter/material.dart';

const padding = 15.0;

class Note extends StatelessWidget {
  final String note;
  final textController = TextEditingController();
  Note(this.note);

  @override
  Widget build(BuildContext context) {
    textController.text = this.note ?? "";
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.5, color: Colors.black38))),
            padding: EdgeInsets.all(padding),
            child: TextField(
              enabled: false,
              maxLines: 999,
              controller: textController,
              decoration: InputDecoration(
                  border: InputBorder.none, contentPadding: EdgeInsets.all(0)),
              style: TextStyle(color: Colors.black38, fontSize: 16),
            ),
          ),
          (() {
            if (this.note == null || this.note.length == 0) {
              return Text(
                'Add a Note',
                style: TextStyle(color: Colors.black38),
              );
            } else {
              return Text('');
            }
          }())
        ],
      ),
    );
  }
}
