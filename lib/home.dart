
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_backend/videos.dart';

import 'ads_settings.dart';
import 'auth.dart';
import 'genre.dart';
import 'main.dart';
import 'new_genre.dart';
import 'new_sv.dart';

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
  String _picture="";
  bool _isLogin=false;
  String _name="";

  _getAuth()async{

    var currentUser=await FirebaseAuth.instance.currentUser;
    if(currentUser.uid !=null){
      setState(() {
        userEmail=currentUser.email;
        _isLogin=true;
        _name=currentUser.displayName;
        _picture=currentUser.photoURL;
      });
    }

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
                      radius: 30,
                      child: ClipOval(
                        child:  Image.asset("images/profile.jpg"),
                      ),
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