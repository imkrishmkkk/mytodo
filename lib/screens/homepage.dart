// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:mytodo/database_helper.dart';
import 'package:mytodo/screens/taskpage.dart';
import 'package:mytodo/widgets.dart';

import '../models/task.dart';

// ignore: use_key_in_widget_constructors
class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // ignore: prefer_final_fields
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Colors.white.withOpacity(0.5),
                Colors.cyanAccent.withOpacity(0.5),
              ])),
          width: double.infinity,
          // ignore: prefer_const_constructors
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // ignore: prefer_const_constructors
                    margin: EdgeInsets.only(
                      top: 32.0,
                      bottom: 32.0,
                    ),
                    child: Image(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                        behavior: NoGlowBehaviour(),
                        child: FutureBuilder(
                          future: _dbHelper.getTasks(Task),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Task>?> snapshot) {
                            return ScrollConfiguration(
                              behavior: NoGlowBehaviour(),
                              child: ListView.builder(
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (context, index) {
                                    
                                    return GestureDetector(
                                      onTap: () {
                                        
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Taskpage(
                                              task: snapshot.data![index],
                                              
                                              
                                            ),
                                          ),
                                        ).then(
                                          (value) {
                                            setState(
                                              () {},
                                            );
                                          },
                                        );
                                      },
                                      child: TaskCardWidget(
                                        title: snapshot.data![index].title ?? " ",
                                        desc: snapshot.data![index].description ?? "no description",
                                      ),
                                    );
                                  }),
                            );
                          },
                        )),
                  )
                ],
              ),
              Positioned(
                right: 0.0,
                bottom: 24.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Taskpage(
                                task: null,
                              )),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20.0)),
                    child:
                        Image(image: AssetImage('assets/images/add_icon.png')),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
