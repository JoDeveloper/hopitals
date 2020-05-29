import 'package:flutter/material.dart';

import 'drugs.dart';
import 'hospitals.dart';
import 'profile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: true,
                centerTitle: true,
                title: Text(
                  "👩🏽‍⚕️ نحن معاك 👨🏽‍⚕️",
                  style: TextStyle(fontSize: 20),
                ),
                backgroundColor: Colors.blue,
                bottom: TabBar(
                  unselectedLabelColor: Colors.white60,
                  labelColor: Colors.white,
                  indicatorColor: Colors.lightBlueAccent,
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.person),
                    ),
                    Tab(icon: Icon(Icons.local_pharmacy)),
                    Tab(
                      icon: Icon(Icons.local_hospital),
                    ),
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            children: <Widget>[Profile(), Drugs(), Hospitals()],
          ),
        ),
      ),
    );
  }
}
