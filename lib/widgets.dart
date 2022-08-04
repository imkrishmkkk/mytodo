// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, duplicate_ignore, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  //const TaskCardWidget({Key? key}) : super(key: key);
  final String? title;
  final String? desc;

  // ignore: use_key_in_widget_constructors
  TaskCardWidget({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        // ignore: prefer_const_constructors
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 32.0,
        ),
        // ignore: prefer_const_constructors
        margin: EdgeInsets.only(
          bottom: 20.0,
        ),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? "(Unnamed Task)",
              // ignore: prefer_const_constructors
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              // ignore: prefer_const_constructors
              padding: EdgeInsets.only(
                top: 10.0,
              ),
              child: Text(
                desc ?? 'No description added',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xff868290),
                  height: 1.5,
                ),
              ),
            )
          ],
        ));
  }
}

class TodoWidget extends StatelessWidget {
  final String? text;
  final bool isDone;

  TodoWidget({this.text,required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Container(
            width: 20.0,
            height: 20.0,
            margin: EdgeInsets.only(
              right: 12.0,
            ),
            decoration: BoxDecoration(
              border: isDone ? null : Border.all(
                color: Color(0xff86829D),
                width: 1.5,
              ),
              color: isDone ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(6.0),
            ),
            
            child: Image(
              image: AssetImage('assets/images/check_icon.png'),
              color: Colors.white,
            ),
          ),
          Flexible(
            child: Text(
              text ?? '(Unnamed todo)',
            style: TextStyle(
              color: isDone ? Color(0xff211551) : Color(0xff86829D),
              fontSize: 16.0,
              fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
            ) ,
            ),
          ),
        ],
      ),
    );
  }
}

class NoGlowBehaviour extends ScrollBehavior{
  @override
  // ignore: override_on_non_overriding_member
  Widget buildviewportChorme(
      BuildContext context, Widget child ,AxisDirection axisDirection){
    return child;
  }

}
