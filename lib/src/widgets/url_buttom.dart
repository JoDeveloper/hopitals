import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UrlButton extends StatelessWidget {
  final String title;
  final void Function() onTap;

  const UrlButton({
    Key key,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Text(title,
            style: TextStyle(
              fontFamily: GoogleFonts.cairo().fontFamily,
              color: Colors.blue,
            )));
  }
}
