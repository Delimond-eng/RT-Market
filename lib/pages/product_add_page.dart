import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:rt_market/global/modal.dart';
import 'package:rt_market/models/sql/produit.dart';
import 'package:rt_market/models/sql/stock.dart';
import 'package:rt_market/models/sql/unite.dart';

import '../index.dart';

class ProductAddPage extends StatefulWidget {
  const ProductAddPage({Key key}) : super(key: key);

  @override
  _ProductAddPageState createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  final textProduitTitre = TextEditingController();
  final textDateExpiration = TextEditingController();
  final textPrix = TextEditingController();
  final textQteEntree = TextEditingController();
  final textCodeProduit = TextEditingController();
  final textUnite = TextEditingController();

  Uint8List produitImage;
  String strImage = "";
  Unite selectedUnite;

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajout produit / stock"),
        actions: const [
          UserBox(
            color: Colors.purple,
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/market2.jpg"),
                fit: BoxFit.cover)),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(.85)),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    // ignore: deprecated_member_use
                    overflow: Overflow.visible,
                    children: [
                      Container(
                        height: 350.0,
                        width: _size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 12.0,
                              color: Colors.grey.withOpacity(.4),
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 40.0, bottom: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 500.0,
                                          child: InputText(
                                            title: "code produit",
                                            controller: textCodeProduit,
                                            errorText: "code produit requis !",
                                            hintText:
                                                "Entrez le code produit...",
                                            isRequired: true,
                                            icon: Icons.qr_code_rounded,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: InputText(
                                                errorText:
                                                    "désignation produit requis !",
                                                title: "Produit désignation",
                                                controller: textProduitTitre,
                                                isRequired: true,
                                                hintText:
                                                    "Entrez la désignation/nom du produit...",
                                                icon: Icons.new_label,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Flexible(
                                              child: InputText(
                                                title: "Date d'expiration",
                                                controller: textDateExpiration,
                                                keyType: TextInputType.datetime,
                                                isRequired: true,
                                                icon: Icons
                                                    .calendar_today_outlined,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: InputText(
                                                title: "Prix unitaire",
                                                controller: textPrix,
                                                isRequired: true,
                                                hintText:
                                                    "Entrez le prix unitaire du produit... ex: 1000",
                                                isDropped: true,
                                                icon:
                                                    CupertinoIcons.money_dollar,
                                                suffixChild: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                                  child: Text("CDF"),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Flexible(
                                              child: InputText(
                                                title: "Quantité",
                                                controller: textQteEntree,
                                                isUnite: true,
                                                isDropped: true,
                                                uniteController: textUnite,
                                                hintText:
                                                    "Entrez la quantité du produit... ex : 10",
                                                isRequired: true,
                                                icon: CupertinoIcons
                                                    .cube_box_fill,
                                                suffixChild: Stack(
                                                  children: [
                                                    Container(
                                                      width: 100.0,
                                                      height: 20.0,
                                                      child:
                                                          DropdownButton<Unite>(
                                                        menuMaxHeight: 300,
                                                        dropdownColor:
                                                            Colors.white,
                                                        alignment: Alignment
                                                            .centerRight,
                                                        borderRadius:
                                                            BorderRadius.zero,
                                                        style: GoogleFonts.lato(
                                                            color:
                                                                Colors.black),
                                                        value: selectedUnite,
                                                        underline:
                                                            const SizedBox(),
                                                        hint: Text(
                                                          "Unité",
                                                          style: GoogleFonts
                                                              .mulish(
                                                            color: Colors
                                                                .grey[600],
                                                            fontSize: 16.0,
                                                          ),
                                                        ),
                                                        isExpanded: true,
                                                        items:
                                                            sqlManagerController
                                                                .unites
                                                                .map((e) {
                                                          return DropdownMenuItem<
                                                              Unite>(
                                                            value: e,
                                                            child: Text(
                                                              e.uniteLibelle,
                                                              style: GoogleFonts
                                                                  .lato(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 18.0,
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                        onChanged: (value) {
                                                          print(value
                                                              .uniteLibelle);
                                                          setState(() {
                                                            selectedUnite =
                                                                value;
                                                          });
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30.0,
                                  ),
                                  CapPicker(
                                    icon: Icons.add_photo_alternate,
                                    title: "image du produit",
                                    image: produitImage,
                                    onPressed: () => pickedFile(context),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 60.0,
                                    width: 300.0,
                                    // ignore: deprecated_member_use
                                    child: RaisedButton.icon(
                                      elevation: 10.0,
                                      color: Colors.green[700],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      onPressed: () => saveProduct(context),
                                      icon: const Icon(Icons.add,
                                          color: Colors.white),
                                      label: Text(
                                        "Ajouter",
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Container(
                                    height: 60.0,
                                    width: 300.0,
                                    // ignore: deprecated_member_use
                                    child: RaisedButton.icon(
                                      elevation: 10.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      color: Colors.grey,
                                      onPressed: () async {
                                        clean();
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                        size: 15.0,
                                      ),
                                      label: Text(
                                        "Annuler",
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -12,
                        left: -12,
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 12.0,
                                    color: Colors.grey.withOpacity(.4),
                                    offset: const Offset(0, 4))
                              ],
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.deepPurpleAccent,
                                  Colors.purple
                                ],
                              )),
                          child: const Center(
                            child: Icon(CupertinoIcons.bag_fill_badge_plus),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveProduct(context) async {
    if (textProduitTitre.text.isEmpty) {
      Get.snackbar(
          "Avertissement !", "vous devez entrer la designation du produit!",
          snackPosition: SnackPosition.TOP,
          colorText: Colors.redAccent[100],
          backgroundColor: Colors.black45,
          maxWidth: 1000,
          borderRadius: 2);
      return;
    }

    if (textPrix.text.isEmpty) {
      Get.snackbar(
          "Avertissement !", "vous devez entrer le prix unitaire du produit!",
          snackPosition: SnackPosition.TOP,
          colorText: Colors.redAccent[100],
          backgroundColor: Colors.black45,
          maxWidth: 1000,
          borderRadius: 2);
      return;
    }
    /*if (strImage.isEmpty) {
      Get.snackbar(
          "Avertissement !", "vous devez charger la photo du produit !",
          snackPosition: SnackPosition.TOP,
          colorText: Colors.redAccent[100],
          backgroundColor: Colors.black45,
          maxWidth: 1000,
          borderRadius: 2);
      return;
    }*/
    if (textCodeProduit.text.isEmpty) {
      Get.snackbar(
        "Avertissement !",
        "vous devez entrez le code du produit !",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.redAccent[100],
        backgroundColor: Colors.black45,
        maxWidth: 1000,
        borderRadius: 2,
      );
      return;
    }

    ByteData byteData = await rootBundle.load('assets/images/app.jpg');
    Uint8List imageBytes = byteData.buffer.asUint8List();
    var b64 = base64Encode(imageBytes);
    Product produit = Product(
      produitCode: textCodeProduit.text,
      produitLibelle: textProduitTitre.text,
      produitDateExp: textDateExpiration.text ?? "",
      produitPrix: textPrix.text,
      uniteId: selectedUnite != null ? selectedUnite.uniteId : null,
      produitPhoto: b64,
    );
    try {
      var checkProductCode = await SqliteDbHelper.query(
        table: "produits",
        where: "produit_code",
        whereArgs: [textCodeProduit.text],
      );
      if (checkProductCode.isNotEmpty) {
        XDialog.showErrorMessage(
          context,
          color: Colors.amber[800],
          title: "Avertissement !",
          message:
              "Ce code produit entré existe déjà pour un autre produit!,\nveuillez jouter le stock du produit dans le sous-menu ajout stock!\nou changer seulement le code produit en cas d'une confusion !",
        );
        return;
      }
      var lastInsertId = await SqliteDbHelper.insert(
        tableName: "produits",
        values: produit.toMap(),
      );
      print(lastInsertId);
      //check if inserted !
      if (lastInsertId != null && textQteEntree.text.isNotEmpty) {
        Stocks stocks = Stocks(
          produitId: lastInsertId,
          stockQteEntree: int.parse(textQteEntree.text),
          uniteId: selectedUnite != null ? selectedUnite.uniteId : null,
          stockQteSortie: 0,
        );
        //check if new stock is already !
        var newStockId = await SqliteDbHelper.insert(
            tableName: "stocks", values: stocks.toMap());
        print(newStockId);
        XDialog.showSuccessAnimation(context);
        clean();
        await sqlManagerController.initData();
      }
    } catch (e) {
      print(e);
    }
  }

  clean({Unite u}) {
    setState(() {
      textQteEntree.text = "";
      selectedUnite = u;
      textPrix.text = "";
      textProduitTitre.text = "";
      textDateExpiration.text = "";
      textCodeProduit.text = "";
      produitImage = null;
      strImage = "";
    });
  }

  pickedFile(BuildContext context) async {
    Xloading.showLottieLoading(context);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        dialogTitle: "Chargement image",
      );
      Xloading.dismiss();
      if (result != null) {
        Xloading.dismiss();
        File file = File(result.files.single.path);
        Uint8List byteImages = file.readAsBytesSync();
        String strProduitImage = base64Encode(byteImages);
        setState(() {
          produitImage = byteImages;
          strImage = strProduitImage;
        });
      }
    } catch (err) {
      print(err);
    }
  }
}

class CapPicker extends StatefulWidget {
  final String title;
  final Function onPressed;
  final IconData icon;
  final Uint8List image;
  const CapPicker({
    Key key,
    this.title,
    this.onPressed,
    this.icon,
    this.image,
  }) : super(key: key);

  @override
  State<CapPicker> createState() => _CapPickerState();
}

class _CapPickerState extends State<CapPicker> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 150,
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
          ),
          child: Center(
            child: Text(
              '${widget.title} *',
              style: GoogleFonts.lato(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: widget.onPressed,
          onHover: (val) {
            setState(() {
              isHover = val;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isHover ? Colors.black : Colors.black54,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(5.0)),
            ),
            height: 170.0,
            width: 150,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                image: widget.image == null
                    ? null
                    : DecorationImage(
                        image: MemoryImage(widget.image),
                        fit: BoxFit.cover,
                      ),
              ),
              child: Center(
                child: Icon(widget.icon,
                    color: widget.image == null ? Colors.white : Colors.black),
              ),
            ),
          ),
        )
      ],
    );
  }
}
