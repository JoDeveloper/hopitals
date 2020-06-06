import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/pharmacy.dart';
import '../services/hospital_service.dart';
import '../widgets/alert.dart';

class Drugs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hospital = Provider.of<HospitalService>(context);
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: StreamBuilder<List<Pharmacy>>(
          stream: hospital.$pharmacy,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
              case ConnectionState.active:
                return (snapshot.data.length != 0)
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            Pharmacy pharmacy = snapshot.data[index];
                            return GestureDetector(
                              onTap: () => AppAlerts.showAlertDialog(
                                  context: context,
                                  title: pharmacy.name,
                                  message: pharmacy.drugName),
                              child: ListTile(
                                leading: Image.asset(
                                  'assets/icons8-pills-48.png',
                                  width: MediaQuery.of(context).size.width / 10,
                                ),
                                subtitle: Text(pharmacy.drugName),
                                trailing: Text(pharmacy.name),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset('assets/empty.gif',
                                width: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.height / 6),
                            Text(
                              'ماف بينات بخصوص الأدوية لسه',
                              style: Theme.of(context).textTheme.headline6,
                            )
                          ],
                        ),
                      );
              case ConnectionState.none:
              case ConnectionState.waiting:
              default:
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ));
            }
          }),
    );
  }
}
