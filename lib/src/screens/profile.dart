import 'dart:async';

import 'package:around_hospital/src/widgets/url_buttom.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/hospital_service.dart';
import '../widgets/alert.dart';
import '../widgets/text_field.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  StreamSubscription _errorSubscription;
  bool isLoggedIn = false;
  bool showLogin = true;

  @override
  void initState() {
    super.initState();
    var hospital = Provider.of<HospitalService>(context, listen: false);
    _isLoggedIn();
    _errorSubscription = hospital.$error.listen((error) {
      if (error != '' || error == null) {
        AppAlerts.showAlertDialog(
                context: context, title: '😅  حدث خطأ', message: error)
            .then(
          (_) => hospital.clearErrorMessage(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var hospital = Provider.of<HospitalService>(context);
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SingleChildScrollView(
        child: (isLoggedIn == true)
            ? _loggedInWidget(context, hospital)
            : _logInWidget(context, hospital),
      ),
    );
  }

  void _isLoggedIn() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool _isLoggedIn = _prefs.getBool('isloggedIn') ?? false;
    setState(() {
      this.isLoggedIn = _isLoggedIn;
    });
  }

  @override
  void dispose() {
    _errorSubscription.cancel();
    super.dispose();
  }

  Widget _logInWidget(BuildContext context, HospitalService hospital) {
    return (showLogin == false)
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height / 4),
                Text(
                  'تسجيل',
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 25),
                StreamBuilder<String>(
                  stream: hospital.$name,
                  builder: (context, snapshot) {
                    return AppTextField(
                      hintText: 'الاسم',
                      prefixIcon: Icons.person,
                      onchanged: hospital.inName,
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
                StreamBuilder<String>(
                  stream: hospital.$password,
                  builder: (context, snapshot) {
                    return AppTextField(
                      hintText: 'كلمه السر',
                      obscureText: true,
                      prefixIcon: Icons.lock,
                      onchanged: hospital.inPassword,
                      errorText: snapshot.error,
                    );
                  },
                ),
                const SizedBox(height: 25),
                StreamBuilder<bool>(
                    stream: hospital.$loading,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == false)
                        return RaisedButton(
                          onPressed: () => hospital.register().then((value) {
                            if (value) {
                              AppAlerts.showAlertDialog(
                                      context: context,
                                      message:
                                          '''   ربنا يجعلها في ميزان حسناتك أن شاء الله.... اتأكد من المستشفى قبل الإضافة واتذكر إنو في ناس ممكن حياتهم تكون مرتبطة بي المعلومة دي''',
                                      title: '✋😄   مرحب بيك ')
                                  .then((value) {
                                setState(() {
                                  isLoggedIn = true;
                                });
                              });
                            }
                          }),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'تسجيل',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          elevation: 5,
                          splashColor: Colors.blueGrey,
                        );
                      return CircularProgressIndicator();
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    UrlButton(
                      title: 'تسجيل الدخول',
                      onTap: () {
                        setState(() {
                          showLogin = true;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      'لديك حساب',
                      style: TextStyle(
                          fontFamily: GoogleFonts.cairo().fontFamily,
                          color: Colors.blueGrey),
                    ),
                  ],
                )
              ],
            ),
          )
        : _login(context, hospital);
  }

  Widget _loggedInWidget(BuildContext context, HospitalService hospital) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 25,
          ),
          Image.asset(
            'assets/hospital.gif',
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: 15,
            child: Divider(),
          ),
          GestureDetector(
              child: Image.asset('assets/hospital.png'),
              onTap: () =>
                  Navigator.of(context).pushNamed('add', arguments: 1)),
          Text('إضافة مستشفى', style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          SizedBox(
            height: 25,
            child: Divider(),
          ),
          GestureDetector(
              child: Image.asset('assets/pharmacy.png'),
              onTap: () =>
                  Navigator.of(context).pushNamed('add', arguments: 2)),
          SizedBox(height: 10),
          Text('إضافة صيدلية', style: TextStyle(fontSize: 20)),
          SizedBox(
            height: 35,
            child: Divider(),
          ),
        ],
      ),
    );
  }

  Widget _login(BuildContext context, HospitalService hospital) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height / 4),
        Text(
          'تسجيل الدخول',
          style: TextStyle(fontSize: 25),
        ),
        const SizedBox(height: 25),
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
        StreamBuilder<String>(
          stream: hospital.$password,
          builder: (context, snapshot) {
            return AppTextField(
              hintText: 'كلمه السر',
              obscureText: true,
              prefixIcon: Icons.lock,
              onchanged: hospital.inPassword,
              errorText: snapshot.error,
            );
          },
        ),
        const SizedBox(height: 25),
        StreamBuilder<bool>(
          stream: hospital.$loading,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == false)
              return RaisedButton(
                onPressed: () => hospital.login().then((value) {
                  if (value) {
                    setState(() {
                      isLoggedIn = true;
                    });
                  }
                }),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'تسجيل الدخول',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                elevation: 5,
                splashColor: Colors.blueGrey,
              );
            return CircularProgressIndicator();
          },
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            UrlButton(
              title: 'أفتح حساب',
              onTap: () => setState(() => this.showLogin = false),
            ),
            const SizedBox(
              width: 30,
            ),
            Text(
              'ليس لديك حساب',
              style: TextStyle(
                  fontFamily: GoogleFonts.cairo().fontFamily,
                  color: Colors.blueGrey),
            ),
          ],
        )
      ],
    ));
  }
}

//void _launchURL() async {
//  const url = 'fb://profile/jodeveloper8';
//  if (await canLaunch(url)) {
//    await launch(url);
//  } else {
//    print('Could not launch $url');
//  }
//}
