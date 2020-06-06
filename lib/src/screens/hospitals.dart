import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/hospital.dart';
import '../services/hospital_service.dart';
import '../widgets/alert.dart';

class Hospitals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hospital = Provider.of<HospitalService>(context);
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: StreamBuilder<List<Hospital>>(
          stream: hospital.$hospital,
          builder: (context, snapshot) {
            // print(snapshot.data);
            switch (snapshot.connectionState) {
              case ConnectionState.done:
              case ConnectionState.active:
                return (snapshot.data.length != 0)
                    ? ListView.separated(
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Hospital hospital = snapshot.data[index];
                          return GestureDetector(
                            onTap: () => AppAlerts.showAlertDialog(
                              context: context,
                              title: hospital.name,
                              message:
                                  '${hospital.details} \n ${hospital.phone ?? ''}',
                            ),
                            child: ListTile(
                              leading: Image.asset(
                                'assets/hospital-icon.png',
                                width: MediaQuery.of(context).size.width/10,
                                fit: BoxFit.fill,
                              ),
                              subtitle: Text(
                                hospital.phone ?? '',
                                style: TextStyle(fontSize: 10),
                              ),
                              trailing: Text(
                                hospital.name,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/empty.gif',
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.height / 6),
                      Text('ماف بينات لسه',style: Theme.of(context).textTheme.headline6,)
                    ],
                  ),
                );
              case ConnectionState.none:
              case ConnectionState.waiting:
              default:
                return Center(child: CircularProgressIndicator(backgroundColor: Colors.green,));
            }
          }),
    );
  }
}
