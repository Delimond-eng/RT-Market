import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown(
      {Key key, this.items, this.onChanged, this.selectedValue, this.hintText})
      : super(key: key);
  final List<dynamic> items;
  final dynamic selectedValue;
  final Function(dynamic value) onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<dynamic>(
      menuMaxHeight: 300,
      dropdownColor: Colors.white,
      alignment: Alignment.centerRight,
      borderRadius: BorderRadius.circular(5.0),
      style: GoogleFonts.lato(color: Colors.black),
      value: selectedValue,
      underline: SizedBox(),
      hint: Text(
        " $hintText",
        style: GoogleFonts.mulish(
          color: Colors.grey[600],
          fontSize: 16.0,
        ),
      ),
      isExpanded: true,
      items: items.map((e) {
        return DropdownMenuItem<String>(
          value: e,
          child: Text(
            "$e",
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
