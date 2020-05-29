import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatefulWidget {
  final String hintText;
  final String initialText;
  final IconData prefixIcon;
  final bool obscureText;
  final int maxLength;
  final int maxLines;
  final TextInputType textInputType;
  final void Function(String) onchanged;
  final String errorText;

  const AppTextField({
    Key key,
    @required this.hintText,
    @required this.prefixIcon,
    this.obscureText = false,
    this.textInputType = TextInputType.text,
    @required this.onchanged,
    @required this.errorText,
    this.maxLength,
    this.maxLines,
    this.initialText,
  }) : super(key: key);

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  TextEditingController textEditingController = TextEditingController();
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextField(
        obscureText: widget.obscureText,
        textAlign: TextAlign.right,
        controller: (widget.initialText != null)
            ? (textEditingController..text = widget.initialText)
            : textEditingController,
        enabled: widget.initialText == null ? true : false,
        textDirection: TextDirection.rtl,
        onChanged: widget.onchanged,
        keyboardType: widget.textInputType,
        maxLength: widget.maxLength ?? null,
        maxLines: widget.maxLines ?? 1,
        style: TextStyle(
            fontFamily: GoogleFonts.ubuntu().fontFamily, fontSize: 20.0),
        decoration: InputDecoration(
          counterText: '',
          errorText: widget.errorText,
          prefixIcon: Icon(widget.prefixIcon),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          hintText: widget.hintText,
          border: InputBorder.none,
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 3),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey, width: 3),
            borderRadius: BorderRadius.circular(30),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey, width: 3),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 3),
            borderRadius: BorderRadius.circular(30),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.red, width: 3),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
