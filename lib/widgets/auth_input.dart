import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rt_market/global/style.dart';

class AuthInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassWord;
  final TextInputType keyType;

  AuthInput({
    Key key,
    this.controller,
    this.hintText,
    this.icon,
    this.isPassWord,
    this.keyType,
  }) : super(key: key);

  @override
  _AuthInputState createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            blurRadius: 12.0,
            color: Colors.grey.withOpacity(.4),
            offset: const Offset(0, 3))
      ], borderRadius: BorderRadius.circular(10.0), color: Colors.white),
      child: widget.isPassWord == false
          ? TextField(
              controller: widget.controller,
              style: GoogleFonts.lato(fontSize: 15.0),
              keyboardType: (widget.keyType == null)
                  ? TextInputType.text
                  : widget.keyType,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
                hintText: widget.hintText,
                hintStyle: GoogleFonts.lato(color: Colors.black54),
                icon: Container(
                  width: 80.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Icon(
                    widget.icon,
                    color: primaryColor,
                    size: 20.0,
                  ),
                ),
                border: InputBorder.none,
                counterText: '',
              ),
            )
          : TextField(
              controller: widget.controller,
              keyboardType: (widget.keyType == null)
                  ? TextInputType.text
                  : widget.keyType,
              obscureText: _isObscure,
              style: GoogleFonts.lato(fontSize: 15.0),
              decoration: InputDecoration(
                  hintText: widget.hintText,
                  contentPadding: const EdgeInsets.only(top: 15, bottom: 10),
                  hintStyle: GoogleFonts.lato(color: Colors.black54),
                  icon: Container(
                      height: 50.0,
                      width: 80.0,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Icon(CupertinoIcons.lock,
                          size: 20.0, color: primaryColor)),
                  border: InputBorder.none,
                  counterText: '',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 15,
                    ),
                    color: Colors.black54,
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )),
            ),
    );
  }
}
