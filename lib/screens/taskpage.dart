// ignore_for_file: prefer_const_constructors, duplicate_ignore, avoid_single_cascade_in_expression_statements

import 'package:flutter/material.dart';
import 'package:mytodo/database_helper.dart';
import 'package:mytodo/models/task.dart';
import 'package:mytodo/widgets.dart';

import '../models/todo.dart';

class Taskpage extends StatefulWidget {
    final Task? task ;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  Taskpage({this.task});

  @override
  State<Taskpage> createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  int _taskId = 0;
  String? _taskTitle = "";
  String? _taskDescription = "";

  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    if (widget.task != null) {
      //set the visibility true
       _contentVisible = true;

      _taskTitle = widget.task?.title;
      _taskDescription = widget.task?.description;
      _taskId = widget.task!.id!;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // ignore: avoid_unnecessary_containers
        child: Stack(
          children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 24.0,
                bottom: 6.0,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image(
                        image:
                            AssetImage('assets/images/back_arrow_icon.png'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      focusNode: _titleFocus,
                      onSubmitted: (value) async {
                        //check if the field is not empty
                        if (value != "") {
                          //check if task is null
                          if (widget.task == null) {
                            // ignore: no_leading_underscores_for_local_identifiers
        
                            // ignore: no_leading_underscores_for_local_identifiers
                            Task _newTask = Task(title: value);
                            _taskId = await _dbHelper.insertTask(_newTask);
                            setState(() {
                              _contentVisible = true;
                              _taskTitle = value;
                            });
                          } else {
                            _dbHelper.updateTaskTitle(_taskId, value);
        
                          }
                          _descriptionFocus.requestFocus();
                        }
                      },
                      controller: TextEditingController()
                        ..text = _taskTitle ?? " ",
        
                      // ignore: unused_label
                      decoration: InputDecoration(
                        hintText: 'Enter Task Title',
                        border: InputBorder.none,
                      ),
        
                      // ignore: unused_label
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff211551),
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            Visibility(
              visible: _contentVisible,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 12.0,
                ),
                child: TextField(
                  focusNode: _descriptionFocus,
                  onSubmitted: (value) async {
                    if (value != "") {
                      if (_taskId != 0) {
                       await _dbHelper.updateTaskDescription(_taskId, value);
                       _taskDescription = value;
                      }
                    }
                    _todoFocus.requestFocus();
                  },
                  controller: TextEditingController()..text = _taskDescription ?? "No Description",
                  //keyboardType: TextInputType.multiline,
                  //maxLines: null,
                  decoration: InputDecoration(
                      hintText: 'Enter description for task',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                      )),
                ),
              ),
            ),
            Visibility(
              visible: _contentVisible,
              child: FutureBuilder(
                future: _dbHelper.getTodo(_taskId),
                builder: (context, AsyncSnapshot<List<Todo>> snapshot) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            if(snapshot.data![index].isDone == 0){
                              await _dbHelper.updateTodoDone(snapshot.data![index].id, 1);
                            } else{
                              await _dbHelper.updateTodoDone(snapshot.data![index].id, 0);
                            }
                            setState(() {});
                          },
                          child: TodoWidget(
                            text: snapshot.data![index].title,
                            isDone: snapshot.data![index].isDone == 0 ? false : true,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: _contentVisible,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
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
                        border: Border.all(
                          color: Color(0xff86829D),
                          width: 1.5,
                        ),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Image(
                        image: AssetImage('assets/images/check_icon.png'),
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: _todoFocus,
                        controller: TextEditingController()..text = "",
                        onSubmitted: (value) async {
                          if (value != "") {
                            //check if task is null
                            if (_taskId != 0) {
                              // ignore: no_leading_underscores_for_local_identifiers
                              DatabaseHelper _dbHelper = DatabaseHelper();
        
                              // ignore: no_leading_underscores_for_local_identifiers
                              Todo _newTodo = Todo(
                                title: value,
                                isDone: 0,
                                taskId: _taskId,
                              );
                              await _dbHelper.insertTodo(_newTodo);
                              setState(() {});
                              _todoFocus.requestFocus();
        
                            } else {
                              print("task doesn't exist");
                            }
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter todo item',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        Visibility(
          visible: _contentVisible,
          child: Positioned(
            right: 24.0,
            bottom: 24.0,
            child: GestureDetector(
              onTap: () async {
                if(_taskId != 0){
                  await _dbHelper.deleteTask(_taskId);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
        
              },
              child: Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(20.0)),
                child: Image(
                    image: AssetImage('assets/images/delete_icon.png')),
              ),
            ),
          ),
        )
          ],
        ),
      ),
    );
  }
}
