import 'package:flutter/cupertino.dart';
import 'package:rt_market/global/modal.dart';
import 'package:rt_market/widgets/custom_dropdown.dart';

import '../../index.dart';

class CartInput extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController unite;
  final productId;
  const CartInput({Key key, this.controller, this.productId, this.unite})
      : super(key: key);

  @override
  State<CartInput> createState() => _CartInputState();
}

class _CartInputState extends State<CartInput> {
  String unite;
  @override
  void initState() {
    super.initState();
    widget.controller.text = '1';
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Container(
      height: 60.0,
      width: _size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurpleAccent, width: 1.0),
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: 12.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 60,
              width: _size.width,
              child: TextField(
                textAlign: TextAlign.center,
                controller: widget.controller,
                style: GoogleFonts.lato(
                    fontSize: 25.0, color: Colors.deepPurpleAccent),
                keyboardType: TextInputType.number,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Quantité...",
                  contentPadding: const EdgeInsets.only(top: 16, bottom: 16),
                  hintStyle: GoogleFonts.lato(
                      color: Colors.black38,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
                padding: const EdgeInsets.only(top: 2.0, left: 2.0),
                height: 60.0,
                width: _size.width,
                child: Container(
                  height: 60.0,
                  child: CustomDropdown(
                    selectedValue: unite,
                    hintText: "unité",
                    items: ["g", "Kg"],
                    onChanged: (value) {
                      setState(() {
                        unite = value.toString();
                      });
                      widget.unite.text = unite;
                    },
                  ),
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 29.0,
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                ),

                // ignore: deprecated_member_use
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      try {
                        setState(() {
                          int currentValue = int.parse(widget.controller.text);
                          var current = venteController.cartList.where(
                              (p) => p.productId.contains(widget.productId));
                          for (var i in current) {
                            if (currentValue >= i.stock) {
                              XDialog.showErrorMessage(
                                context,
                                color: Colors.amber[800],
                                title: "Attention !",
                                message:
                                    "vous ne devez pas depasser la quantité par rapport au stock actuel !",
                              );
                              return;
                            } else {
                              currentValue++;
                            }
                          }
                          widget.controller.text = (currentValue).toString();
                        });
                        venteController.initCartTotal();
                      } catch (e) {}
                    },
                    child: const Icon(
                      CupertinoIcons.add,
                      color: Colors.white,
                      size: 15.0,
                    ),
                  ),
                ),
              ),
              Container(
                height: 29.0,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                ),
                // ignore: deprecated_member_use
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      try {
                        setState(() {
                          int currentValue = int.parse(widget.controller.text);
                          currentValue--;
                          widget.controller.text =
                              (currentValue >= 1 ? currentValue : 1).toString();
                        });
                        venteController.initCartTotal();
                      } catch (e) {}
                    },
                    child: const Icon(
                      CupertinoIcons.minus,
                      color: Colors.white,
                      size: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
