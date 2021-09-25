import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:log_book/src/screens/Logview.dart';

class EditUserPage extends StatefulWidget {
  String userKey;
  EditUserPage({required this.userKey});
  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final auth = FirebaseAuth.instance;

  final dbRef = FirebaseDatabase.instance.reference().child('users');

  getData() async {
    final signedInUser = auth.currentUser;
    DataSnapshot snapshot = await dbRef
        .child(signedInUser!.uid)
        .child('userTasks')
        .child(widget.userKey)
        .once();

    Map result = snapshot.value;
    _nameController.text = result['name'];
    _jobController.text = result['job'];
  }

  void updateData() {
    Map<String, dynamic> theData = {
      'name': _nameController,
      'job': _jobController
    };
    final signedInUser = auth.currentUser;
    dbRef
        .child(signedInUser!.uid)
        .child('userTasks')
        .child(widget.userKey)
        .update(theData)
        .then((value) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LogViewPage()));
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            GFIconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LogViewPage()));
                }),
            Text(widget.userKey),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'enter name'),
            ),
            TextFormField(
              controller: _jobController,
              decoration: InputDecoration(labelText: 'enter job'),
            ),
            GFButton(
              text: 'submit',
              onPressed: () {
                updateData();
              },
            ),
          ],
        ),
      ),
    );
  }
}
