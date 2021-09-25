import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:log_book/src/screens/Home.dart';
import 'package:getwidget/getwidget.dart';
import 'package:log_book/src/screens/welcome.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:log_book/src/configs/counters.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;

  final _loginFormKey = GlobalKey<FormState>();
  late bool _showField;
  bool isTyping = false;
  bool isReady = false;

  loginUser() async {
    try {
      await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      String errorMessage = e.toString().replaceRange(0, 14, '').split(']')[1];

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
  void initState() {
    // TODO: implement initState
    _showField = true;
    super.initState();
    isReady = false;
  }

  @override
  Widget build(BuildContext context) {
    final providerText = Provider.of<String>(context);
    final counterProgress = Provider.of<Counter>(context);
    Widget progressSwap() {
      return isTyping == true
          ? BounceInUp(child: Text(counterProgress.displayPercent() + '%'))
          : BounceInLeft(
              child: Icon(
              Icons.person_rounded,
              size: 100,
            ));
    }

    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.pinkAccent,
          ),
        ),
        SingleChildScrollView(
          child: Form(
            key: _loginFormKey,
            child: Column(
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
                Text(providerText),
                SizedBox(
                  height: 80,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 7,
                      shadowColor: Colors.black,
                      shape: CircleBorder(),
                      child: CircularPercentIndicator(
                          radius: 150.0,
                          percent: counterProgress.progressPercent,
                          onAnimationEnd: () {
                            counterProgress.progressPercent == 1.0
                                ? isReady = true
                                : isReady = false;
                            print('Animation ended');
                          },
                          animation: true,
                          circularStrokeCap: CircularStrokeCap.round,
                          backgroundWidth: 10,
                          lineWidth: 7,
                          linearGradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.topRight,
                              colors: [Colors.green, Colors.yellow]),
                          backgroundColor: Colors.grey,
                          animateFromLastPercent: true,
                          // progressColor: Colors.greenAccent,
                          center: progressSwap()),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FocusScope(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'field cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                              controller: emailController,
                              onTap: () {
                                counterProgress.increamentProgress();
                              },
                              onChanged: (value) {
                                setState(() {
                                  isTyping = true;
                                });
                              },
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                labelText: 'email',
                                labelStyle: TextStyle(color: Colors.white),
                                icon: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                hintText: 'abc@gmail.com',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'field cannot be empty';
                              } else if (value.length < 6) {
                                return 'password must contain more than 6 characters';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                isTyping = true;
                              });
                            },
                            onTap: () {
                              counterProgress.increamentProgress();
                            },
                            controller: passwordController,
                            obscureText: _showField,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.white),
                              icon: Icon(
                                Icons.password,
                                color: Colors.white,
                              ),
                              hintText: 'abc123',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SlideInRight(
                            child: ElevatedButton(
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.greenAccent,
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: isReady == false
                                    ? Colors.white
                                    : Colors.black,
                                elevation: 7,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              onPressed: () {
                                if (_loginFormKey.currentState!.validate()) {
                                  loginUser();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
