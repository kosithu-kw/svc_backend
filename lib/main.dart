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



class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {

  var _formKey=GlobalKey<FormState>();

  String email="";
  var emailController=TextEditingController();
  String password="";
  var passwordController=TextEditingController();

  bool _obsecureText=true;

  String err="";

  bool _isLogin=false;
  bool _isLoading=false;




  doSignin()async{
    setState(() {
      _isLogin=true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if(userCredential!=null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
        setState(() {
          _isLogin=false;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _isLogin=false;
          err="No user found for that email.";
        });
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        setState(() {
          _isLogin=false;
          err="Wrong password provided for that user.";
        });
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Authentication",
      home: Scaffold(
        body: Center(
        child: Container(
          padding: EdgeInsets.all(50),
          width: 600,
          child: Form(
            key: _formKey,
          child: Column(
            children: [

              Container(
                child: Text("Sign In to S V C Dashboard", style: TextStyle(color: Colors.blueAccent, fontSize: 30, fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 60,),
              Container(
                child: Text(err, style: TextStyle(color: Colors.red),),
              ),
              SizedBox(height: 20,),
              Container(
                child: TextFormField(
                  controller: emailController,
                  onChanged: (v){
                    setState(() {
                      email=v;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "E-Mail"
                  ),
                  validator: (v){

                    if(v==null || v.isEmpty){
                      return "Email is input required.";
                    }
                    return null;

                  },
                ),
              ),
              SizedBox(height: 20,),
              Container(
                child: TextFormField(
                  controller: passwordController,
                  onChanged: (v){
                    setState(() {
                      password=v;
                    });
                  },
                  obscureText: _obsecureText,
                  decoration: InputDecoration(
                      hintText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon( _obsecureText ? Icons.remove_red_eye : Icons.remove_red_eye_outlined),
                      onPressed: (){
                        setState(() {
                          _obsecureText=!_obsecureText;
                        });
                      },
                    )

                  ),
                  validator: (v){

                    if(v==null || v.isEmpty){
                      return "Password is input required.";
                    }
                    return null;

                  },
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        child: SizedBox(
                          width: 100,
                          height: 50,
                          child: ElevatedButton(
                            child: Text("Signin"),
                            onPressed: ()async{
                              if(_formKey.currentState!.validate()){
                                doSignin();
                              }
                            },
                          ),
                        )
                    ),
                  ),
                  SizedBox(width: 50,),
                  if(_isLogin) CircularProgressIndicator(),
                ],
              )
            ],
          ),
        ),
        )
      ),
      )
    );
  }
}




class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String _title="S V C Dashboard";

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth=FirebaseAuth.instance;

  String userEmail="";

  _getAuth(){
    var u=_auth.currentUser;
   setState(() {
     userEmail=u.email;
   });

  }

   int _videos=0;
   int _genres=0;

   _getMovies() async{
      await firestore.collection("Videos").snapshots().forEach((element) {
        setState(() {
          _videos=element.docs.length;
        });
      });

   }

   _getGenres() async{
     await firestore.collection("Genre").snapshots().forEach((element) {
       setState(() {
         _genres=element.docs.length;
       });
     });
   }

   @override
  void initState() {
     _getAuth();
     _getMovies();
     _getGenres();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0x204665).withOpacity(1.0),
      ),
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0x204665).withOpacity(1.0),
          centerTitle: false,
          title: Text(_title),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    child: Icon(Icons.video_collection_outlined),
                  ),
                  accountName: Text("S V C"),
                  accountEmail: Text(userEmail)
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> App()));

                },
                title: Text("Dashboard"),
                leading: Icon(Icons.dashboard),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AddSv()));

                },
                title: Text("Add Video"),
                leading: Icon(Icons.add_circle),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Videos()));
                },
                title: Text("Videos"),
                leading: Icon(Icons.video_call_rounded),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AddGenre()));
                },
                title: Text("Add Genre"),
                leading: Icon(Icons.add_circle),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Genre()));
                },
                title: Text("Genres"),
                leading: Icon(Icons.line_style_outlined),
              ),
              ListTile(
                onTap: (){
                  _auth.signOut().then((value){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Auth()));
                  });

                },
                title: Text("Logout"),
                leading: Icon(Icons.logout),
              ),
            ],

          ),
        ),
        body: Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 10),
            child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 6/3,
                children: [
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle, size: 30, color: Colors.black,),
                              SizedBox(width: 20,),
                              Text("Add Video", style: TextStyle(color: Colors.black, fontSize: 20),)
                            ],
                          ),
                          SizedBox(height: 50,),
                          Container(
                            child: IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddSv()));
                              },
                              icon: Icon(Icons.navigate_next_rounded, color: Colors.blueAccent,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.video_call_rounded, size: 30, color: Colors.black,),
                              SizedBox(width: 20,),
                              Text("Videos", style: TextStyle(color: Colors.black, fontSize: 20),),
                              SizedBox(width: 10,),
                              Container(
                                padding: EdgeInsets.only(top: 2, bottom: 2, left: 10, right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Text("${_videos}", style: TextStyle(color: Colors.white),),
                              )
                            ],
                          ),
                          SizedBox(height: 50,),
                          Container(
                            child: IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> Videos()));
                              },
                              icon: Icon(Icons.navigate_next_rounded, color: Colors.blueAccent,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  Card(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle, size: 30, color: Colors.black,),
                              SizedBox(width: 20,),
                              Text("Add Genre", style: TextStyle(color: Colors.black, fontSize: 20),)
                            ],
                          ),
                          SizedBox(height: 50,),
                          Container(
                            child: IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddGenre()));
                              },
                              icon: Icon(Icons.navigate_next_rounded, color: Colors.blueAccent,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.view_agenda, size: 30, color: Colors.black,),
                              SizedBox(width: 20,),
                              Text("Genres", style: TextStyle(color: Colors.black, fontSize: 20),),
                              SizedBox(width: 10,),
                              Container(
                                padding: EdgeInsets.only(top: 2, bottom: 2, left: 10, right: 10),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Text("${_genres}", style: TextStyle(color: Colors.white),),
                              )
                            ],
                          ),
                          SizedBox(height: 50,),
                          Container(
                            child: IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> Genre()));
                              },
                              icon: Icon(Icons.navigate_next_rounded, color: Colors.blueAccent,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.settings, size: 30, color: Colors.black,),
                              SizedBox(width: 20,),
                              Text("Ads Settings", style: TextStyle(color: Colors.black, fontSize: 20),),

                            ],
                          ),
                          SizedBox(height: 50,),
                          Container(
                            child: IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> AdsSettings()));
                              },
                              icon: Icon(Icons.navigate_next_rounded, color: Colors.blueAccent,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
            )
         ),
      )
    );
  }
}

/*
ListView(
              children: [
                Card(
                  child: Container(
                    padding: EdgeInsets.all(50),
                    child: ListTile(
                      leading: Icon(Icons.video_call_rounded),
                      title: Text("Videos"),
                      trailing: Icon(Icons.navigate_next_rounded),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Videos()));
                      },
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(50),
                    child: ListTile(
                      leading: Icon(Icons.add_circle),
                      title: Text("Add Video"),
                      trailing: Icon(Icons.navigate_next_rounded),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddSv()));
                      },
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(50),
                    child: ListTile(
                      leading: Icon(Icons.list),
                      title: Text("Genres"),
                      trailing: Icon(Icons.navigate_next_rounded),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Genre()));
                      },
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(50),
                    child: ListTile(
                      leading: Icon(Icons.add_circle),
                      title: Text("Add Genre"),
                      trailing: Icon(Icons.navigate_next_rounded),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddGenre()));
                      },
                    ),
                  ),
                )
              ],
            )
 */
