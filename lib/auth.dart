import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

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
                        child: Text("Sign In to S V C", style: TextStyle(color: Color(0x204665).withOpacity(1.0), fontSize: 30, fontWeight: FontWeight.bold),),
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

