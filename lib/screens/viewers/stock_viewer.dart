import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:rt_market/global/modal.dart';
import 'package:rt_market/models/sql/produit.dart';
import 'package:rt_market/models/sql/stock.dart';
import 'package:rt_market/pages/widgets/custom_btn.dart';

import '../../index.dart';

class StockViewer extends StatefulWidget {
  const StockViewer({Key key}) : super(key: key);

  @override
  State<StockViewer> createState() => _StockViewerState();
}

class _StockViewerState extends State<StockViewer> {
  final textStockQte = TextEditingController();
  final textStockPrice = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Obx(() {
      return Expanded(
        child: sqlManagerController.stocks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Lottie.asset(
                        "assets/lotties/78460-shopping-cart.json",
                      ),
                    ),
                    Text(
                      "Veuillez ajouter les produits dans le stock !",
                      style: GoogleFonts.lato(
                        color: Colors.pink,
                        fontSize: 25.0,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
              )
            : listDetails(_size),
      );
    });
  }

  Widget listDetails(Size _size) {
    return Scrollbar(
      thickness: 10.0,
      hoverThickness: 15.0,
      isAlwaysShown: true,
      showTrackOnHover: true,
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, bottom: 20.0, top: 8.0),
          itemCount: sqlManagerController.stocks.length,
          itemBuilder: (context, index) {
            var data = sqlManagerController.stocks[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 5.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: ((index.isEven) ? Colors.white : Colors.blue[50]),
                border: Border(
                  right: BorderSide(color: Colors.blue[900], width: 3.0),
                  left: BorderSide(color: Colors.blue[900], width: 3.0),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.grey.withOpacity(.4),
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              height: 60.0,
              width: _size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.stockDateRef,
                            style: GoogleFonts.lato(
                                color: Colors.black87,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )),
                  Flexible(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.produitCode,
                            style: GoogleFonts.lato(
                                color: Colors.black87,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )),
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.only(right: 5.0),
                          child: Center(
                            child: imageFromBase64String(data.produitPhoto),
                          ),
                        ),
                        Text(data.produitLibelle,
                            style: GoogleFonts.lato(
                                color: Colors.black87,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  Flexible(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data.stockQteEntree} ${data.uniteLibelle}',
                            style: GoogleFonts.lato(
                                color: Colors.black87,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )),
                  Flexible(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data.stockQteSortie} ${data.uniteLibelle}',
                            style: GoogleFonts.lato(
                                color: Colors.black87,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )),
                  Flexible(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data.stockQteEntree - data.stockQteSortie} ${data.uniteLibelle}',
                            style: GoogleFonts.lato(
                                color: Colors.black87,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )),
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(color: Colors.blue[900]),
                            color: Colors.white,
                          ),
                          height: 40.0,
                          width: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(50.0),
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50.0),
                              onTap: () {
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
                                cleanField();
                                addStock(
                                  context,
                                  produit: selectedProduct,
                                  stock: selectedStock,
                                );
                              },
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.add,
                                  color: Colors.blue[900],
                                  size: 15.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(color: Colors.red),
                            color: Colors.white,
                          ),
                          height: 40.0,
                          width: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(50.0),
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50.0),
                              onTap: () async {
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

                                await deleteStock(
                                  context,
                                  produit: selectedProduct,
                                  stock: selectedStock,
                                );
                              },
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
              ),
            );
          }),
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
