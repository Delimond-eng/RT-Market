import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:printing/printing.dart';
import 'package:rt_market/global/modal.dart';
import 'package:rt_market/models/print_model.dart';
import 'package:rt_market/services/print_service.dart';

import '../index.dart';
import 'widgets/cart_card_widget.dart';
import 'widgets/custom_btn.dart';
import 'widgets/custom_clock_widget.dart';
import 'widgets/search_input.dart';
import 'widgets/trade_box_widget.dart';

import 'package:pdf/pdf.dart';

class VentePage extends StatefulWidget {
  VentePage({Key key}) : super(key: key);

  @override
  _VentePageState createState() => _VentePageState();
}

class _VentePageState extends State<VentePage> {
  DateTime date = DateTime.now();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController costumerName = TextEditingController();
  final TextEditingController costumerPhoneNumber = TextEditingController();
  String getEmptyText;

  Future<void> validTrade(context) async {
    costumerName.text = "";
    costumerPhoneNumber.text = "";
    try {
      var cart = venteController.cartList;
      List<Map<String, dynamic>> maps = [];

      for (int i = 0; i < cart.length; i++) {
        Vente vente = Vente(
          venteProduitId: convertToObjectId(cart[i].productId),
          venteQte: cart[i].quantity,
          venteUnite: cart[i].unite.text,
          venteVendeurId: dbManagerController.logUser.value.vendeurId,
          venteStatus: "ok",
        );
        maps.add(vente.toMap());
      }
      if (maps.isEmpty) {
        Get.back();
        XDialog.showErrorMessage(
          context,
          color: Colors.amber[800],
          title: "Avertissement! Panier vide",
          message: "veuillez insérer des produits dans le panier virtuel !",
        );
        return;
      }
      if (maps.length == cart.length) {
        var res = await DBHelper.makeVente(maps: maps);
        if (res != null) {
          Get.back();
          XDialog.showSuccessAnimation(context);

          List<Product> products = [];
          int i = 0;
          venteController.cartList.forEach((e) {
            Product p = Product(
              unite: e.unite.text,
              n: i + 1,
              productName: e.productName,
              price: e.productPrice.toDouble(),
              quantity: e.quantity,
            );
            i++;

            products.add(p);
          });
          await Printing.layoutPdf(
              onLayout: (format) => generateInvoice(format, products));
          venteController.cancelCartProcess();
          dbManagerController.getDatas();
          inventoryController.refreshDatas();
        }
      }
    } catch (error) {
      print("error from valid statment $error");
    }
  }

