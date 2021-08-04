import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'main.dart';


class AdsSettings extends StatefulWidget {
  const AdsSettings({Key? key}) : super(key: key);

  @override
  _AdsSettingsState createState() => _AdsSettingsState();
}

class _AdsSettingsState extends State<AdsSettings> {

  FirebaseFirestore firestore=FirebaseFirestore.instance;

  String inter_id="";
  String banner_id="";

  String show_inter="Show Inter";
  String show_banner="Show Banner";

  List<String> _banners=["Show Banner", "true", "false"];
  List<String> _inters=["Show Inter", "true", "false"];


  void _getAds()async{
    var r=await firestore.collection("Ads").get();
    var d=r.docs.first.data();
    Timer(Duration(seconds: 1), (){
      setState(() {
        inter_id=d['inter_id'];
        interIDController.text=d['inter_id'];
        banner_id=d['banner_id'];
        bannerIdController.text=d['banner_id'];
      });
    });
  }


  final _formKey = GlobalKey<FormState>();
  var bannerIdController=TextEditingController();
  var interIDController=TextEditingController();

  void saveAds()async{
    var r=await firestore.collection("Ads").get();
    var Id=r.docs.first.id;

    bool s_inter=false;
    bool s_banner=false;
    if(show_inter=="true"){
      setState(() {
        s_inter=true;
      });
    }else{
      setState(() {
        s_inter=false;
      });
    }
    if(show_banner=="true"){
      setState(() {
        s_banner=true;
      });
    }else{
      setState(() {
        s_banner=false;
      });
    }

    firestore.collection("Ads").doc(Id).update({
      'banner_id': banner_id,
      'inter_id': inter_id,
      'show_inter': s_inter,
      'show_banner':s_banner,
    }).then((value){

      setState(() {
        show_banner="Show Banner";
        show_inter="Show Inter";
      });
    });

  }



  @override
  void initState() {
    _getAds();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            centerTitle: false,
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text("Ads Settings"),
            actions: [
              IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> App()));

                  },icon: Icon(Icons.home)
              )
            ]
        ),
        body: Container(
          child: GridView.count(
              childAspectRatio: 5/4,
              crossAxisCount: 2,
              children: [
                Card(
                 child: Container(
                   padding: EdgeInsets.all(40),
                   child: StreamBuilder<QuerySnapshot>(
                      stream: firestore.collection("Ads").snapshots(),
                     builder: (context, s){
                        if(s.hasData){
                          var d=s.data!.docs;
                          return ListView.builder(
                            itemCount: d.length,
                              itemBuilder: (_, i){
                                return ListTile(
                                  title: Column(
                                    children: [
                                      Text("Banner ID : ${d[i]['banner_id']}"),
                                      SizedBox(height: 40,),
                                      Text("Banner Test ID : ${d[i]['banner_test_id']}"),

                                      SizedBox(height: 40,),
                                      Text("Show Banner : ${d[i]['show_banner']}"),
                                      SizedBox(height: 60,),
                                      Text("Inter ID : ${d[i]['inter_id']}"),
                                      SizedBox(height: 40,),
                                      Text("Inter Test ID : ${d[i]['inter_test_id']}"),
                                      SizedBox(height: 40,),
                                      Text("Show Inter : ${d[i]['show_inter']}"),
                                    ],
                                  ),
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
                   )
                 ),
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            child: Text("Banner ID"),
                          ),
                          Container(
                            child: TextFormField(
                              controller: bannerIdController,
                              onChanged: (v){
                                setState(() {
                                  banner_id=v;
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: "Banner ID"
                              ),
                              validator: (v){

                                if(v==null || v.isEmpty){
                                  return "Banner ID is input required.";
                                }
                                return null;

                              },
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                              width: 1000,
                              child: DropdownButtonFormField<String>(
                                validator: (v){
                                  if(v==null || v.isEmpty || v=="Show Banner"){
                                    return "Show Banner field is selected required.";
                                  }
                                  return null;

                                },
                                value: show_banner,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.black
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    show_banner = newValue!;
                                  });
                                },
                                items: _banners.map((g) {
                                  return DropdownMenuItem(
                                    child: new Text(g),
                                    value: g,
                                  );
                                }).toList(),
                              )
                          ),
                          SizedBox(height:50,),
                          Container(
                            child: Text("Inter ID"),
                          ),
                          Container(
                            child: TextFormField(
                              controller: interIDController,
                              onChanged: (v){
                                setState(() {
                                  inter_id=v;
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: "Inter ID"
                              ),
                              validator: (v){

                                if(v==null || v.isEmpty){
                                  return "Inter ID is input required.";
                                }
                                return null;

                              },
                            ),
                          ),
                          SizedBox(height:20,),

                          Container(
                              width: 1000,
                              child: DropdownButtonFormField<String>(
                                validator: (v){
                                  if(v==null || v.isEmpty || v=="Show Inter"){
                                    return "Show Inter field is selected required.";
                                  }
                                  return null;

                                },
                                value: show_inter,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.black
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    show_inter = newValue!;
                                  });
                                },
                                items: _inters.map((g) {
                                  return DropdownMenuItem(
                                    child: new Text(g),
                                    value: g,
                                  );
                                }).toList(),
                              )
                          ),
                          SizedBox(height:20,),
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
                                        saveAds();
                                      }
                                    },
                                  ),
                                )
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                )
              ],
          )
        ),
      ),
    );
  }
}

