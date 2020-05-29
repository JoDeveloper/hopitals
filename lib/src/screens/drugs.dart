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
      body: StreamBuilder<List<Pharmacy>>(
          stream: hospital.$pharmacy,
          builder: (context, snapshot) {
            print(snapshot.data);
            switch (snapshot.connectionState) {
              case ConnectionState.done:
              case ConnectionState.active:
                return ListView.separated(
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
                        leading: Image.asset('assets/icons8-pills-48.png'),
                        subtitle: Text(pharmacy.drugName),
                        trailing: Text(pharmacy.name),
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
