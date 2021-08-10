import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_backend/edit_genre.dart';
import 'package:movie_backend/edit_sv.dart';
import 'package:movie_backend/play.dart';

import 'main.dart';

class Videos extends StatefulWidget {
  const Videos({Key? key}) : super(key: key);

  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  void _finishSnackBar() {
    _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20,),
              SizedBox(width: 50,),
              Text("The selected video has been deleted.")
            ],
          ),

          duration: Duration(seconds: 2),
        ));
  }
  FirebaseFirestore firestore=FirebaseFirestore.instance;

  _confirmDel(id){
    firestore.collection("Videos").doc(id).delete().then((value){
      _finishSnackBar();
      setState(() {});

    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Videos",
      home: Scaffold(
        key: _scaffoldKey,

        appBar: AppBar(
          backgroundColor: Color(0x204665).withOpacity(1.0),
            centerTitle: false,
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text("Videos"),
            actions: [
              IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> App()));

                  },icon: Icon(Icons.home)
              )
            ]
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection("Videos").orderBy("created_at", descending: true).snapshots(),
            builder: (BuildContext context, s){
              if(s.hasData){
                var d=s.data!.docs;
                return GridView.builder(
                    itemCount: d.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5 ,
                        childAspectRatio: 5/6
                    ),
                    itemBuilder: (_, i){
                      return Card(
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                            child:  Column(
                              children: [
                                Image.network(d[i]['poster_url']),
                                SizedBox(height: 10,),
                                Text("${d[i]['title']}", style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text("${d[i]['genre']}" , style: TextStyle(color: Colors.grey),),
                                SizedBox(height: 20,),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> PlayVideo(data: d[i])));
                                          },
                                          icon: Icon(Icons.play_circle_filled_sharp, color: Colors.green,)
                                      ),
                                      IconButton(
                                          onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> EditSv(data: d[i])));
                                          },
                                          icon: Icon(Icons.edit, color: Colors.blueAccent,)
                                      ),
                                      IconButton(
                                          onPressed: (){
                                            _confirmDel(d[i].id);
                                          },
                                          icon: Icon(Icons.remove_circle_outlined, color: Colors.red,)
                                      )
                                    ],
                                  ),
                                )

                              ],
                            ),
                          )
                      );
                    }
                );

              }else if(s.hasError){
                return Center(
                  child: Text("${s.error}"),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
