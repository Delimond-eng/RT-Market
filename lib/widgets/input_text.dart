import 'package:flutter/cupertino.dart';

import '../index.dart';
import 'custom_dropdown.dart';

class InputText extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController uniteController;
  final String hintText;
  final IconData icon;
  final TextInputType keyType;
  final String title;
  final bool isRequired;
  final bool isPassword;
  final bool isDropped;
  final bool isUnite;
  final bool isDroppedOnly;
  final Color color;
  final String errorText;
  final Widget suffixChild;

  const InputText({
    Key key,
    this.controller,
    this.hintText,
    this.icon,
    this.keyType,
    this.title,
    this.isRequired = false,
    this.isDropped = false,
    this.color,
    this.isPassword = false,
    this.isDroppedOnly = false,
    this.uniteController,
    this.isUnite = false,
    this.errorText,
    this.suffixChild,
  }) : super(key: key);

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  String devise;
  String unite;
  bool _isObscure = true;
  String roles;

  @override
  Widget build(BuildContext context) {
    return widget.keyType != TextInputType.datetime
        ? TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return widget.errorText;
              } else {
                return null;
              }
            },
            controller: widget.controller,
            keyboardType: widget.keyType ?? TextInputType.text,
            decoration: InputDecoration(
              labelText: widget.title,
              hintText: "${widget.hintText}...",
              errorStyle: const TextStyle(
                color: Colors.red,
                fontSize: 14.0,
              ),
              counterText: '',
              hintStyle: TextStyle(
                color: Colors.grey[500],
              ),
              prefixIcon: Icon(
                widget.icon,
                color: Colors.black,
                size: 20.0,
              ),
              suffix: widget.suffixChild,
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue[900],
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          )
        : (widget.isPassword)
            ? TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return widget.errorText;
                  } else {
                    return null;
                  }
                },
                controller: widget.controller,
                keyboardType: TextInputType.text,
                obscureText: _isObscure,
                style: GoogleFonts.lato(fontSize: 15.0),
                decoration: InputDecoration(
                  labelText: widget.title,
                  hintText: widget.hintText,
                  hintStyle: GoogleFonts.lato(color: Colors.black38),
                  icon: Icon(
                    CupertinoIcons.lock,
                    color: Colors.grey[100],
                    size: 20,
                  ),
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue[900],
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  counterText: '',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                    ),
                    color: Colors.black54,
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              )
            : TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return widget.errorText;
                  } else {
                    return null;
                  }
                },
                // maxLength: 10,
                keyboardType: TextInputType.datetime,
                controller: widget.controller,
                decoration: InputDecoration(
                  labelText: widget.title,
                  hintText: 'JJ / MM / AAAA',
                  hintStyle: const TextStyle(color: Colors.black38),
                  prefixIcon: Icon(
                    widget.icon,
                    color: Colors.black87,
                    size: 20,
                  ),
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue[900],
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  counterText: '',
                ),
                inputFormatters: [
                  // ignore: deprecated_member_use
                  WhitelistingTextInputFormatter(RegExp("[0-9/]")),
                  LengthLimitingTextInputFormatter(10),
                  DateFormatter(),
                ],
              );
  }
}
