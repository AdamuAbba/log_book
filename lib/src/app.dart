import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:log_book/src/screens/Home.dart';
import 'package:log_book/src/screens/Login.dart';
import 'package:log_book/src/screens/register.dart';
import 'package:log_book/src/screens/welcome.dart';
import 'package:log_book/src/screens/intropage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:log_book/src/configs/counters.dart';

class App extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final dbRef = FirebaseDatabase.instance.reference().child('users');

  Future<String> dummyFuture() async {
    String result = 'dummy future text';
    return result;
  }

  Future<String> snapOfData() async {
    final signedInUser = auth.currentUser;
    // saving Future<DataSnapshot> into a variable
    DataSnapshot result = await dbRef.child(signedInUser!.uid).once();
    // process::returned a type DataSnapshot data,
    //          converted to type dynamic data.
    //          fincally converted to a type String
    return result.value['username'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<String>(
          initialData: 'Loading',
          create: (context) => snapOfData().asStream(),
        ),
        ChangeNotifierProvider<Counter>(create: (context) {
          return Counter();
        }),
      ],
      child: MaterialApp(
        initialRoute: auth.currentUser == null ? '/' : '/home',
        routes: {
          '/': (context) => IntroPage(),
          '/welcome': (context) => WelcomePage(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => HomePage()
        },
        theme: ThemeData(
            textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme)),
      ),
    );
  }
}
