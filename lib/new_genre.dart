import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'main.dart';

class AddGenre extends StatefulWidget {
  const AddGenre({Key? key}) : super(key: key);

  @override
  _AddGenreState createState() => _AddGenreState();
}

class _AddGenreState extends State<AddGenre> {

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
              Text("Saving Success")
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
              Text("The selected genre title is already exist.")
            ],
          ),

          duration: Duration(seconds: 2),
        ));
  }

  var _titleController=TextEditingController();
  String _gTitle="";
  DateTime now = DateTime.now();

   saveGenre()async{
      _loadingSnackBar();

          await firestore.collection("Genre").where("title", isEqualTo: _gTitle).get()
          .then((value){
            if(value.docs.length>0){
              _errorSnackBar();
            }else{
              firestore.collection("Genre").add({"title": _gTitle, "created_at": now})
                  .then((value){
                _finishSnackBar();
                _titleController.clear();
              });
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Add Genre",
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
          title: Text("Add Genre"),
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
          width: 600,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  child: TextFormField(
                    controller: _titleController,
                    onChanged: (v){
                      setState(() {
                        _gTitle=v;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Genre title"
                    ),
                    validator: (v){

                        if(v==null || v.isEmpty){
                          return "Genre title is input required.";
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
                        child: Text("Save"),
                        onPressed: ()async{
                          if(_formKey.currentState!.validate()){
                            saveGenre();
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
