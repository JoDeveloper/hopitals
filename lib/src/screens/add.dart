import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/hospital_service.dart';
import '../widgets/text_field.dart';

class AddHospital extends StatefulWidget {
  final int type;

  const AddHospital({Key key, this.type}) : super(key: key);
  @override
  _AddHospitalState createState() => _AddHospitalState();
}

class _AddHospitalState extends State<AddHospital> {
  @override
  Widget build(BuildContext context) {
    String title = (widget.type == 1) ? 'إضافة مستشفى' : 'إضافة دواء';
    String hospitalName = (widget.type == 1) ? 'إسم المستشفى' : 'إسم الصيدلية';
    var hospital = Provider.of<HospitalService>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 5),
              Text(
                title,
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(height: 25),
              StreamBuilder<String>(
                stream: hospital.$hospitalName,
                builder: (context, snapshot) {
                  return AppTextField(
                    hintText: hospitalName,
                    prefixIcon: (widget.type == 1)
                        ? Icons.local_hospital
                        : Icons.local_pharmacy,
                    onchanged: hospital.inHospitalName,
                    errorText: snapshot.error,
                  );
                },
              ),
              StreamBuilder<String>(
                stream: hospital.$city,
                builder: (context, snapshot) {
                  return AppTextField(
                    hintText: ' اسم المنطقة',
                    prefixIcon: Icons.business,
                    onchanged: hospital.inCity,
                    errorText: snapshot.error,
                  );
                },
              ),
              StreamBuilder<String>(
                stream: hospital.$phone,
                builder: (context, snapshot) {
                  return AppTextField(
                    hintText: 'رقم الهاتف',
                    prefixIcon: Icons.phone,
                    onchanged: hospital.inPhone,
                    textInputType: TextInputType.phone,
                    errorText: snapshot.error,
                  );
                },
              ),
              (widget.type == 1)
                  ? StreamBuilder<String>(
                      stream: hospital.$details,
                      builder: (context, snapshot) {
                        return AppTextField(
                          errorText: snapshot.error,
                          hintText: 'التفاصيل',
                          onchanged: hospital.inDetails,
                          prefixIcon: null,
                          maxLines: 8,
                        );
                      },
                    )
                  : StreamBuilder<String>(
                      stream: hospital.$drugName,
                      builder: (context, snapshot) {
                        return AppTextField(
                          errorText: snapshot.error,
                          hintText: 'إسم الدواء',
                          onchanged: hospital.inDrugName,
                          prefixIcon: Icons.fiber_smart_record,
                        );
                      },
                    ),
              SizedBox(height: 25),
              StreamBuilder<bool>(
                  stream: hospital.$loading,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data == false)
                      return RaisedButton(
                        onPressed: () {
                          if (widget.type == 1) {
                            hospital.addhospital().then((value) {
                              if (value) Navigator.of(context).pop();
                            });
                          } else {
                            hospital.addPharmacy().then((value) {
                              if (value) Navigator.of(context).pop();
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            ' إضافة',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        elevation: 5,
                        splashColor: Colors.blueGrey,
                      );
                    return CircularProgressIndicator();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
