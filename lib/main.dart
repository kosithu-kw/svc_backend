import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_backend/ads_settings.dart';
import 'package:movie_backend/genre.dart';
import 'package:movie_backend/new_genre.dart';
import 'package:movie_backend/new_sv.dart';
import 'package:movie_backend/videos.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth.dart';
import 'home.dart';


void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(
    MaterialApp(
      title: "Welcome S V C",
      home: App(),
    )
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  bool _isLogin=false;

  _checkSignin(){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        setState(() {
          _isLogin=false;
        });
      } else {
        _isLogin=true;
      }
    });
  }

  @override
  void initState() {

   _checkSignin();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(home: Splash());
        } else {
          // Loading is done, return the app:
          if(_isLogin){
            return MaterialApp(home: Home());
          }else{
            return MaterialApp(home: Auth(),);

          }
        }
      },
    );
  }
}


class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(Duration(seconds: 3));
  }
}
class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x204665).withOpacity(1.0),
      body: Center(
          child: Stack(
            children: [
              Center(
                child: DefaultTextStyle(
                    style: TextStyle(
                        color: Colors.amber[500],
                        fontSize: 35,
                        fontWeight: FontWeight.bold
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        WavyAnimatedText('S V C'),
                      ],
                      isRepeatingAnimation: true,

                    )
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 50,
                  margin: EdgeInsets.only(bottom: 50, left: 150, right: 150),
                  child: LinearProgressIndicator(
                    color: Colors.amber[500],
                    backgroundColor: Colors.amber[900],
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}


