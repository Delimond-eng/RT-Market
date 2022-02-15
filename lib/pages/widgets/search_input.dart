import 'package:flutter/cupertino.dart';

import '../../index.dart';

class SearchProductInput extends StatelessWidget {
  final TextEditingController controller;
  final Function onSearched;
  final Function onSubmitted;
  const SearchProductInput(
      {this.controller, this.onSearched, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.8),
        border: Border.all(color: Colors.cyan),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: 12.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Flexible(
            child: TextField(
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.search,
              style: GoogleFonts.lato(
                  fontSize: 18.0, color: Colors.deepPurple[900]),
              keyboardType: TextInputType.number,
              controller: controller,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                hintText: "Entrez le code produit",
                contentPadding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
                hintStyle: GoogleFonts.lato(
                  color: Colors.grey[400],
                  fontSize: 18.0,
                ),
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
          Container(
            height: 60.0,
            width: 100.0,
            // ignore: deprecated_member_use
            child: RaisedButton(
              elevation: 0,
              color: Colors.cyan,
              child:
                  const Icon(CupertinoIcons.shopping_cart, color: Colors.white),
              onPressed: onSearched,
            ),
          )
        ],
      ),
    );
  }
}