  Future<Uint8List> generateInvoice(
      PdfPageFormat pageFormat, List<Product> products) async {
    final invoice = Invoice(
      products: products,
      tax: .0,
      baseColor: PdfColors.teal,
      accentColor: PdfColors.blueGrey900,
    );
    return await invoice.buildPdf(pageFormat);
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        backgroundColor: Colors.deepPurpleAccent,
        leading: const Icon(
          CupertinoIcons.shopping_cart,
          size: 30.0,
        ),
        title: Text(
          "Vente des produits".toUpperCase(),
          style: GoogleFonts.lato(
              fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: 1.0),
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const UserBox(color: Colors.deepPurpleAccent),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.calendar_today,
                          size: 15.0,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          dateFromString(date),
                          style: GoogleFonts.lato(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Row(
                      children: [
                        const Icon(CupertinoIcons.time_solid, size: 15.0),
                        const SizedBox(
                          width: 8.0,
                        ),
                        ClockWidget()
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/market2.jpg"),
              fit: BoxFit.cover),
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(.8)),
          child: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SearchProductInput(
                          controller: searchController,
                          onSubmitted: (String text) {
                            if (text.isNotEmpty) {
                              venteController.addItemToCart(
                                productId: text.trim(),
                              );
                              searchController.text = "";
                            } else {
                              XDialog.showErrorMessage(
                                context,
                                color: Colors.amber[900],
                                title: "Avertissement !",
                                message:
                                    "vous devez saisir le code du produit, pour effectuer cette opération !",
                              );
                            }
                          },
                          onSearched: () {
                            if (searchController.text.isNotEmpty) {
                              venteController.addItemToCart(
                                productId: searchController.text.trim(),
                              );
                              searchController.text = "";
                            } else {
                              XDialog.showErrorMessage(
                                context,
                                color: Colors.amber[900],
                                title: "Avertissement !",
                                message:
                                    "vous devez saisir le code du produit, pour effectuer cette opération !",
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        BigBtn(
                          color: Colors.cyan,
                          height: 80.0,
                          fontSize: 16.0,
                          iconSize: 15.0,
                          icon: Icons.qr_code_scanner,
                          title: "SCANNER LES PRODUITS",
                          radius: 0.0,
                          onPressed: () {
                            var now = DateTime.now().timeZoneOffset;
                            print(now);
                            /*List<Product> products = [];
                            int i = 0;
                            venteController.cartList.forEach((e) {
                              Product p = Product(
                                n: i + 1,
                                productName: e.productName,
                                price: e.productPrice.toDouble(),
                                quantity: e.quantity,
                              );
                              i++;

                              products.add(p);
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrinterPage(
                                  products: products,
                                ),
                              ),
                            );*/
                          },
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            width: _size.width,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(.3),
                                  blurRadius: 12.0,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.keyboard,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      "Clavier virtuel",
                                      style: GoogleFonts.lato(
                                          fontSize: 18.0,
                                          letterSpacing: 1.0,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: buildKeypad(context),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                cartBox(context),
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 5.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    width: _size.width,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.3),
                          blurRadius: 12.0,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Obx(() {
                          return TradeBox(
                            color: Colors.blue,
                            title: "HT",
                            value: "${venteController.cartTotal.value}.00 FC",
                          );
                        }),
                        const SizedBox(height: 10.0),
                        // ignore: prefer_const_constructors
                        TradeBox(
                          color: Colors.teal,
                          title: "TVA",
                          value: "0 FC",
                        ),
                        const SizedBox(height: 10.0),
                        Obx(() {
                          return TradeBox(
                            color: Colors.green,
                            title: "Net à payer",
                            value: "${venteController.cartTotal.value}.00 FC",
                          );
                        })
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildKeypad(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: keyboardBtn("9"), flex: 3),
              const SizedBox(width: 10.0),
              Flexible(child: keyboardBtn("8"), flex: 3),
              const SizedBox(width: 10.0),
              Flexible(child: keyboardBtn("7"), flex: 3),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: keyboardBtn("4"), flex: 3),
              const SizedBox(width: 10.0),
              Flexible(child: keyboardBtn("5"), flex: 3),
              const SizedBox(width: 10.0),
              Flexible(child: keyboardBtn("6"), flex: 3),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: keyboardBtn("1"), flex: 3),
              const SizedBox(width: 10.0),
              Flexible(child: keyboardBtn("2"), flex: 3),
              const SizedBox(width: 10.0),
              Flexible(child: keyboardBtn("3"), flex: 3),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: keyboardBtn("0"), flex: 3),
              const SizedBox(width: 10.0),
              Flexible(
                flex: 3,
                child: KeyBoardIconBtn(
                  icon: Icons.backspace_rounded,
                  color: Colors.grey[800],
                  onPressed: () {
                    try {
                      searchController.text = searchController.text
                          .substring(0, searchController.text.length - 1);
                    } catch (e) {}
                  },
                ),
              ),
              const SizedBox(width: 10.0),
              Flexible(
                flex: 3,
                child: KeyBoardIconBtn(
                  icon: CupertinoIcons.checkmark,
                  color: Colors.green[700],
                  onPressed: () {
                    if (searchController.text.isNotEmpty) {
                      venteController.addItemToCart(
                        productId: searchController.text.trim(),
                      );
                      searchController.text = "";
                    } else {
                      XDialog.showErrorMessage(
                        context,
                        color: Colors.amber[900],
                        title: "Avertissement !",
                        message:
                            "vous devez saisir le code du produit, pour effectuer cette opération !",
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Expanded cartBox(context) {
    return Expanded(
      flex: 8,
      child: Obx(() {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.3),
                blurRadius: 12.0,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 60.0,
                padding: const EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.shopping_cart,
                          color: Colors.deepPurpleAccent,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          "Panier",
                          style: GoogleFonts.lato(
                            fontSize: 18.0,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Items : ${venteController.cartList.length}",
                      style: GoogleFonts.lato(
                          color: Colors.deepPurpleAccent,
                          letterSpacing: 1,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: venteController.cartList.isEmpty
                      ? Center(
                          child: Lottie.asset(
                            "assets/lotties/69114-shopping-cart.json",
                            animate: true,
                            alignment: Alignment.center,
                            height: 400.0,
                            width: 400.0,
                          ),
                        )
                      : Scrollbar(
                          thickness: 5.0,
                          hoverThickness: 5.0,
                          radius: const Radius.circular(10.0),
                          isAlwaysShown: true,
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 2,
                              crossAxisCount: 2,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                            ),
                            itemCount: venteController.cartList.length,
                            itemBuilder: (BuildContext context, int index) {
                              var list = venteController.cartList[index];
                              return CartItem(
                                list: list,
                                onRemovedItem: () {
                                  XDialog.show(
                                    context: context,
                                    icon: Icons.remove_shopping_cart_sharp,
                                    content:
                                        "Etes-vous sûr de vouloir supprimer ce produit au panier ?",
                                    title: "Suppression produit",
                                    onValidate: () {
                                      venteController.removeItemTocart(
                                        productId: list.productId,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.white.withOpacity(.8),
                    Colors.white.withOpacity(.8),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: BigBtn(
                        color: Colors.green,
                        radius: 0.0,
                        icon: CupertinoIcons.printer,
                        title: "VALIDER & IMPRIMER",
                        onPressed: () {
                          Modal.show(
                            context,
                            height: 300.0,
                            width: 500,
                            icon: CupertinoIcons
                                .person_crop_circle_fill_badge_checkmark,
                            title: "Client Check",
                            modalContent: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CostumerInput(
                                  controller: costumerName,
                                  title: "Nom complet",
                                  hintText:
                                      "Entrez le nom du client...(optionnel)",
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                CostumerInput(
                                  controller: costumerPhoneNumber,
                                  title: "Téléphone",
                                  hintText: "Entrez le téléphone du client...",
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                BigBtn(
                                  color: Colors.green,
                                  fontSize: 14.0,
                                  height: 60.0,
                                  icon: Icons.check,
                                  iconSize: 15.0,
                                  onPressed: () async {
                                    var res = await DBHelper.checkCostumer(
                                      nom: costumerName.text,
                                      phone: costumerPhoneNumber.text,
                                    );
                                    if (res != null) {
                                      res.forEach((e) {
                                        XDialog.showSuccessMessage(context,
                                            title: "Client existe !",
                                            message:
                                                "Nom client : ${e['client_nom']}\n\nTéléphone : ${e['client_phone']}");
                                      });
                                    }
                                    await Future.delayed(
                                        const Duration(seconds: 2));
                                    await validTrade(context);
                                  },
                                  radius: 5.0,
                                  title: "valider",
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Flexible(
                      child: BigBtn(
                        color: Colors.grey[800],
                        radius: 0.0,
                        icon: CupertinoIcons.clear,
                        title: "ANNULER LA VENTE EN COURS",
                        onPressed: () {
                          if (venteController.cartList.isNotEmpty) {
                            XDialog.show(
                              context: context,
                              icon: Icons.remove_shopping_cart_rounded,
                              title: "Attention !",
                              content:
                                  "Etes-vous sûr de vouloir annuler cette vente ?",
                              onValidate: () {
                                venteController.cancelCartProcess();
                              },
                            );
                          } else {
                            return;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  keyboardBtn(String buttonText) {
    return Container(
      height: 80.0,
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: Colors.deepPurpleAccent.withOpacity(.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        focusColor: Colors.blue.withOpacity(.7),
        hoverColor: Colors.blue.withOpacity(.7),
        highlightColor: Colors.blue.withOpacity(.7),
        onPressed: () {
          searchController.text = searchController.text + buttonText;
        },
        child: Center(
          child: Text(
            buttonText,
            style: GoogleFonts.lato(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    );
  }
}

class KeyBoardIconBtn extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  final Color color;
  const KeyBoardIconBtn({
    Key key,
    this.icon,
    this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: onPressed,
        child: Center(
            child: Icon(
          icon,
          color: Colors.white,
          size: 25.0,
        )),
      ),
    );
  }
}

class CostumerInput extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hintText;
  const CostumerInput({
    this.controller,
    this.title,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.deepPurple,
        ),
        color: Colors.white.withOpacity(.8),
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: 12.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Container(
            height: 50.0,
            width: 110.0,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(3.5),
                topLeft: Radius.circular(3.5),
              ),
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurpleAccent],
              ),
            ),
            // ignore: deprecated_member_use
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Flexible(
            child: TextField(
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                  fontSize: 15.0,
                  color: Colors.deepPurple[900],
                  fontWeight: FontWeight.w400),
              keyboardType: TextInputType.number,
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                contentPadding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                hintStyle: GoogleFonts.lato(
                    color: Colors.grey[600],
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
