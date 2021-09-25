import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animate_do/src/animate_do_attention_seekers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:log_book/src/screens/Login.dart';
import 'package:log_book/src/screens/intropage.dart';
import 'package:log_book/src/screens/register.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late AnimationController animateController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/hello.gif'), fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 17.0),
                          child: Pulse(
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.pinkAccent,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            BounceInLeft(child: IntroPage())));
                              },
                            ),
                            infinite: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GFCard(
                          elevation: 5,
                          boxFit: BoxFit.cover,
                          imageOverlay: AssetImage('images/waves.png'),
                          title: GFListTile(
                            title: Text(
                              'DIGILOG',
                              style: GoogleFonts.concertOne(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          content: Text(
                            "A simple Firebase Database enabled log book",
                            style: GoogleFonts.concertOne(
                              fontSize: 20,
                            ),
                          ),
                          buttonBar: GFButtonBar(
                            children: <Widget>[
                              GFIconButton(
                                onPressed: () {},
                                shape: GFIconButtonShape.circle,
                                color: Colors.blueAccent,
                                icon: FaIcon(FontAwesomeIcons.facebook),
                              ),
                              GFIconButton(
                                onPressed: () {},
                                icon: FaIcon(FontAwesomeIcons.twitter),
                                shape: GFIconButtonShape.circle,
                              ),
                              GFIconButton(
                                  icon: FaIcon(FontAwesomeIcons.instagram),
                                  color: Colors.pinkAccent,
                                  shape: GFIconButtonShape.circle,
                                  onPressed: () {}),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GFLoader(
                          type: GFLoaderType.circle,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FadeInLeft(
                            child: GFButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => BounceInRight(
                                              child: RegisterPage())));
                                },
                                elevation: 5,
                                shape: GFButtonShape.pills,
                                text: "REGISTER",
                                blockButton: true,
                                size: GFSize.LARGE,
                                color: Colors.pinkAccent,
                                buttonBoxShadow: true,
                                type: GFButtonType.solid,
                                textStyle:
                                    GoogleFonts.concertOne(fontSize: 20)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FadeInRight(
                            child: GFButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            BounceInRight(
                                                child: LoginScreen())));
                              },
                              elevation: 5,
                              text: "LOGIN",
                              blockButton: true,
                              color: Colors.pinkAccent,
                              shape: GFButtonShape.pills,
                              size: GFSize.LARGE,
                              type: GFButtonType.solid,
                              buttonBoxShadow: true,
                              textStyle: GoogleFonts.concertOne(fontSize: 20),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Column(
          //   children: [
          //     ElevatedButton(onPressed: () {}, child: Text('Register'))
          //   ],
          // )
        ],
      ),
    );
  }
}
