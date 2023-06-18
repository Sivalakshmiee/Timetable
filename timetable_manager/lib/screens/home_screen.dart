import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/task.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ignore: prefer_typing_uninitialized_variables
  var _taskController;
  late List<Task> _tasks;
  late List<bool> _taskDone;

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Task t = Task.fromString(_taskController.text);
    String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks!);
    print(list);
    list.add(json.encode(t.getMap()));
    print(list);
    prefs.setString('task', json.encode(list));
    _taskController.text = '';
    Navigator.of(context).pop();

     _getTasks();
    
  }

void _getTasks() async {
  _tasks = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);
    for (dynamic d in list) {
      _tasks.add(Task.fromMap(json.decode(d)));
    }

    print(_tasks);

    _taskDone = List.generate(_tasks.length, (index) => false);
    setState(() {});
}

void updatePendingTasksList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Task> pendingList = [];
    for (var i=0; i< _tasks.length; i++) {
      if(!_taskDone[i]) pendingList.add(_tasks[i]);
    }

    // ignore: unused_local_variable
    var pendingListEncoded = List.generate(
      pendingList.length, (i) => json.encode(pendingList[i].getMap()));

    prefs.setString('task', json.encode(pendingListEncoded));

    _getTasks();

  }

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();

    _getTasks();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule', 
          style: GoogleFonts.montserrat(),
      ),
      actions: [
        IconButton(
          icon:  Icon(Icons.save),
        onPressed: updatePendingTasksList,
        ),
        IconButton(
          icon:  Icon(Icons.delete),
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('task', json.encode([]));

          _getTasks();
        },
        ),
      ],
      ),
      body: (_tasks == null) ? Center(
        child: const Text('No period added yet!'),
      ) : Column(
        children: _tasks.map((e) => Container(
          height: 70.0, 
          width: MediaQuery.of(context).size.width, 
          margin: const EdgeInsets.symmetric(
            horizontal: 10.0, 
            vertical: 5.0),
          padding: const EdgeInsets.only(left: 10.0,),
         alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.black, 
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(
              e.task, 
              style: GoogleFonts.montserrat(),
              ),
              Checkbox(
                value: _taskDone[_tasks.indexOf(e)], 
                key: GlobalKey(), onChanged: (val) { 
                setState(() {
                  _taskDone[_tasks.indexOf(e)] = val!;
                });
               },
               ),
            ],
            ),
        )).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        onPressed: () => showModalBottomSheet(context: context, 
        builder: (BuildContext context) => Container(
          padding: const EdgeInsets.all(10.0),
          height: 500,
          color: Colors.blue[200],
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add schedule', 
                style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 20.0,
            ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              // ignore: prefer_const_constructors
              child: Icon(Icons.close),
            ),
            ],
          ),
          const Divider(thickness: 1.2),
          const SizedBox(height: 20.0,),
          TextField(
            controller: _taskController,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(color: Colors.blue),
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: 'Enter scheduled work',
              hintStyle: GoogleFonts.montserrat(),
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            width: MediaQuery.of(context).size.width,
          //  height: 200.0,
            child: Row(
            children: [
              Container(
                width: (MediaQuery.of(context).size.width/2) - 20,
              child: ElevatedButton(
                child: Text('RESET',
                style: GoogleFonts.montserrat(),
                ),
                onPressed: () => _taskController.text = '',
              ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width/2) - 20,
                child: ElevatedButton(
                  //color: Colors.blue,
                child: Text('ADD',
                style: GoogleFonts.montserrat(),
                ),
                onPressed: () => saveData(),
              ),
              ),
              
            

            ],
          ),
          ),
            ],
        )
        ),
        ),


    )
    );
  }
}