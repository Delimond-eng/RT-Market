import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:rt_market/global/modal.dart';
import 'package:rt_market/models/sql/produit.dart';
import 'package:rt_market/models/sql/stock.dart';
import 'package:rt_market/pages/widgets/custom_btn.dart';

import '../index.dart';

class StockAddPage extends StatefulWidget {
  const StockAddPage({Key key}) : super(key: key);

  @override
  _StockAddPageState createState() => _StockAddPageState();
}

class _StockAddPageState extends State<StockAddPage> {
  final textStockPrice = TextEditingController();
  final textStockQte = TextEditingController();
  final textSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Ajout stock"),
            const SizedBox(
              width: 80.0,
            ),
            Flexible(
              child: Container(
                height: 50.0,
                width: 500,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 12.0,
                          color: Colors.grey.withOpacity(.4),
                          offset: const Offset(0, 3))
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: TextField(
                  controller: textSearch,
                  onChanged: (String text) {
                    try {
                      var stocks = dbManagerController.productList;
                      var searched = stocks
                          .where(
                            (element) =>
                                element.produitTitre.toLowerCase().contains(
                                      text.toLowerCase(),
                                    ),
                          )
                          .toList();
                      if (searched.isEmpty) {
                        return;
                      } else if (text == "") {
                        dbManagerController.getDatas();
                        return;
                      } else {
                        dbManagerController.productList.value = searched;
                      }
                    } catch (e) {
                      print('error from $e');
                    }
                  },
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.lato(fontSize: 15.0),
                  decoration: InputDecoration(
                    hintText: "Recherche produit par nom...",
                    contentPadding: const EdgeInsets.only(top: 12, bottom: 10),
                    hintStyle: GoogleFonts.lato(color: Colors.black54),
                    icon: Container(
                        height: 50.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Icon(CupertinoIcons.search,
                            size: 20.0, color: primaryColor)),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.teal,
        actions: const [
          UserBox(
            color: Colors.teal,
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
            child: sqlManagerController.stocks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          "assets/lotties/78460-shopping-cart.json",
                          height: 250.0,
                          width: 250.0,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Stock vide",
                          style: GoogleFonts.lato(
                            color: Colors.pink,
                            fontSize: 25.0,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  )
                : Scrollbar(
                    isAlwaysShown: true,
                    hoverThickness: 12.0,
                    showTrackOnHover: true,
                    thickness: 10.0,
                    child: Obx(
                      () {
                        return GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 2.10,
                                  crossAxisSpacing: 20.0,
                                  mainAxisSpacing: 20.0),
                          itemCount: sqlManagerController.stocks.length,
                          itemBuilder: (context, index) {
                            var data = sqlManagerController.stocks[index];
                            return ProductCard(
                                image: data.produitPhoto,
                                title: data.produitLibelle,
                                pu: int.parse(data.produitPrix),
                                qte: data.stockQteEntree,
                                onRemove: () async {
                                  Product selectedProduct = Product(
                                    produitCode: data.produitCode,
                                    produitId: data.produitId,
                                    produitPhoto: data.produitPhoto,
                                    produitLibelle: data.produitLibelle,
                                    produitPrix: data.produitPrix,
                                  );
                                  Stocks selectedStock = Stocks(
                                    produitId: data.produitId,
                                    stockId: data.stockId,
                                    stockQteEntree: data.stockQteEntree,
                                    stockQteSortie: data.stockQteSortie,
                                  );
                                  deleteStock(
                                    context,
                                    produit: selectedProduct,
                                    stock: selectedStock,
                                  );
                                },
                                onAdding: () {
                                  Product selectedProduct = Product(
                                    produitCode: data.produitCode,
                                    produitId: data.produitId,
                                    produitPhoto: data.produitPhoto,
                                    produitLibelle: data.produitLibelle,
                                    produitPrix: data.produitPrix,
                                  );
                                  Stocks selectedStock = Stocks(
                                    produitId: data.produitId,
                                    stockId: data.stockId,
                                    stockQteEntree: data.stockQteEntree,
                                    stockQteSortie: data.stockQteSortie,
                                  );
                                  addStock(
                                    context,
                                    produit: selectedProduct,
                                    stock: selectedStock,
                                  );
                                });
                          },
                        );
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  addStock(
    context, {
    Product produit,
    Stocks stock,
  }) {
    Modal.show(
      context,
      height: 300.0,
      width: 800,
      icon: CupertinoIcons.shopping_cart,
      title: "Ajout stock du produit : ${produit.produitLibelle}",
      modalContent: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              height: 200.0,
              width: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: MemoryImage(
                    base64Decode(produit.produitPhoto),
                  ),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CostumerInput(
                    controller: textStockQte,
                    title: "Quantité stock",
                    hintText: "Entrez la quantité stock... Ex. 20",
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  CostumerInput(
                    controller: textStockPrice,
                    title: "Prix unitaire",
                    hintText: "Entrez le prix unitaire (optionnel) ex. 1000",
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  BigBtn(
                    color: Colors.green,
                    fontSize: 16.0,
                    height: 60.0,
                    icon: Icons.check,
                    iconSize: 18.0,
                    onPressed: () async {
                      if (textStockQte.text.isEmpty) {
                        XDialog.showErrorMessage(context,
                            color: Colors.amber[900],
                            title: "Saisie obligatoire",
                            message:
                                "vous devez entrer la quantité du stock...");
                        return;
                      }

                      int oldStock = stock.stockQteEntree;
                      int newStock = int.parse(textStockQte.text);
                      int currentStock = oldStock + newStock;

                      Stocks s = Stocks(
                        stockQteEntree: currentStock,
                      );
                      var updatedId = await SqliteDbHelper.update(
                        tableName: "stocks",
                        values: s.toMap(),
                        where: "stock_id",
                        whereArgs: [stock.stockId],
                      );
                      if (updatedId != null && textStockPrice.text.isNotEmpty) {
                        var p = Product(
                          produitPrix: textStockPrice.text,
                        );
                        var updateProductId = await SqliteDbHelper.update(
                          tableName: "produits",
                          values: p.toMap(),
                          where: "produit_id",
                          whereArgs: [produit.produitId],
                        );
                        print(updateProductId);
                      }
                      if (updatedId != null) {
                        print(updatedId);
                        cleanField();
                        Get.back();
                        XDialog.showSuccessAnimation(context);
                      }
                      await sqlManagerController.initData();
                    },
                    radius: 5.0,
                    title: "valider",
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  deleteStock(
    context, {
    Product produit,
    Stocks stock,
  }) async {
    XDialog.show(
      context: context,
      icon: Icons.help,
      title: "Attention ! Cette action est irréversible",
      content: "Etes-vous sûr de vouloir supprimer définitivement ce stock ?",
      onValidate: () async {
        var lastDeletedId = await SqliteDbHelper.delete(
          tableName: "produits",
          where: "produit_id",
          whereArgs: [produit.produitId],
        );
        print(lastDeletedId);

        var lastStockDeletedId = await SqliteDbHelper.delete(
          tableName: "stocks",
          where: "produit_id",
          whereArgs: [produit.produitId],
        );
        print(lastStockDeletedId);
        await sqlManagerController.initData();
        Get.back();
      },
    );
  }

  cleanField() {
    setState(() {
      textStockPrice.text = "";
      textStockQte.text = "";
    });
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String image;
  final int pu;
  final int qte;
  final Function onAdding;
  final Function onRemove;
  const ProductCard({
    Key key,
    this.title,
    this.image,
    this.pu,
    this.qte,
    this.onAdding,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      // ignore: deprecated_member_use
      overflow: Overflow.visible,
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: imageFromBase64String(image, radius: 15.0),
                  ),
                  const SizedBox(width: 20.0),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.lato(
                              color: Colors.purple[900],
                              fontSize: 20.0,
                              letterSpacing: 1.50,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            "Prix Unitaire",
                            style: GoogleFonts.lato(
                              color: Colors.grey,
                              fontSize: 14.0,
                              letterSpacing: 1.50,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            "$pu CDF",
                            style: GoogleFonts.lato(
                              color: Colors.purple[900],
                              fontSize: 18.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            child: Center(
              child: Text(
                "QTE : $qte",
                style: GoogleFonts.lato(
                  color: Colors.white,
                  letterSpacing: 1.50,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            height: 50.0,
            width: 150.0,
            decoration: BoxDecoration(
              color: Colors.purple[900],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(color: Colors.purple[900]),
                  color: Colors.purple[50],
                ),
                height: 40.0,
                width: 40.0,
                child: Material(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50.0),
                    onTap: onAdding,
                    child: Center(
                      child: Icon(Icons.add,
                          color: Colors.purple[900], size: 15.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(color: Colors.red),
                  color: Colors.red[50],
                ),
                height: 40.0,
                width: 40.0,
                child: Material(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50.0),
                    onTap: onRemove,
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.trash,
                        color: Colors.red,
                        size: 15.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
