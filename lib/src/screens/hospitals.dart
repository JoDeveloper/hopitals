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
      body: StreamBuilder<List<Hospital>>(
          stream: hospital.$hospital,
          builder: (context, snapshot) {
            // print(snapshot.data);
            switch (snapshot.connectionState) {
              case ConnectionState.done:
              case ConnectionState.active:
                return ListView.separated(
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
                );
              case ConnectionState.none:
              case ConnectionState.waiting:
              default:
                return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
