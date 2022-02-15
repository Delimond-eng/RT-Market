// ignore_for_file: deprecated_member_use

import 'package:mongo_dart/mongo_dart.dart';
import 'package:rt_market/index.dart';

import 'stock_model.dart';

class Inventory {
  ObjectId produitId;
  String produitTitre;
  String produitImage;
  List<Stock> stock;
  List<Vente> ventes;
  int get stockRestant => stock[0].stockEntree - stock[0].stockSortie;
  int get stockEntry => stock[0].stockEntree;
  int get stockSorty => stock[0].stockSortie;
  String get dateVente {
    return ventes[0].venteDate;
  }

  bool get isData => ventes[0].venteDate != null ? true : false;

  int get totalVentes =>
      stock[0].stockProduitPrixUnitaire * stock[0].stockSortie;

  int get pu => stock[0].stockProduitPrixUnitaire;
  String get status {
    if (stockRestant > 0) {
      return "en stock";
    } else {
      return "stock fini";
    }
  }

  Inventory({
    this.produitId,
    this.produitTitre,
    this.produitImage,
    this.stock,
    this.ventes,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    produitId = ObjectId();
    data["_id"] = produitId;
    data["produit_titre"] = produitTitre;
    if (stock != null) {
      data['stock'] = stock.map((v) => v.toMap()).toList();
    }
    if (ventes != null) {
      data['ventes'] = ventes.map((e) => e.toMap()).toList();
    }
    return data;
  }

  Inventory.fromMap(Map<String, dynamic> map) {
    produitId = ObjectId.fromHexString(map["_id"]);
    produitTitre = map["produit_titre"];
    if (map["stock"] != null) {
      stock = <Stock>[];
      map["stock"].forEach(
        (s) {
          stock.add(Stock.fromMap(s));
        },
      );
    }

    if (map['ventes'] != null) {
      ventes = <Vente>[];
      map["ventes"].forEach((e) {
        ventes.add(Vente.fromMap(e));
      });
    }
  }
}
