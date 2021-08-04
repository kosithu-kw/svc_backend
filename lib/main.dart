import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_backend/ads_settings.dart';
import 'package:movie_backend/genre.dart';
import 'package:movie_backend/new_genre.dart';
import 'package:movie_backend/new_sv.dart';
import 'package:movie_backend/videos.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: App(),
    )
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Home();
  }
}


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String _title="Short Video Myanmar";

  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
     _getMovies();
     _getGenres();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(
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
                  accountName: Text("SVM"),
                  accountEmail: Text("Short Video Myanmar")
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
