import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/components/drawer/gf_drawer.dart';
import 'package:getwidget/getwidget.dart';
import 'package:log_book/src/screens/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:log_book/src/screens/Logview.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:log_book/src/services/firebaseServices.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dataBaseRefference = FirebaseDatabase.instance.reference();
  final auth = FirebaseAuth.instance;
  final signedInUser = FirebaseAuth.instance.currentUser;
  final _homeFormKey = GlobalKey<FormState>();
  var dispResult;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final FirebaseServices serviceObject = FirebaseServices();
  var userName;

  signedInUserName() {}
  var pushKey;

  String getDateTime(String data) {
    if (data == 'date'.toLowerCase()) {
      String _date = DateFormat('yy-MM-dd').format(DateTime.now());
      return _date;
    } else if (data == 'time'.toLowerCase()) {
      String _time = DateFormat('kk:mm:ss').format(DateTime.now());
      return _time;
    } else {
      return 'null';
    }
  }

  Future<void> addToDatadb() async {
    final Map<String, dynamic> theData = {
      'name': _nameController.text,
      'job': _jobController.text,
      'Date_created': getDateTime("date"),
      'Time_created': getDateTime('time')
    };
    var pushRef = await dataBaseRefference
        .child('users')
        .child(signedInUser!.uid)
        .child('userTasks')
        .push();

    var addTheData = pushRef.set(theData).asStream();

    pushKey = pushRef.key;
    print(pushKey.toString());
    clearControllers();
  }

  clearControllers() {
    _nameController.clear();
    _jobController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<String>(context);
    return Scaffold(
      appBar: GFAppBar(
        centerTitle: true,
        title: Text('Data Entry'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          GFIconButton(
              type: GFButtonType.transparent,
              onPressed: () {
                serviceObject.signOut();
                Navigator.of(context).pushReplacementNamed('/welcome');
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      drawer: BounceInLeft(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width - 80,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Card(
                  child: Container(
                    height: 220,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/background.jpg'),
                            fit: BoxFit.fill)),
                    child: Container(
                      padding: const EdgeInsets.only(top: 90),
                      color: Colors.blueAccent.withOpacity(0.3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                                text: 'welcome ',
                                style: TextStyle(color: Colors.pinkAccent),
                                children: [
                                  TextSpan(
                                      text: userName,
                                      style: TextStyle(color: Colors.black))
                                ]),
                          ),
                          Text('another')
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 150,
                left: 25,
                right: 25,
                child: Card(
                  elevation: 7,
                  color: Colors.pinkAccent,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('images/bob.gif'),
                  ),
                ),
              ),
              Positioned(
                top: 300,
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        child: ListTile(
                          tileColor: Colors.amber,
                          title: Text(signedInUser!.email.toString()),
                        ),
                      ),
                      ListTile(
                        title: Text('some ugly text'),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purpleAccent, Colors.pinkAccent])),
        child: Form(
          key: _homeFormKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: ListView(children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: _nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'field cannot be empty';
                            } else {
                              return null;
                            }
                          },
                          autofocus: true,
                          decoration: InputDecoration(
                              icon: Icon(Icons.person),
                              filled: true,
                              labelText: 'Name',
                              hintText: 'enter student/staff name',
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.pinkAccent))),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: _jobController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'field cannot be empty';
                              } else {
                                return null;
                              }
                            },
                            autofocus: true,
                            maxLines: 3,
                            decoration: InputDecoration(
                                icon: Icon(Icons.text_fields),
                                hintText: 'enter job of the day',
                                labelText: 'job',
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.pinkAccent)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GFButton(
                            elevation: 3,
                            text: 'save',
                            onPressed: () {
                              if (_homeFormKey.currentState!.validate()) {
                                addToDatadb();
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GFButton(
                          elevation: 3,
                          shape: GFButtonShape.standard,
                          text: 'view Data',
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BounceInRight(child: LogViewPage())));
                          },
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
