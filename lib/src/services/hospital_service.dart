import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/hospital.dart';
import '../model/pharmacy.dart';

class HospitalService {
  HospitalService() {
    Timer.periodic(Duration(seconds: 3), (Timer t) {
      _getHospitals();
      _getPharmacies();
    });
  }

  final String url = 'http://hospital.jodeveloper.com/api';
  final _hospitals = BehaviorSubject<List<Hospital>>();
  final _pharmacies = BehaviorSubject<List<Pharmacy>>();
  final _name = BehaviorSubject<String>();
  final _phone = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _error = BehaviorSubject<String>();
  final _city = BehaviorSubject<String>();
  final _drugName = BehaviorSubject<String>();
  final _details = BehaviorSubject<String>();
  final _hospitalName = BehaviorSubject<String>();
  final _loading = BehaviorSubject<bool>.seeded(false);

  Stream<String> get $name => _name.stream.transform(nameTransformer);

  Stream<String> get $hospitalName =>
      _hospitalName.stream.transform(hospitalName);

  Stream<String> get $phone => _phone.stream;

  Stream<String> get $password =>
      _password.stream.transform(passwordTransformer);

  Stream<bool> get $loading => _loading.stream;

  Stream<String> get $error => _error.stream;

  Stream<String> get $city => _city.stream.transform(hospitalCity);

  Stream<String> get $details => _details.stream.transform(hospitalDetails);

  Stream<String> get $drugName => _drugName.stream.transform(drugName);

  Stream<List<Hospital>> get $hospital => _hospitals.stream;

  Stream<List<Pharmacy>> get $pharmacy => _pharmacies.stream;

  Stream<bool> get isValidLogin =>
      CombineLatestStream.combine2($phone, $password, (a, b) => true);

  Stream<bool> get isValidRegister =>
      CombineLatestStream.combine3($name, $phone, $password, (a, b, c) => true);

  Stream<bool> get isValidHospital => CombineLatestStream.combine3(
      $hospitalName, $city, $details, (a, b, c) => true);

  Stream<bool> get isValidPharmacy => CombineLatestStream.combine3(
      $hospitalName, $city, $drugName, (a, b, c) => true);

  Function(String) get inName => _name.sink.add;

  Function(String) get inError => _error.sink.add;

  Function(String) get inPhone => _phone.sink.add;

  Function(String) get inCity => _city.sink.add;

  Function(String) get inDetails => _details.sink.add;

  Function(String) get inDrugName => _drugName.sink.add;

  Function(String) get inPassword => _password.sink.add;

  Function(String) get inHospitalName => _hospitalName.sink.add;

  Function(List<Hospital>) get inHospital => _hospitals.sink.add;

  Function(List<Pharmacy>) get inPharmacy => _pharmacies.sink.add;

  Future<void> _getHospitals() async {
    try {
      http.Response response = await http.get('$url/hospitals');
      if (response.statusCode == 200) {
        List parsedJson = convert.jsonDecode(response.body);
        List<Hospital> hospitals =
            parsedJson.map((e) => Hospital.fromJson(e)).toList();
        inHospital(hospitals);
      }
    } on HttpException catch (e) {
      print(e.message);
    }
  }

  Future<void> _getPharmacies() async {
    try {
      http.Response response = await http.get('$url/pharmacy');
      if (response.statusCode == 200) {
        List parsedJson = convert.jsonDecode(response.body);
        List<Pharmacy> pharmacies =
            parsedJson.map((e) => Pharmacy.fromJson(e)).toList();
        inPharmacy(pharmacies);
      }
    } on HttpException catch (e) {
      print(e.message);
    }
  }

  Future<bool> login() async {
    bool loggedIn = false;
    if (_phone.value == null || _password.value == null) {
    } else {
      _loading.sink.add(true);
      try {
        http.Response response = await http.post('$url/user/login', body: {
          'phone': _phone.value,
          'password': _password.value,
        });
        if (response.statusCode == 200) {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          _prefs.setBool('isloggedIn', true);
          inPhone('');
          loggedIn = true;
        }
      } on HttpException catch (e) {
        print(e.message);
      }
      _loading.sink.add(false);
    }

    return loggedIn;
  }

