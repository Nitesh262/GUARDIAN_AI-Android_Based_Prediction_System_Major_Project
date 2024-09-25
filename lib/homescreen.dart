import 'dart:ffi';

import 'package:fake_news_detection/login_page.dart';
import 'package:fake_news_detection/twitterBotPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'fakeNews.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: appBarColor.withOpacity(0.6),
                title: Text("Guardian AI",style: TextStyle(fontSize: 27,fontWeight: FontWeight.w600),),
                leading: Icon(Icons.security_outlined,size: 30,),
                actions: [IconButton(onPressed: (){}, icon: Icon(Icons.account_circle,size: 30,)),
                  IconButton(onPressed: (){
                    logout(context);
                  }, icon: Icon(Icons.logout,size: 30,))],
                bottom: const TabBar(
                  dividerColor: Colors.blue,
                  tabs: [
                    Text("Fake News",style: TextStyle(fontSize: 25,fontWeight:FontWeight.w500),),
                    Text("Twitter Bot",style: TextStyle(fontSize: 25,fontWeight:FontWeight.w500),)
                  ],),
              ),
                body:  TabBarView(                  children: [
                    FakeNews(),
                    Twitter()
                    //Icon(Icons.directions_transit),
                  ],),
              ),
            ));
  }




  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => login()));
  }


}
