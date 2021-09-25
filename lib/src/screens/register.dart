import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:log_book/src/screens/Home.dart';
import 'package:getwidget/getwidget.dart';
import 'package:log_book/src/screens/welcome.dart';
import 'package:log_book/src/services/firebaseServices.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _userName = TextEditingController();
  final auth = FirebaseAuth.instance;
  final _registerFormKey = GlobalKey<FormState>();
  final dbRef = FirebaseDatabase.instance.reference();
  final signedInUser = FirebaseAuth.instance.currentUser;
  final FirebaseServices serviceObject = FirebaseServices();
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _userName.dispose();
    super.dispose();
  }

  void scaffoldSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Success!',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Expanded(
              child: Icon(
            Icons.check_circle_rounded,
            color: Colors.white,
          ))
        ],
      ),
      backgroundColor: Colors.greenAccent,
    ));
  }

  Future<void> signInUser() async {
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: _email.text, password: _password.text)
          .then((value) {
        String username = _userName.text;
        dbRef.child('users').child(value.user!.uid).set({
          'username': username,
          'email': value.user!.email,
          'id': value.user!.uid,
          'TimeStamp': DateTime.now().toString()
        });
        scaffoldSuccess();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
      });
    } catch (e) {
      String errorMessage = e.toString().replaceRange(0, 14, '').split(']')[1];

      print(errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.white,
        content: ElasticInLeft(
          child: RichText(
            text: TextSpan(
                text: 'Error: ',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: errorMessage,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal))
                ]),
          ),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purpleAccent, Colors.white]),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ElasticInRight(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          BounceInRight(
                            delay: Duration(milliseconds: 500),
                            child: GFIconButton(
                                type: GFButtonType.transparent,
                                icon: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => BounceInLeft(
                                              child: WelcomePage())));
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    BounceInRight(
                      delay: Duration(milliseconds: 800),
                      child: GFCard(
                        elevation: 3,
                        color: Colors.pinkAccent,
                        image: Image.asset('images/guy.gif'),
                        content: Text(
                          'The best solution to job assignment online',
                          style: GoogleFonts.concertOne(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Form(
                      key: _registerFormKey,
                      child: Column(
                        children: [
                          GFLoader(
                            type: GFLoaderType.circle,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: BounceInRight(
                              delay: const Duration(milliseconds: 1000),
                              child: Card(
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'field cannot be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: _userName,
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.person_rounded),
                                        hintText: 'abc101',
                                        labelText: "user name",
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.pinkAccent)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white))),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: BounceInRight(
                              delay: const Duration(milliseconds: 1500),
                              child: Card(
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'field cannot be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: _email,
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.email),
                                        hintText: 'abc@gmail.com',
                                        labelText: "email",
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.pinkAccent)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white))),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: BounceInRight(
                              delay: const Duration(milliseconds: 1800),
                              child: Card(
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'field cannot be empty';
                                      } else if (value.length < 6) {
                                        return 'pasword must contain more than 6 characters';
                                      }
                                      return null;
                                    },
                                    controller: _password,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelText: "Password",
                                        icon: Icon(Icons.password),
                                        hintText: 'enter strong password',
                                        border: InputBorder.none,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.pinkAccent))),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8.0, left: 10.0, right: 10),
                            child: BounceInRight(
                              delay: const Duration(milliseconds: 1700),
                              child: GFButton(
                                  type: GFButtonType.solid,
                                  shape: GFButtonShape.pills,
                                  size: GFSize.MEDIUM,
                                  buttonBoxShadow: true,
                                  fullWidthButton: true,
                                  color: Colors.pinkAccent,
                                  textStyle: GoogleFonts.concertOne(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  onPressed: () {
                                    if (_registerFormKey.currentState!
                                        .validate()) {
                                      signInUser();
                                    }
                                  },
                                  child: Text('Register')),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