  Future<bool> register() async {
    bool loggedIn = false;
    if (_phone.value == null ||
        _name.value == null ||
        _password.value == null) {
    } else {
      _loading.sink.add(true);
      try {
        http.Response response = await http.post('$url/user/register', body: {
          'name': _name.value,
          'phone': _phone.value,
          'password': _password.value,
        });
        var parsedJson = convert.jsonDecode(response.body);
        if (response.statusCode == 200) {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          _prefs.setBool('isloggedIn', true);
          loggedIn = true;
        }
        if (response.statusCode == 403) {
          List errors = parsedJson['errors'] as List;
          var errorString = StringBuffer();
          errors.forEach((e) => errorString.writeln('- ' + e[0]));
          inError(errorString.toString());
        }
      } on HttpException catch (e) {
        print(e.message);
      }
      _loading.sink.add(false);
    }

    return loggedIn;
  }

  Future<bool> addHospital() async {
    bool added = false;
    if (_hospitalName.value != null ||
        _city.value == null ||
        _details.value == null) {
//      inError('اتأكد من البينات');
    } else {
      added = false;
      _loading.sink.add(true);
      try {
        http.Response response = await http.post('$url/hospitals', body: {
          'phone': _phone.value ?? '',
          'city': _city.value,
          'name': _hospitalName.value,
          'details': _details.value,
        });

        if (response.statusCode == 200) {
          _getHospitals();
          inPhone('');
          inCity('');
          inName('');
          inDetails('');
          added = true;
        }
      } on HttpException catch (e) {
        inError(e.message);
        print(e.message);
      }
      _loading.sink.add(false);
    }
    return added;
  }

  Future<bool> addPharmacy() async {
    bool added = false;
    if (_hospitalName.value != null ||
        _city.value == null ||
        _drugName.value == null) {
//      inError('اتأكد من البينات');
    } else {
      added = false;
      _loading.sink.add(true);
      try {
        http.Response response = await http.post('$url/pharmacy', body: {
          'phone': _phone.value ?? '',
          'city': _city.value,
          'name': _hospitalName.value,
          'drugName': _drugName.value,
        });
        print(convert.jsonDecode(response.body));
        if (response.statusCode == 200) {
          _getPharmacies();
          inPhone('');
          inCity('');
          inName('');
          inDrugName('');
          added = true;
        }
      } on HttpException catch (e) {
        inError(e.message);
        print(e.message);
      }
      _loading.sink.add(false);
    }

    return added;
  }

  void clearErrorMessage() {
    inError('');
  }

  //transformers
  final nameTransformer =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.trim().contains(' ')) {
      sink.add(name.trim());
    } else {
      sink.addError('أكتب إسمك كامل ');
    }
  });

  final phoneTransformer = StreamTransformer<String, String>.fromHandlers(
    handleData: (phone, sink) {
      if (phone.trim().startsWith('0') && phone.trim().length == 10) {
        sink.add(phone.trim());
      } else {
        sink.addError('رقمك غير صحيح');
      }
    },
  );

  final passwordTransformer = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.trim().length == 6) {
        sink.add(password.trim());
      } else {
        sink.addError('الباسوورد مفروض تتكون  6 أقل شئ');
      }
    },
  );

  final hospitalName = StreamTransformer<String, String>.fromHandlers(
    handleData: (name, sink) {
      if (name.trim().length > 10) {
        sink.add(name.trim());
      } else {
        sink.addError('إتاكد من الإسم');
      }
    },
  );

  final hospitalCity = StreamTransformer<String, String>.fromHandlers(
    handleData: (city, sink) {
      if (city.trim().length > 6) {
        sink.add(city.trim());
      } else {
        sink.addError('إتاكد من المنطقة');
      }
    },
  );

  final hospitalDetails = StreamTransformer<String, String>.fromHandlers(
    handleData: (details, sink) {
      if (details.trim().length != 0) {
        sink.add(details.trim());
      } else {
        sink.addError('أكتب كل التفاصيل (الإقسام - رقم التلفون - وقت العمل)');
      }
    },
  );

  final drugName = StreamTransformer<String, String>.fromHandlers(
    handleData: (details, sink) {
      if (details.trim().length > 6) {
        sink.add(details.trim());
      } else {
        sink.addError('إسم الدواء');
      }
    },
  );

  //dispose
  void dispose() {
    _hospitals.close();
    _pharmacies.close();
    _name.close();
    _phone.close();
    _password.close();
    _loading.close();
    _error.close();
    _city.close();
    _details.close();
    _drugName.close();
    _hospitalName.close();
  }
}
