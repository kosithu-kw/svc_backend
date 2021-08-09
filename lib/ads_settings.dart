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


  String show_banner_home="Show Banner Home";
  String show_banner_genre="Show Banner Genre";
  String show_banner_videos="Show Banner Videos";
  String show_banner_favorites="Show Banner Favorites";
  String show_inter_download="Show Inter Download";
  String show_inter_nav="Show Inter Nav";

  List<String> _banners_home=["Show Banner Home", "true", "false"];
  List<String> _banners_genre=["Show Banner Genre", "true", "false"];
  List<String> _banners_videos=["Show Banner Videos", "true", "false"];
  List<String> _banners_favorites=["Show Banner Favorites", "true", "false"];
  List<String> _inters_download=["Show Inter Download", "true", "false"];
  List<String> _inters_nav=["Show Inter Nav", "true", "false"];




  final _formKey = GlobalKey<FormState>();
  var bannerIdController=TextEditingController();
  var interIDController=TextEditingController();

  void saveAds()async{
    var r=await firestore.collection("Ads").get();
    var Id=r.docs.first.id;

    bool show_b_home=false;
    bool show_b_genre=false;
    bool show_b_videos=false;
    bool show_b_favorites=false;
    bool show_i_download=false;
    bool show_i_nav=false;

    setState(() {

      if(show_banner_home=="true"){
        show_b_home=true;
      }

      if(show_banner_genre=="true"){
        show_b_genre=true;
      }
      if(show_banner_videos=="true"){
        show_b_videos=true;
      }
      if(show_banner_favorites=="true"){
        show_b_favorites=true;
      }
      if(show_inter_download=="true"){
        show_i_download=true;
      }
      if(show_inter_nav=="true"){
        show_i_nav=true;
      }

    });



    firestore.collection("Ads").doc(Id).update({

      "show_banner_home":show_b_home,
      "show_banner_genre":show_b_genre,
      "show_banner_videos":show_b_videos,
      "show_banner_favorites":show_b_favorites,
      "show_inter_download":show_i_download,
      "show_inter_nav":show_i_nav

    }).then((value){
      _getAds();
    });

  }

  _getAds(){
    firestore.collection("Ads").get().then((v){
      var d=v.docs.first.data();

        setState(() {
          show_banner_home= d['show_banner_home'] ? "true" : "false";
          show_banner_genre= d['show_banner_genre'] ? "true" : "false";
          show_banner_videos= d['show_banner_videos'] ? "true" : "false";
          show_banner_favorites= d['show_banner_favorites'] ? "true" : "false";
          show_inter_download= d['show_inter_download'] ? "true" : "false";
          show_inter_nav= d['show_inter_nav'] ? "true" : "false";

        });

    });
  }



  @override
  void initState() {
    // TODO: implement initState

    _getAds();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ads Settings",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0x204665).withOpacity(1.0),
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
                                      Text("Show Banner Home : ${d[i]['show_banner_home']}"),
                                      SizedBox(height: 40,),
                                      Text("Show Banner Genre : ${d[i]['show_banner_genre']}"),

                                      SizedBox(height: 40,),
                                      Text("Show Banner Videos : ${d[i]['show_banner_videos']}"),
                                      SizedBox(height: 40,),
                                      Text("Show Banner Favorites : ${d[i]['show_banner_favorites']}"),
                                      SizedBox(height: 40,),
                                      Text("Show Inter Download : ${d[i]['show_inter_download']}"),
                                      SizedBox(height: 40,),
                                      Text("Show Inter Nav : ${d[i]['show_inter_nav']}"),
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
                              width: 1000,
                              child: DropdownButtonFormField<String>(
                                validator: (v){
                                  if(v==null || v.isEmpty){
                                    return "Show Banner Home field is selected required.";
                                  }
                                  return null;

                                },
                                value: show_banner_home,
                                icon: Text("Show Banner Home"),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.black
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    show_banner_home = newValue!;
                                  });
                                },
                                items: _banners_home.map((g) {
                                  return DropdownMenuItem(
                                    child: new Text(g),
                                    value: g,
                                  );
                                }).toList(),
                              )
                          ),
                          SizedBox(height:20,),

                          Container(
                              width: 1000,
                              child: DropdownButtonFormField<String>(
                                validator: (v){
                                  if(v==null || v.isEmpty){
                                    return "Show banner genre field is selected required.";
                                  }
                                  return null;

                                },
                                value: show_banner_genre,
                                icon: Text("Show Banner Genre"),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.black
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    show_banner_genre = newValue!;
                                  });
                                },
                                items: _banners_genre.map((g) {
                                  return DropdownMenuItem(
                                    child: new Text(g),
                                    value: g,
                                  );
                                }).toList(),
                              )
                          ),
                          SizedBox(height:20,),
                          Container(
                              width: 1000,
                              child: DropdownButtonFormField<String>(
                                validator: (v){
                                  if(v==null || v.isEmpty){
                                    return "Show banner videos field is selected required.";
                                  }
                                  return null;

                                },
                                value: show_banner_videos,
                                icon: Text("Show Banner Videos"),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.black
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    show_banner_videos = newValue!;
                                  });
                                },
                                items: _banners_videos.map((g) {
                                  return DropdownMenuItem(
                                    child: new Text(g),
                                    value: g,
                                  );
                                }).toList(),
                              )
                          ),
                          SizedBox(height:20,),
                          Container(
                              width: 1000,
                              child: DropdownButtonFormField<String>(
                                validator: (v){
                                  if(v==null || v.isEmpty){
                                    return "Show banner favorites field is selected required.";
                                  }
                                  return null;

                                },
                                value: show_banner_favorites,
                                icon: Text("Show Banner Favorites"),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.black
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    show_banner_favorites = newValue!;
                                  });
                                },
                                items: _banners_favorites.map((g) {
                                  return DropdownMenuItem(
                                    child: new Text(g),
                                    value: g,
                                  );
                                }).toList(),
                              )
                          ),
                          SizedBox(height:20,),
                          Container(
                              width: 1000,
                              child: DropdownButtonFormField<String>(
                                validator: (v){
                                  if(v==null || v.isEmpty){
                                    return "Show inter download field is selected required.";
                                  }
                                  return null;

                                },
                                value: show_inter_download,
                                icon: Text("Show Inter Download"),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.black
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    show_inter_download = newValue!;
                                  });
                                },
                                items: _inters_download.map((g) {
                                  return DropdownMenuItem(
                                    child: new Text(g),
                                    value: g,
                                  );
                                }).toList(),
                              )
                          ),
                          SizedBox(height:20,),
                          Container(
                              width: 1000,
                              child: DropdownButtonFormField<String>(
                                validator: (v){
                                  if(v==null || v.isEmpty){
                                    return "Show inter nav field is selected required.";
                                  }
                                  return null;

                                },
                                value: show_inter_nav,
                                icon: Text("Show Inter Nav"),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.black
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    show_inter_nav = newValue!;
                                  });
                                },
                                items: _inters_nav.map((g) {
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

