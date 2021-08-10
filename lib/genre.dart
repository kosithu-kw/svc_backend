import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_backend/edit_genre.dart';

import 'main.dart';

class Genre extends StatefulWidget {
  const Genre({Key? key}) : super(key: key);

  @override
  _GenreState createState() => _GenreState();
}

class _GenreState extends State<Genre> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  void _finishSnackBar() {
    _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20,),
              SizedBox(width: 50,),
              Text("The selected genre has been deleted.")
            ],
          ),

          duration: Duration(seconds: 2),
        ));
  }
  FirebaseFirestore firestore=FirebaseFirestore.instance;

  void confirmDel(id){
    firestore.collection("Genre").doc(id).delete().then((value){
      _finishSnackBar();
      setState(() {});

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Genres",
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
          title: Text("Genres"),
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
            stream: firestore.collection("Genre").snapshots(),
            builder: (BuildContext context, s){
              if(s.hasData){
                var d=s.data!.docs;
                return GridView.builder(
                  itemCount: d.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4 ,
                      childAspectRatio: 5/2
                    ),
                    itemBuilder: (_, i){
                        return Card(
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                            child:  Stack(
                              children: [
                                Text(d[i]['title']),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> EditGenre(data: d[i])));
                                          },
                                          icon: Icon(Icons.edit, color: Colors.blueAccent,)
                                      ),
                                      IconButton(
                                          onPressed: (){
                                            confirmDel(d[i].id);
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


/*
return ListView.builder(
                    itemCount: d.length,
                    itemBuilder: (_, i){
                      return Card(
                        child: ListTile(
                          title: Text(d[i]['title']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> EditGenre(data: d[i])));
                                    },
                                    icon: Icon(Icons.edit, color: Colors.blueAccent,)
                                ),
                                IconButton(
                                    onPressed: (){
                                        confirmDel(d[i].id, d[i]['title']);
                                    },
                                    icon: Icon(Icons.remove_circle_outlined, color: Colors.red,)
                                )
                              ],
                          ),
                        ),
                      );
                    }
                );
 */