import 'package:flutter/material.dart';

abstract class AppAlerts {
  static Future<void> showAlertDialog(
      {BuildContext context, String message, String title,Widget body}) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 15),
                ),
                Divider(
                  thickness: 3,
                  color: Colors.lightBlue,
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    message,
                    style: TextStyle(fontSize: 15),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  OutlineButton(
                    borderSide: BorderSide(
                      color: Colors.blueGrey,
                      width: 3,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'تمام',
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
