import 'dart:convert';

import 'package:rt_market/models/cart_model.dart';

import '../../index.dart';
import 'cart_input_widget.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    @required this.list,
    this.onRemovedItem,
  });

  final Cart list;
  final Function onRemovedItem;

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Stack(
      // ignore: deprecated_member_use
      overflow: Overflow.visible,
      children: [
        Container(
          height: _size.height,
          width: _size.width,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.7),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(.25),
                  blurRadius: 12.0,
                  offset: const Offset(0, 3))
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 120.0,
                width: 120.0,
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: MemoryImage(
                      base64Decode(list.productImage),
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.3),
                      blurRadius: 12.0,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list.productName,
                        style: GoogleFonts.lato(
                          fontSize: 16.0,
                          letterSpacing: 1,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        "Prix unitaire",
                        style: GoogleFonts.lato(
                          fontSize: 12.0,
                          letterSpacing: 1,
                          color: Colors.black45,
                        ),
                      ),
                      Text(
                        "${list.productPrice} Fc",
                        style: GoogleFonts.lato(
                          fontSize: 18.0,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w900,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Flexible(
                        child: CartInput(
                          controller: list.controller,
                          unite: list.unite,
                          productId: list.productId,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              color: Colors.pink[300],
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    blurRadius: 12.0,
                    offset: const Offset(0, 3))
              ],
            ),
            child: IconButton(
              onPressed: onRemovedItem,
              icon: const Icon(
                Icons.clear,
                color: Colors.white,
                size: 18.0,
              ),
            ),
          ),
        )
      ],
    );
  }
}
