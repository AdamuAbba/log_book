import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:log_book/src/screens/Home.dart';
import 'package:log_book/src/screens/edituser.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class LogViewPage extends StatefulWidget {
  @override
  _LogViewPageState createState() => _LogViewPageState();
}

class _LogViewPageState extends State<LogViewPage> {
  final signedInUser = FirebaseAuth.instance.currentUser;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('userData');
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  var dispResult;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _jobController = TextEditingController();
  final dbRef = FirebaseDatabase.instance.reference().child('users');
  var daKey;
  deleteAlert(context) {
    AlertStyle _alertStyle =
        AlertStyle(isCloseButton: true, titleStyle: GoogleFonts.concertOne());
    Alert(
        type: AlertType.warning,
        style: _alertStyle,
        context: context,
        title: 'Delete?',
        desc: 'Are you sure you want to delete this data Field?',
        buttons: [
          DialogButton(
              child: Text(
                'cancel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          DialogButton(
              child: Text('delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                  )),
              onPressed: () {
                deleteFromDb();
                Navigator.pop(context);
              })
        ]).show();
  }

  editAlert(context) {
    AlertStyle alertStyle =
        AlertStyle(isCloseButton: true, titleStyle: GoogleFonts.concertOne());
    Alert(
        type: AlertType.info,
        context: context,
        title: 'edit',
        style: alertStyle,
        content: Column(
          children: [
            Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    decoration:
                        InputDecoration(icon: Icon(Icons.person_rounded)),
                    controller: _nameController,
                  ),
                )),
            Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.edit),
                    ),
                    maxLines: 3,
                    controller: _jobController,
                  ),
                ))
          ],
        ),
        buttons: [
          DialogButton(
            child: Text(
              'update',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              updateData();
            },
          ),
          DialogButton(
              child: Text(
                'cancel',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ]).show();
  }

  updateData() {
    Map<String, dynamic> theData = {
      'name': _nameController.text,
      'job': _jobController.text
    };
    final signedInUser = auth.currentUser;
    dbRef
        .child(signedInUser!.uid)
        .child('userTasks')
        .child(daKey.toString())
        .update(theData)
        .then((value) {
      Navigator.pop(context);
    });
  }

  Future<dynamic> getData() async {
    final signedInUser = auth.currentUser;
    DataSnapshot snapshot = await dbRef
        .child(signedInUser!.uid)
        .child('userTasks')
        .child(daKey.toString())
        .once();

    Map result = snapshot.value;
    _nameController.text = result['name'];
    _jobController.text = result['job'];
    print(daKey.toString());
  }

  deleteFromDb() async {
    final signedInUser = auth.currentUser;
    dbRef
        .child(signedInUser!.uid)
        .child('userTasks')
        .child(daKey.toString())
        .remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        centerTitle: true,
        leading: ElasticInRight(
          child: GFIconButton(
              type: GFButtonType.transparent,
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => BounceInLeft(child: HomePage())));
              }),
        ),
        backgroundColor: Colors.pinkAccent,
        title: ElasticInUp(
            child: Text('Saved Data', style: GoogleFonts.concertOne())),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.pinkAccent, Colors.purpleAccent]),
        ),
        child: Column(
          children: [
            Expanded(
                child: FirebaseAnimatedList(
                    shrinkWrap: true,
                    query: dbRef.child(signedInUser!.uid).child('userTasks'),
                    itemBuilder: (context, snapshot,
                        Animation<double> animation, index) {
                      Map returnedData = snapshot.value;
                      returnedData['key'] = snapshot.key;
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        direction: Axis.horizontal,
                        child: Card(
                          elevation: 3,
                          child: ListTile(
                            leading: GFAvatar(
                              backgroundImage: AssetImage('images/bob.gif'),
                            ),
                            title: Text(
                              'Name : ' + snapshot.value['name'].toString(),
                              style: GoogleFonts.concertOne(
                                  fontWeight: FontWeight.normal, fontSize: 20),
                            ),
                            subtitle: Text(
                              'Job : ' + snapshot.value['job'].toString(),
                              style: GoogleFonts.concertOne(
                                  fontWeight: FontWeight.normal, fontSize: 20),
                            ),
                            trailing: Column(
                              children: [
                                BounceInLeft(
                                    child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.pinkAccent,
                                )),
                                ElasticInRight(
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: 'swipe',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.black)),
                                      TextSpan(
                                          text: '<Right>',
                                          style: TextStyle(
                                              color: Colors.pinkAccent,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          BounceInLeft(
                            child: IconSlideAction(
                              color: Colors.grey.shade200,
                              caption: 'Delete',
                              iconWidget: Icon(
                                Icons.delete,
                                color: GFColors.DANGER,
                              ),
                              onTap: () {
                                setState(() {
                                  daKey = returnedData['key'];
                                });

                                deleteAlert(context);
                              },
                            ),
                            delay: const Duration(milliseconds: 500),
                          ),
                          BounceInLeft(
                            child: IconSlideAction(
                              color: Colors.grey.shade200,
                              caption: 'Edit',
                              iconWidget: Icon(
                                Icons.edit,
                                color: GFColors.SUCCESS,
                              ),
                              onTap: () {
                                setState(() {
                                  daKey = returnedData['key'];
                                });
                                getData();
                                editAlert(context);

                                //
                                // Navigator.of(context).pushReplacement(
                                //     MaterialPageRoute(
                                //         builder: (context) => EditUserPage(
                                //             userKey: returnedData['key']
                                //                 .toString())));
                              },
                            ),
                          )
                        ],
                      );
                    })
                // return ListTile(
                //   title: Text(snapshot.value['name']),
                //   trailing: IconButton(
                //     icon: Icon(Icons.delete),
                //     onPressed: () {
                //       dbRef
                //           .child(signedInUser!.uid)
                //           .child('userTasks')
                //           .child(snapshot.key.toString())
                //           .remove();
                //     },
                //   ),
                // );
                //},
                )
            // child: StreamBuilder<QuerySnapshot>(
            //     stream: collectionReference
            //         .doc(signedInUser!.uid)
            //         .collection('userTasks')
            //         .snapshots(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         return ListView.builder(
            //             itemCount: snapshot.data!.docs.length,
            //             itemBuilder: (context, index) {
            //               DocumentSnapshot ds = snapshot.data!.docs[index];
            //
            //       } else {
            //         return Center(
            //           child: CircularProgressIndicator(),
            //         );
            //       }
            //     }),
            //)
          ],
        ),
      ),
    );
  }
}
