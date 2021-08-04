import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'main.dart';

class EditSv extends StatefulWidget {
  final data;
  const EditSv({Key? key, required this.data}) : super(key: key);

  @override
  _EditSvState createState() => _EditSvState();
}

class _EditSvState extends State<EditSv> {

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _loadingSnackBar() {
    _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 50,),
              Text("Saving genre ...")
            ],
          ),

          duration: Duration(seconds: 1),
        ));
  }
  void _finishSnackBar() {
    _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20,),
              SizedBox(width: 50,),
              Text("Updating Success")
            ],
          ),

          duration: Duration(seconds: 2),
        ));
  }
  void _errorSnackBar() {
    _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.white, size: 20,),
              SizedBox(width: 50,),
              Text("The selected video title is already exist.")
            ],
          ),

          duration: Duration(seconds: 2),
        ));
  }



  saveVideo()async{
    _loadingSnackBar();
    await firestore.collection("Videos").doc(widget.data.id).update({
      "title" : _vTitle,
      "genre": _genre,
      "video_url" :_videoUrl,
      "poster_url" :_posterUrl,

    }).then((value) {
      _finishSnackBar();
    });
  }

  List<String> _genres=["Select Genre"];
  getAllGenres(){
    firestore.collection("Genre").get().then((value){
      for(var i in value.docs){
        setState(() {
          _genres.add(i.data()['title']);
        });
        //print(i.data()['title']);
      }
    });
  }

  String _genre = 'Select Genre';
  var _titleController=TextEditingController();
  var _urlController=TextEditingController();
  var _posterController=TextEditingController();
  String _vTitle="";
  String _videoUrl="";
  String _posterUrl="";

  @override
  void initState() {
    // TODO: implement initState
    getAllGenres();

    Timer(Duration(seconds: 1), (){
      setState(() {
        _titleController.text=widget.data['title'];
        _urlController.text=widget.data['video_url'];
        _posterController.text=widget.data['poster_url'];
        _vTitle=widget.data['title'];
        _genre=widget.data['genre'];
        _videoUrl=widget.data['video_url'];
        _posterUrl=widget.data['poster_url'];
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: false,
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text("Edit Video"),
            actions: [
              IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> App()));

                  },
                  icon: Icon(Icons.home)
              )
            ],
          ),
          body:Center(
            child:  Container(
                padding: EdgeInsets.all(50),
                width: 1000,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                          width: 1000,
                          child: DropdownButtonFormField<String>(
                            validator: (v){
                              if(v==null || v.isEmpty || v=="Select Genre"){
                                return "Genre field is selected required.";
                              }
                              return null;

                            },
                            value: _genre,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.black
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _genre = newValue!;
                              });
                            },
                            items: _genres.map((g) {
                              return DropdownMenuItem(
                                child: new Text(g),
                                value: g,
                              );
                            }).toList(),
                          )
                      ),
                      SizedBox(height: 20,),
                      Container(
                        child: TextFormField(
                          controller: _titleController,
                          onChanged: (v){
                            setState(() {
                              _vTitle=v;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "Video title"
                          ),
                          validator: (v){

                            if(v==null || v.isEmpty){
                              return "Video title is input required.";
                            }
                            return null;

                          },
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        child: TextFormField(
                          controller: _urlController,
                          onChanged: (v){
                            setState(() {
                              _videoUrl=v;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "Video URL"
                          ),
                          validator: (v){
                            if(v==null || v.isEmpty){
                              return "Video URL is input required.";
                            }
                            return null;

                          },
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        child: TextFormField(
                          controller: _posterController,
                          onChanged: (v){
                            setState(() {
                              _posterUrl=v;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "Poster URL"
                          ),
                          validator: (v){
                            if(v==null || v.isEmpty){
                              return "Poster URL is input required.";
                            }
                            return null;

                          },
                        ),
                      ),
                      SizedBox(height: 30,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            child: SizedBox(
                              width: 100,
                              height: 50,
                              child: ElevatedButton(
                                child: Text("Update"),
                                onPressed: ()async{
                                  if(_formKey.currentState!.validate()){
                                    saveVideo();
                                  }
                                },
                              ),
                            )
                        ),
                      )
                    ],
                  ),
                )
            ),
          ),
        )
    );
  }
}
