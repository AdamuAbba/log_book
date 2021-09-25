import 'dart:async';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:getwidget/getwidget.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:log_book/src/screens/welcome.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:log_book/src/screens/Home.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  List<Slide> slides = [];
  int hexColor(String color) {
    String newColor = '0xff' + color;
    newColor = newColor.replaceAll('#', '');
    int finalColor = int.parse(newColor);
    return finalColor;
  }

  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
        title: "Co-op workflow",
        description: "better co-operative worklow",
        pathImage: "images/CharacterswithLaptopmin.gif",
        backgroundColor: Color(0xfff5a623),
      ),
    );
    slides.add(
      Slide(
        title: "Style",
        description: "Get it done with style",
        pathImage: "images/logoavengers.gif",
        backgroundColor: Color(hexColor('#fc3d3d')),
      ),
    );
    slides.add(
      Slide(
        title: "RULER",
        description:
            "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of",
        pathImage: "images/homework.gif",
        backgroundColor: Color(0xff9932CC),
      ),
    );
  }

  void onDonePress() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => BounceInRight(child: WelcomePage())));
    // Do what you want
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
    );
  }
}
