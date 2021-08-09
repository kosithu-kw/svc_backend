import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'main.dart';

class EditGenre extends StatefulWidget {
  final data;
  const EditGenre({Key? key, required this.data}) : super(key: key);

  @override
  _EditGenreState createState() => _EditGenreState();
}

class _EditGenreState extends State<EditGenre> {

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
              Text("The selected genre title is already exist.")
            ],
          ),

          duration: Duration(seconds: 2),
        ));
  }

  var _titleController=TextEditingController();
  String _gTitle="";

  saveGenre()async{
    _loadingSnackBar();
    await firestore.collection("Genre").doc(widget.data.id).update({
      "title" : _gTitle
    }).then((value) {
      _finishSnackBar();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _titleController.text=widget.data['title'];
      _gTitle=widget.data['title'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Edit Genre",
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
            title: Text("Edit Genre"),
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
                              child: Text("Update"),
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
